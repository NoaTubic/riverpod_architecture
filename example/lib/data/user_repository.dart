import 'package:either_dart/either.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';
import 'package:example/models/user.dart';

/// Mock repository demonstrating error handling with Either
class UserRepository {
  /// Simulates fetching a single user
  EitherFailureOr<User> getUser(int id) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate error for specific IDs
      if (id == 999) {
        throw Exception('User not found');
      }

      return Right(
        User(
          id: id,
          name: 'User $id',
          email: 'user$id@example.com',
          avatarUrl: 'https://i.pravatar.cc/150?img=$id',
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        Failure(
          title: error.toString(),
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Simulates fetching paginated users
  EitherFailureOr<PaginatedList<User>> getUsers({
    required int page,
    int pageSize = 20,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate error for specific pages
      if (page == 5) {
        throw Exception('Failed to load page $page');
      }

      // Generate mock users
      final startId = (page - 1) * pageSize;
      final users = List.generate(
        pageSize,
        (index) {
          final id = startId + index + 1;
          return User(
            id: id,
            name: 'User $id',
            email: 'user$id@example.com',
            avatarUrl: 'https://i.pravatar.cc/150?img=${id % 70}',
          );
        },
      );

      // Simulate last page at page 10
      final isLastPage = page >= 10;

      return Right(
        PaginatedList(
          data: users,
          page: page,
          isLast: isLastPage,
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        Failure(
          title: error.toString(),
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Simulates updating a user
  EitherFailureOr<User> updateUser(User user) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(user);
    } catch (error, stackTrace) {
      return Left(
        Failure(
          title: error.toString(),
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Simulates deleting a user
  EitherFailureOr<void> deleteUser(int id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(
        Failure(
          title: error.toString(),
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
