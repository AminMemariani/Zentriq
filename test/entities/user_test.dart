import 'package:flutter_test/flutter_test.dart';
import 'package:zentriq/domain/entities/user.dart';

void main() {
  group('User', () {
    const testUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      avatar: 'https://example.com/avatar.jpg',
      createdAt: null,
      updatedAt: null,
    );

    test('should create User with all properties', () {
      // Arrange & Act
      const user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: null,
        updatedAt: null,
      );

      // Assert
      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.avatar, 'https://example.com/avatar.jpg');
      expect(user.createdAt, null);
      expect(user.updatedAt, null);
    });

    test('should create User with minimal properties', () {
      // Arrange & Act
      const user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
      );

      // Assert
      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.avatar, null);
      expect(user.createdAt, null);
      expect(user.updatedAt, null);
    });

    test('should return correct props for equality', () {
      // Arrange
      const user1 = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: null,
        updatedAt: null,
      );

      const user2 = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: null,
        updatedAt: null,
      );

      // Act & Assert
      expect(user1.props, user2.props);
      expect(user1, equals(user2));
    });

    test('should create copy with updated fields', () {
      // Arrange
      const originalUser = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: null,
        updatedAt: null,
      );

      // Act
      final updatedUser = originalUser.copyWith(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      // Assert
      expect(updatedUser.id, '1'); // unchanged
      expect(updatedUser.name, 'Jane Doe'); // changed
      expect(updatedUser.email, 'jane@example.com'); // changed
      expect(updatedUser.avatar, 'https://example.com/avatar.jpg'); // unchanged
      expect(updatedUser.createdAt, null); // unchanged
      expect(updatedUser.updatedAt, null); // unchanged
    });

    test('should create copy with all fields updated', () {
      // Arrange
      const originalUser = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: null,
        updatedAt: null,
      );

      final newCreatedAt = DateTime.now();
      final newUpdatedAt = DateTime.now();

      // Act
      final updatedUser = originalUser.copyWith(
        id: '2',
        name: 'Jane Doe',
        email: 'jane@example.com',
        avatar: 'https://example.com/new-avatar.jpg',
        createdAt: newCreatedAt,
        updatedAt: newUpdatedAt,
      );

      // Assert
      expect(updatedUser.id, '2');
      expect(updatedUser.name, 'Jane Doe');
      expect(updatedUser.email, 'jane@example.com');
      expect(updatedUser.avatar, 'https://example.com/new-avatar.jpg');
      expect(updatedUser.createdAt, newCreatedAt);
      expect(updatedUser.updatedAt, newUpdatedAt);
    });

    test(
        'should create copy with null fields (copyWith preserves original values)',
        () {
      // Arrange
      const originalUser = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: null,
        updatedAt: null,
      );

      // Act
      final updatedUser = originalUser.copyWith(
        avatar: null, // This won't change the avatar because copyWith uses ??
      );

      // Assert
      expect(updatedUser.id, '1');
      expect(updatedUser.name, 'John Doe');
      expect(updatedUser.email, 'john@example.com');
      expect(updatedUser.avatar,
          'https://example.com/avatar.jpg'); // Preserved original value
      expect(updatedUser.createdAt, null);
      expect(updatedUser.updatedAt, null);
    });
  });
}
