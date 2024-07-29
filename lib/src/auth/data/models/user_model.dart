// lib/features/auth/data/models/user_model.dart
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.profilePic,
  });

  const UserModel.empty()
      : this(
          id: '',
          email: '',
          firstName: '',
          lastName: '',
        );

  factory UserModel.fromMap(DataMap map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      profilePic: map['profile_pic'] as String?,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profilePic,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile_pic': profilePic,
    };
  }
}
