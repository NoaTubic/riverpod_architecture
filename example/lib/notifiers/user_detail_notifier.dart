import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/base_notifier.dart';
import 'package:example/data/user_repository.dart';
import 'package:example/models/user.dart';

/// Notifier for fetching a single user - demonstrates BaseNotifier usage
class UserDetailNotifier extends AutoDisposeBaseNotifier<User> {
  late final UserRepository _repository;
  late final int _userId;

  @override
  void prepareForBuild() {
    _repository = UserRepository();
  }

  /// Fetch user by ID
  Future<void> fetchUser(int userId) async {
    _userId = userId;
    await execute(_repository.getUser(userId));
  }

  /// Refresh the current user
  Future<void> refresh() async {
    await execute(_repository.getUser(_userId));
  }
}

/// Provider for the user detail notifier
final userDetailNotifierProvider =
    NotifierProvider.autoDispose<UserDetailNotifier, BaseState<User>>(
  UserDetailNotifier.new,
);
