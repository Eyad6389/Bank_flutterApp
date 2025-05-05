part of 'bank_account_cubit.dart';


abstract class BankAccountState {}

class BankAccountInitial extends BankAccountState {}

class BankAccountLoading extends BankAccountState {}


class BankAccountLoaded extends BankAccountState {
  final double balance;
  final String fullName;
  final String email;

  BankAccountLoaded({
    required this.balance,
    required this.fullName,
    required this.email,
  });
}

class BankAccountError extends BankAccountState {
  final String message;

  BankAccountError({required this.message});
}

class BalanceUpdated extends BankAccountLoaded {
  BalanceUpdated({
    required double balance,
    required String fullName,
    required String email,
  }) : super(balance: balance, fullName: fullName, email: email);
}