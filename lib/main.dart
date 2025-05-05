import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Cubit/bank_account_cubit.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/Homescreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import BlocProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure this is outside

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MainApp()); // Ensure this runs after Firebase initializes
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        // Wrap Homescreen with BlocProvider
        create: (context) => BankAccountCubit(), // Create your Cubit
        child: const Homescreen(),
      ),
    );
  }
}
