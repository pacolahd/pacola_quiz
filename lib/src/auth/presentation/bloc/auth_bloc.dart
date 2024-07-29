import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/core/enums/update_user.dart';
import 'package:pacola_quiz/src/auth/domain/entities/user_entity.dart';
import 'package:pacola_quiz/src/auth/domain/usecases/forgot_password.dart';
import 'package:pacola_quiz/src/auth/domain/usecases/sign_in.dart';
import 'package:pacola_quiz/src/auth/domain/usecases/sign_in_with_google.dart';
import 'package:pacola_quiz/src/auth/domain/usecases/sign_up.dart';
import 'package:pacola_quiz/src/auth/domain/usecases/update_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required ForgotPassword forgotPassword,
    required UpdateUser updateUser,
    required SignInWithGoogle signInWithGoogle,
  })  : _signIn = signIn,
        _signUp = signUp,
        _forgotPassword = forgotPassword,
        _updateUser = updateUser,
        _signInWithGoogle = signInWithGoogle,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    on<SignInWithGoogleEvent>(_signInWithGoogleHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;
  final SignInWithGoogle _signInWithGoogle;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signInWithGoogleHandler(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signInWithGoogle();
    result.fold(
      (failure) {
        if (failure.statusCode == 'auth/sign-in-canceled') {
          emit(const AuthCanceled('Google sign-in was canceled'));
        } else {
          emit(AuthError(failure.errorMessage));
        }
      },
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const SignedUp()),
    );
  }

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(event.email);
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const UserUpdated()),
    );
  }
}
