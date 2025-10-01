import 'package:equatable/equatable.dart';

/// User entity representing a user in the domain layer
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, name, email, avatar, createdAt, updatedAt];

  /// Creates a copy of this user with the given fields replaced with new values
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

