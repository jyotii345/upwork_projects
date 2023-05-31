part of 'contact_us_bloc.dart';



class ContactUsState {
  final bool isLoading;
  final bool isInitState;
  final bool isError;
  final bool isSuccess;
  final bool isDeleted;
  final String msg;

  ContactUsState({
    this.isLoading = false,
    this.isInitState = true,
    this.isError = false,
    this.isSuccess = false,
    this.isDeleted = false,
    this.msg = "",
  });

  ContactUsState copyWith({
    bool? isLoading,
    bool? isInitState,
    bool? isError,
    bool? isSuccess,
    bool? isDeleted,
    String? msg,
  }) {
    return ContactUsState(
      isLoading: isLoading ?? this.isLoading,
      isInitState: isInitState ?? this.isInitState,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
      isDeleted: isDeleted ?? false,
      msg: msg ?? "",
    );
  }
}
