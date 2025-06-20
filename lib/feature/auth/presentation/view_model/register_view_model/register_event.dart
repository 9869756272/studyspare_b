import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}


class RegisterUserEvent extends RegisterEvent{
  final BuildContext context;
  final String username;
  final String email;
  final String password;


  RegisterUserEvent({
    required this.context,
    required this.username,
    required this.email,
    required this.password,
    
  });

}




