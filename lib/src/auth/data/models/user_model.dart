import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.profilePic,
  });

  const UserModel.empty()
      : this(
          id: '',
          email: '',
          fullName: '',
        );

  UserModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          email: map['email'] as String,
          fullName: map['fullName'] as String,
          profilePic: map['profilePic'] as String?,
        );

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? profilePic,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'profilePic': profilePic,
    };
  }
}
