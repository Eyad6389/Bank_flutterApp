import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const TransactionsList({required this.firestore, required this.auth});

  @override
  Widget build(BuildContext context) {
    // Returns a StreamBuilder that listens to changes in the user's account document.
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore
          .collection('accounts')
          .doc(auth.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        // While the data is loading, display a centered circular progress indicator.
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Get the document data as a map, defaulting to an empty map if null.
        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        // Extract the 'transactions' list from the data, defaulting to an empty list if null.
        final txns = List.from(data['transactions'] ?? []);

        // If there are no transactions, display a message indicating that.
        if (txns.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text("No transactions yet.")),
          );
        }

        // Display the list of transactions using ListView.separated for better performance and separators.
        return ListView.separated(
          shrinkWrap: true,
          // Prevents the ListView from scrolling within its parent.
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: txns.length,
          // Adds a divider between each transaction item.
          separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
          itemBuilder: (context, index) {
            // Get the transaction at the reversed index to display the latest transactions first.
            var t = txns[txns.length - 1 - index];
            return _TransactionItem(transaction: t);
          },
        );
      },
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Display an icon based on the transaction type (Deposit or Withdrawal).
      leading: Icon(
        transaction['type'] == 'Deposit' ? Icons.arrow_upward : Icons.arrow_downward,
        color: transaction['type'] == 'Deposit' ? Colors.green : Colors.redAccent,
      ),
      // Display the transaction type in bold.
      title: Text('${transaction['type']}',
          style: const TextStyle(fontWeight: FontWeight.w500)),
      // Display the formatted timestamp of the transaction.
      subtitle: Text(
          (transaction['timestamp'] as Timestamp).toDate().toString()),
      // Display the transaction amount in bold with the currency.
      trailing: Text('${transaction['amount']} EGP',
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}