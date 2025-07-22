import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/auth/user_model.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
  updating,
  deleting,
  updateSuccess,
  deleteSuccess,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserModel? user;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  factory ProfileState.initial(UserModel? initialUser) {
    return ProfileState(status: ProfileStatus.initial, user: initialUser);
  }

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
