import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../classes/aggressor_api.dart';

part 'contact_us_event.dart';
part 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsBloc() : super(ContactUsState()) {
    on<ContactUsSendEmailEvent>((event, emit) async {
      emit(state.copyWith(
        isInitState: false,
        isLoading: true,
        isSuccess: false,
      ));


      var res = await AggressorApi().sendEmail(event.fName,event.lName,event.email,event.body,);
      // String? timeZoneString =


      emit(state.copyWith(
        isInitState: false,
        isLoading: false,
        isSuccess: true,
      ));
    });
  }
}
