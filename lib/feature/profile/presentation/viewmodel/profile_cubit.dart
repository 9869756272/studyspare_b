import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/feature/profile/domain/usecase/delete_user_usecase.dart';
import 'package:studyspare_b/feature/profile/domain/usecase/get_user_profile_usecase.dart';
import 'package:studyspare_b/feature/profile/domain/usecase/update_user_profile_usecase.dart';
import 'package:studyspare_b/feature/profile/presentation/viewmodel/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUsecase _getUserProfileUsecase;
  final UpdateUserProfileUsecase _updateUserProfileUsecase;
  final DeleteUserUsecase _deleteUserUsecase;
  final AuthProvider _authProvider;

  ProfileCubit({
    required GetUserProfileUsecase getUserProfileUsecase,
    required UpdateUserProfileUsecase updateUserProfileUsecase,
    required DeleteUserUsecase deleteUserUsecase,
    required AuthProvider authProvider,
  }) : _getUserProfileUsecase = getUserProfileUsecase,
       _updateUserProfileUsecase = updateUserProfileUsecase,
       _deleteUserUsecase = deleteUserUsecase,
       _authProvider = authProvider,
       super(ProfileState.initial(authProvider.currentUser));

  void loadUserProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getUserProfileUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) {
        // Update the global auth provider as well
        if (_authProvider.currentToken != null) {
          _authProvider.login(_authProvider.currentToken!, user);
        }
        emit(state.copyWith(status: ProfileStatus.success, user: user));
      },
    );
  }

  void updateProfile({required String name, String? password}) async {
    emit(state.copyWith(status: ProfileStatus.updating));
    final result = await _updateUserProfileUsecase(
      UpdateUserParams(name: name, password: password),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedUser) {
        // Also update the global auth provider
        if (_authProvider.currentToken != null) {
          _authProvider.login(_authProvider.currentToken!, updatedUser);
        }
        emit(
          state.copyWith(
            status: ProfileStatus.updateSuccess,
            user: updatedUser,
          ),
        );
      },
    );
  }

  void deleteAccountWithPassword(String password) async {
    emit(state.copyWith(status: ProfileStatus.deleting));
    final result = await _deleteUserUsecase(
      DeleteUserParams(password: password),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Logout user globally which clears shared preferences
        _authProvider.logout();
        emit(state.copyWith(status: ProfileStatus.deleteSuccess, user: null));
      },
    );
  }

  //use updateProfile method to change password
  Future<void> updatePassword(String password, String confirmPassword) async {
    if (password != confirmPassword) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Passwords do not match',
        ),
      );
      return;
    } else if (password.isEmpty || confirmPassword.isEmpty) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Password cannot be empty',
        ),
      );
      return;
    }
    updateProfile(name: state.user?.name ?? '', password: password);
  }
}
