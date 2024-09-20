import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'event/login_event.dart';
part 'state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    // Registering the event handler for LoginButtonPressed event
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  // Event handler function for LoginButtonPressed
  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading()); // Emit the loading state

    try {
      // Simulating login logic (replace this with your own logic)
      await Future.delayed(const Duration(seconds: 2));

      // If login succeeds, emit the success state
      emit(LoginSuccess());
    } catch (error) {
      // If login fails, emit the failure state with the error
      emit(LoginFailure(error: error.toString()));
    }
  }
}
