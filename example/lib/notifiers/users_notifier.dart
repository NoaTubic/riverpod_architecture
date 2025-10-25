import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/paginated_notifier.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';
import 'package:example/data/user_repository.dart';
import 'package:example/models/user.dart';

/// Notifier for paginated user list - demonstrates PaginatedNotifier usage
class UsersNotifier extends AutoDisposePaginatedNotifier<User, void> {
  late final UserRepository _repository;

  @override
  ({PaginatedState<User> initialState, bool useGlobalFailure})
      prepareForBuild() {
    _repository = UserRepository();
    // Automatically load first page on initialization
    getInitialList();
    return (
      initialState: const PaginatedState.loading(),
      useGlobalFailure: true,
    );
  }

  @override
  Future<Either<Failure, PaginatedList<User>>> getListOrFailure(
    int page, [
    void parameter,
  ]) {
    return _repository.getUsers(page: page);
  }
}

/// Provider for the users notifier
final usersNotifierProvider =
    NotifierProvider.autoDispose<UsersNotifier, PaginatedState<User>>(
  UsersNotifier.new,
);
