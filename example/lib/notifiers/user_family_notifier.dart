import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/base_notifier.dart';
import 'package:example/data/user_repository.dart';
import 'package:example/models/user.dart';

/// Example of FamilyBaseNotifier - accepts userId as argument
/// This is useful when you need different instances for different parameters
class UserFamilyNotifier extends AutoDisposeFamilyBaseNotifier<User, int> {
  UserFamilyNotifier(super.userId);

  late final UserRepository _repository;

  @override
  void prepareForBuild(int userId) {
    _repository = UserRepository();
    // Automatically fetch user on build with the provided userId
    fetchUser();
  }

  /// Fetch user using the userId passed via constructor
  Future<void> fetchUser() async {
    await execute(_repository.getUser(arg));
  }

  /// Refresh the current user
  Future<void> refresh() async {
    await execute(_repository.getUser(arg));
  }
}

/// Provider for the user family notifier
/// Usage: ref.watch(userFamilyNotifierProvider(userId))
final userFamilyNotifierProvider = NotifierProvider.autoDispose
    .family<UserFamilyNotifier, BaseState<User>, int>(
  UserFamilyNotifier.new,
);
