import 'package:flutter_test/flutter_test.dart';
import 'package:zentriq/data/models/user_model.dart';
import 'package:zentriq/domain/entities/user.dart';

void main() {
  group('UserModel', () {
    const testUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      avatar: 'https://example.com/avatar.jpg',
      createdAt: null,
      updatedAt: null,
    );

    test('should create UserModel from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'avatar': 'https://example.com/avatar.jpg',
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-02T00:00:00.000Z',
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.id, '1');
      expect(userModel.name, 'John Doe');
      expect(userModel.email, 'john@example.com');
      expect(userModel.avatar, 'https://example.com/avatar.jpg');
      expect(userModel.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(userModel.updatedAt, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });

    test('should create UserModel from JSON with null dates', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'avatar': null,
        'created_at': null,
        'updated_at': null,
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.id, '1');
      expect(userModel.name, 'John Doe');
      expect(userModel.email, 'john@example.com');
      expect(userModel.avatar, null);
      expect(userModel.createdAt, null);
      expect(userModel.updatedAt, null);
    });

    test('should convert UserModel to JSON', () {
      // Arrange
      final userModel = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );

      // Act
      final json = userModel.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['avatar'], 'https://example.com/avatar.jpg');
      expect(json['created_at'], '2023-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-02T00:00:00.000Z');
    });

    test('should create UserModel from User entity', () {
      // Act
      final userModel = UserModel.fromEntity(testUser);

      // Assert
      expect(userModel.id, testUser.id);
      expect(userModel.name, testUser.name);
      expect(userModel.email, testUser.email);
      expect(userModel.avatar, testUser.avatar);
      expect(userModel.createdAt, testUser.createdAt);
      expect(userModel.updatedAt, testUser.updatedAt);
    });

    test('should handle null avatar in toJson', () {
      // Arrange
      final userModel = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: null,
        createdAt: null,
        updatedAt: null,
      );

      // Act
      final json = userModel.toJson();

      // Assert
      expect(json['avatar'], null);
      expect(json['created_at'], null);
      expect(json['updated_at'], null);
    });
  });
}
