
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/core/common/snackbar.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_register_usecase.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_state.dart';





class RegisterViewModel  extends Bloc<RegisterEvent, RegisterState>{

  final UserRegisterUsecase _registerUsecase;
  
  RegisterViewModel({
    required UserRegisterUsecase registerUsecase,


  }) : _registerUsecase = registerUsecase,
  super(RegisterState.initial()){
    on<RegisterUserEvent>(_registerUserEvent);
  }

  Future<void> _registerUserEvent(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  )async{
    emit(state.copyWith(isLoading: true));
    final result = await _registerUsecase(
      RegisterUserParams(
      username: event.username,
      email : event.email,
      password: event.password,

      )
    );

    result.fold(
      (failure){
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: 'Failed to register : ${failure.message}',
          color: Colors.red,

        );
      },
      

      (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: ' Registered successful!',

        );

      },
    );
    
  }
}