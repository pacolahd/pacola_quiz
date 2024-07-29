import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePic,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePic;

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, email, firstName, lastName, profilePic];

  @override
  String toString() {
    return 'User{id: $id, email: $email, firstName: $firstName, lastName: $lastName, profilePic: $profilePic}';
  }
}
