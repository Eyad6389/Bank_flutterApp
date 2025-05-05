import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'bank_account_state.dart';

class BankAccountCubit extends Cubit<BankAccountState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BankAccountCubit() : super(BankAccountInitial());

  // Asynchronously loads the user's account data from Firestore.
  Future<void> loadAccountData() async {
    // Emit a loading state to indicate data fetching is in progress.
    emit(BankAccountLoading());
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Fetch the user document to get the full name and email.
        DocumentSnapshot userSnap =
            await _firestore.collection('users').doc(user.uid).get();
        // Fetch the account document to get the balance.
        DocumentSnapshot balanceSnap =
            await _firestore.collection('accounts').doc(user.uid).get();

        // Extract the full name from the user data, defaulting to 'User' if not found.
        String fullName =
            (userSnap.data() as Map<String, dynamic>?)?['fullName'] ?? 'User';
        // Extract the email from the user data, defaulting to 'email' if not found.
        String email =
            (userSnap.data() as Map<String, dynamic>?)?['email'] ?? 'email';
        // Extract the balance from the account data, defaulting to 0.0 if not found.
        double balance =
            (balanceSnap.data() as Map<String, dynamic>?)?['balance'] ?? 0.0;

        // If the account document doesn't exist, create it with default values.
        if (!balanceSnap.exists) {
          await _firestore.collection('accounts').doc(user.uid).set({
            'balance': 0.0,
            'transactions': [],
          });
          // If the 'transactions' field is null, initialize it as an empty list.
        } else if ((balanceSnap.data()
                as Map<String, dynamic>?)?['transactions'] ==
            null) {
          await _firestore
              .collection('accounts')
              .doc(user.uid)
              .update({'transactions': []});
        }

        // Emit a loaded state with the fetched account data.
        emit(BankAccountLoaded(
            balance: balance, fullName: fullName, email: email));
      } catch (e) {
        // Emit an error state if fetching account data fails.
        emit(BankAccountError(message: 'Failed to load account data: $e'));
      }
    } else {
      // Emit an error state if the user is not logged in.
      emit(BankAccountError(message: 'User not logged in.'));
    }
  }

  bool isProcessing = false;

  // Asynchronously updates the account balance (deposit or withdraw) and records the transaction.
  Future<void> updateBalance(
      double amount, bool isDeposit, BuildContext context) async {
    // Prevent concurrent transactions to avoid race conditions.
    if (isProcessing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your transaction is still processing")),
      );
      return;
    }

    // Ensure the current state is BankAccountLoaded before proceeding.
    if (state is! BankAccountLoaded) return;

    final currentState = state as BankAccountLoaded;
    User? user = _auth.currentUser;
    if (user == null) return;

    isProcessing = true; // Mark as processing

    DocumentReference ref = _firestore.collection('accounts').doc(user.uid);
    // Use a Firestore transaction to ensure atomicity of balance update and transaction recording.
    await _firestore.runTransaction((tx) async {
      DocumentSnapshot snap = await tx.get(ref);
      if (!snap.exists) throw Exception("Account missing");

      double currentBalance = (snap['balance'] ?? 0.0) as double;
      // Calculate the updated balance based on whether it's a deposit or withdrawal.
      double updatedBalance =
          isDeposit ? currentBalance + amount : currentBalance - amount;

      // Prevent withdrawal if there are insufficient funds.
      if (updatedBalance < 0 && !isDeposit)
        throw Exception("Insufficient funds");

      // Create a new transaction map.
      var txn = {
        'amount': amount,
        'type': isDeposit ? 'Deposit' : 'Withdraw',
        'timestamp': Timestamp.now(),
      };

      // Update the balance and add the new transaction to the transactions array.
      tx.update(ref, {
        'balance': updatedBalance,
        'transactions': FieldValue.arrayUnion([txn]),
      });

      // Emit a BalanceUpdated state with the new balance.
      emit(BalanceUpdated(
        balance: updatedBalance,
        fullName: currentState.fullName,
        email: currentState.email,
      ));

      // Pop the dialog after a successful transaction.
      Navigator.of(context).pop();

      // Show a success snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${isDeposit ? 'Deposited' : 'Withdrawn'} $amount successfully.')),
      );
    }).catchError((e) {
      // Show an error snackbar if the transaction fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    });

    // End processing after a short delay to allow the snackbar to be seen.
    await Future.delayed(const Duration(seconds: 2));
    isProcessing = false;
  }

  // Asynchronously deletes all transaction history for the current user.
  Future<void> deleteTransactions(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    // Fetch the user's account document.
    DocumentSnapshot accountSnap =
        await _firestore.collection('accounts').doc(user.uid).get();

    if (accountSnap.exists) {
      // Get the list of transactions from the account data.
      final transactions = (accountSnap.data()
          as Map<String, dynamic>?)?['transactions'] as List<dynamic>?;

      // Proceed only if there are transactions to delete.
      if (transactions != null && transactions.isNotEmpty) {
        // Show a confirmation dialog to the user before deleting.
        bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text(
                  'Are you sure you want to delete all transactions? This action cannot be undone.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );

        // If the user confirmed the deletion.
        if (confirmed == true) {
          // Update the 'transactions' field in the account document to an empty array.
          DocumentReference ref =
              _firestore.collection('accounts').doc(user.uid);
          await ref.update({'transactions': []});
          // If the current state is BankAccountLoaded, re-emit it to trigger a UI update if needed.
          if (state is BankAccountLoaded) {
            emit(BankAccountLoaded(
              balance: (state as BankAccountLoaded).balance,
              fullName: (state as BankAccountLoaded).fullName,
              email: (state as BankAccountLoaded).email,
            ));
            // Show a success snackbar.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Transactions deleted successfully.')),
            );
          }
        }
      } else {
        // Show a snackbar if there are no transactions to delete.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No transactions to delete.')),
        );
      }
    } else {
      // Show a snackbar if the account document is not found.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account not found.')),
      );
    }
  }
}
