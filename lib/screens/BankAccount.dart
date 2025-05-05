import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Cubit/bank_account_cubit.dart';
import 'package:flutter_application_1/widgets/_header_section.dart';
import 'package:flutter_application_1/widgets/_section_title.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/screens/Homescreen.dart';
import 'package:flutter_application_1/services/NewsBar.dart';
import 'package:flutter_application_1/screens/profilepage.dart';
import 'package:flutter_application_1/widgets/_delete_transactions_button.dart';
import 'package:flutter_application_1/widgets/_transactions_list.dart';
import 'package:flutter_application_1/widgets/confirmlogoutalert.dart';

class BankAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the height of the screen
    final screenHeight = MediaQuery.of(context).size.height;
    // Get the width of the screen
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => BankAccountCubit()..loadAccountData(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          // This callback is invoked when a pop attempt is made.
          // 'didPop' is true if the pop completed, false otherwise.
          // 'result' is the data passed back from the popped route, if any.
          if (!didPop) {
            // If the pop was not handled by the system (e.g., back button press),
            // show a confirmation dialog for logout.
            final confirm = await confirmlogoutscreen(context);
            if (confirm) {
              Navigator.of(context)
                  .pop(); // Only pop the current route if the user confirms.
            }
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                // Show a confirmation dialog before navigating back to the Homescreen.
                final confirm = await confirmlogoutscreen(context);
                if (confirm) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Homescreen()),
                    (route) =>
                        false, // Remove all existing routes from the stack.
                  );
                }
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xff6D52D1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white)),
                child: IconButton(
                    onPressed: () async {
                      // Get the current logged-in user.
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        // Fetch the user document from Firestore.
                        final userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .get();
                        // Get the user data from the document.
                        final userData = userDoc.data();
                        // Extract the full name and email from the user data, providing defaults if null.
                        final name = userData?['fullName'] ?? 'No Name';
                        final email = user.email ?? 'No Email';
                        // Navigate to the ProfilePage, replacing the current route.
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              name: name,
                              email: email,
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                      // Set the size of the icon based on screen height.
                      size: screenHeight * 0.04,
                    )),
              ),
              SizedBox(
                // Add some horizontal space between the profile icon and the edge of the screen.
                width: screenWidth * 0.03,
              ),
            ],
          ),
          backgroundColor: Colors.grey[100],
          body: BlocConsumer<BankAccountCubit, BankAccountState>(
            listener: (context, state) {
              // Listen for specific states emitted by the BankAccountCubit.
              if (state is BankAccountError) {
                // If an error state is emitted, show a snackbar with the error message.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              // Build the UI based on the current state of the BankAccountCubit.
              if (state is BankAccountLoading) {
                // While data is being loaded, show a circular progress indicator.
                return const Center(child: CircularProgressIndicator());
              } else if (state is BankAccountLoaded) {
                // When the account data is loaded, display the main content.
                return Stack(
                  children: [
                    CustomScrollView(
                      controller: ScrollController(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: HeaderSection(
                            fullName: state.fullName,
                            balance: state.balance,
                            onDepositTap: () =>
                                _showTransactionDialog(context, true),
                            onWithdrawTap: () =>
                                _showTransactionDialog(context, false),
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                          ),
                        ),
                        SliverToBoxAdapter(child: NewsBar()),
                        const SectionTitle(title: 'Recent Transactions'),
                        SliverToBoxAdapter(
                          child: TransactionsList(
                              firestore: FirebaseFirestore.instance,
                              auth: FirebaseAuth.instance),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                              height: 60), // Space for the fixed button
                        ),
                      ],
                    ),
                    DeleteTransactionsButton(
                        onDeleteTap: () => context
                            .read<BankAccountCubit>()
                            .deleteTransactions(context)),
                  ],
                );
              } else {
                // If any other state occurs (e.g., initial or unexpected), show a generic error message.
                return const Center(child: Text('Something went wrong.'));
              }
            },
          ),
        ),
      ),
    );
  }

  // Function to display a dialog for depositing or withdrawing funds.
  void _showTransactionDialog(BuildContext context, bool isDeposit) {
    // Get the BankAccountCubit instance from the current context.
    final cubit = context.read<BankAccountCubit>();
    // Create a TextEditingController to manage the input in the dialog's text field.
    final amountController = TextEditingController();

    // Show an AlertDialog to get the transaction amount from the user.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isDeposit ? 'Deposit Amount' : 'Withdraw Amount'),
          content: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Enter Amount',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                amountController
                    .clear(); // Clear the text field when the dialog is cancelled.
              },
            ),
            ElevatedButton(
              child: Text(isDeposit ? 'Deposit' : 'Withdraw'),
              onPressed: () async {
                // Attempt to parse the entered amount as a double. If parsing fails, default to 0.0.
                double amount = double.tryParse(amountController.text) ?? 0.0;
                // Check if the entered amount is greater than zero.
                if (amount > 0) {
                  try {
                    // Call the updateBalance method in the BankAccountCubit to perform the deposit or withdrawal.
                    await cubit.updateBalance(amount, isDeposit, context);
                  } catch (e, stackTrace) {
                    // If an error occurs during the updateBalance operation, print the error and stack trace for debugging.
                    print('Error during updateBalance: $e');
                    print('StackTrace: $stackTrace');
                    // Optionally show an error message to the user via a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'An error occurred during the transaction.')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
