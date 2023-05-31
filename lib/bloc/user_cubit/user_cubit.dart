import 'package:aggressor_adventures/classes/user.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial(currentUser: null));


  setCurrentUser(User? user){
    emit(UserInitial(currentUser: user));
  }

}
