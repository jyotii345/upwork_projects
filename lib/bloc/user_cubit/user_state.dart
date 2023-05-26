part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {
  final User? currentUser;
  UserInitial({required this.currentUser});
}
