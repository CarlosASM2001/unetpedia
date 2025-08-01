part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.exception,
    this.showPassword = true,
    this.rememberMe = false,
    this.genericStatus = WidgetStatus.initial,
    this.photoSelected,
    this.degreeSelected,
    this.email,
    this.password,
    this.presignedStatus = WidgetStatus.initial,
  });

  // Generic
  final String? email;
  final String? password;
  final WidgetStatus genericStatus;
  final DataException? exception;

  // Login
  final bool showPassword;
  final bool rememberMe;

  // Register
  final PhotoModel? photoSelected;
  final CareerModel? degreeSelected;
  final WidgetStatus presignedStatus;

  // Forgot Password

  @override
  List<Object?> get props => [
    exception,
    genericStatus,
    showPassword,
    rememberMe,
    photoSelected,
    degreeSelected,
    email,
    password,
    presignedStatus,
  ];

  AuthenticationState copyWith({
    DataException? exception,
    WidgetStatus? genericStatus,
    bool? showPassword,
    bool? rememberMe,
    Wrapped<PhotoModel?>? photoSelected,
    Wrapped<CareerModel?>? degreeSelected,
    Wrapped<String?>? email,
    Wrapped<String?>? password,
    WidgetStatus? presignedStatus,
  }) {
    return AuthenticationState(
      exception: exception ?? this.exception,
      genericStatus: genericStatus ?? this.genericStatus,
      showPassword: showPassword ?? this.showPassword,
      rememberMe: rememberMe ?? this.rememberMe,
      photoSelected: photoSelected != null
          ? photoSelected.value
          : this.photoSelected,
      degreeSelected: degreeSelected != null
          ? degreeSelected.value
          : this.degreeSelected,
      email: email != null ? email.value : this.email,
      password: password != null ? password.value : this.password,
      presignedStatus: presignedStatus ?? this.presignedStatus,
    );
  }
}
