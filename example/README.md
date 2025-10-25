# Riverpod Architecture Example

This example project demonstrates how to use the `riverpod_architecture` package to build Flutter applications with clean architecture patterns and Riverpod 3.0 state management.

## What's Included

This example app showcases two main features:

### 1. BaseNotifier Example (User Detail Screen)
Demonstrates fetching a single user with complete state management:
- **States**: Initial, Loading, Error, and Data states
- **Error Handling**: Functional error handling with `Either<Failure, T>`
- **Global Loading**: Shows how to use global loading indicators
- **Refresh**: Demonstrates state refresh functionality
- **Try it**: Enter user ID `999` to see error handling in action!

**Key files:**
- [lib/notifiers/user_detail_notifier.dart](lib/notifiers/user_detail_notifier.dart) - BaseNotifier implementation
- [lib/screens/user_detail_screen.dart](lib/screens/user_detail_screen.dart) - UI with pattern matching

### 2. PaginatedNotifier Example (Users List Screen)
Demonstrates paginated data with infinite scroll:
- **States**: Loading, LoadingMore, Loaded, and Error states
- **Pagination**: Automatic first page load and manual load more
- **Error Resilience**: Errors preserve already-loaded data
- **Last Page Detection**: Knows when all data is loaded
- **Refresh**: Pull to refresh functionality

**Key files:**
- [lib/notifiers/users_notifier.dart](lib/notifiers/users_notifier.dart) - PaginatedNotifier implementation
- [lib/screens/users_list_screen.dart](lib/screens/users_list_screen.dart) - Paginated list UI

## Project Structure

```
example/
├── lib/
│   ├── main.dart                          # App entry point with BaseWidget
│   ├── models/
│   │   └── user.dart                      # User domain model
│   ├── data/
│   │   └── user_repository.dart           # Mock repository with Either
│   ├── notifiers/
│   │   ├── user_detail_notifier.dart      # BaseNotifier example
│   │   └── users_notifier.dart            # PaginatedNotifier example
│   └── screens/
│       ├── home_screen.dart               # Home navigation screen
│       ├── user_detail_screen.dart        # BaseNotifier UI
│       └── users_list_screen.dart         # PaginatedNotifier UI
└── pubspec.yaml
```

## Key Concepts Demonstrated

### 1. BaseNotifier Pattern
```dart
class UserDetailNotifier extends AutoDisposeBaseNotifier<User> {
  late final UserRepository _repository;

  @override
  void prepareForBuild() {
    _repository = UserRepository();
  }

  Future<void> fetchUser(int userId) async {
    await execute(_repository.getUser(userId));
  }
}
```

### 2. PaginatedNotifier Pattern
```dart
class UsersNotifier extends AutoDisposePaginatedNotifier<User, void> {
  late final UserRepository _repository;

  @override
  ({PaginatedState<User> initialState, bool useGlobalFailure})
      prepareForBuild() {
    _repository = UserRepository();
    getInitialList(); // Auto-load first page
    return (
      initialState: const PaginatedState.loading(),
      useGlobalFailure: true,
    );
  }

  @override
  Future<Either<Failure, PaginatedList<User>>> getListOrFailure(
    int page,
    [void parameter]
  ) {
    return _repository.getUsers(page: page);
  }
}
```

### 3. Either Error Handling
```dart
EitherFailureOr<User> getUser(int id) async {
  try {
    // ... fetch user
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
```

### 4. Pattern Matching States
```dart
return switch (state) {
  BaseInitial() => InitialWidget(),
  BaseLoading() => LoadingWidget(),
  BaseError(:final failure) => ErrorWidget(failure),
  BaseData(:final data) => DataWidget(data),
};
```

### 5. Global Providers (BaseWidget)
```dart
BaseWidget(
  loadingIndicator: const CircularProgressIndicator(),
  onGlobalFailure: (failure) {
    // Show snackbar with error
  },
  onGlobalInfo: (info) {
    // Show snackbar with info
  },
  child: MaterialApp(...),
)
```

## Running the Example

1. **Navigate to the example directory:**
   ```bash
   cd example
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Features to Try

### BaseNotifier Example
1. Enter different user IDs (1-100) to fetch users
2. Enter `999` to trigger an error
3. Use the refresh button to reload data
4. Observe loading states during fetch

### PaginatedNotifier Example
1. Scroll through the automatically loaded first page
2. Tap "Load More" to fetch additional pages
3. Use the refresh button to reload from scratch
4. Scroll to page 10 to see "last page" detection
5. Try loading page 5 to see error handling with partial data

## Mock Data

The example uses a `UserRepository` with mock data:
- **Users**: Generated from IDs 1-200 (20 per page, 10 pages total)
- **Avatars**: Uses [pravatar.cc](https://pravatar.cc) for placeholder images
- **Delays**: Simulated network delays (800ms - 1s)
- **Errors**: ID `999` triggers an error, page 5 triggers pagination error

## Learning Resources

- **Package Documentation**: See [CLAUDE.md](../CLAUDE.md) in the root directory
- **Riverpod 3.0 Docs**: [riverpod.dev](https://riverpod.dev)
- **Either Pattern**: Uses [either_dart](https://pub.dev/packages/either_dart)

## Package Features Used

- ✅ `AutoDisposeBaseNotifier` - Auto-disposing single-value state
- ✅ `AutoDisposePaginatedNotifier` - Auto-disposing paginated state
- ✅ `BaseState<T>` - Sealed class with initial/loading/error/data
- ✅ `PaginatedState<T>` - Sealed class for pagination states
- ✅ `BaseWidget` - Global loading/failure/info handling
- ✅ `Either<Failure, T>` - Functional error handling
- ✅ `PaginatedList<T>` - Pagination metadata wrapper

## Next Steps

To use this package in your own project:

1. Add the dependency to your `pubspec.yaml`
2. Wrap your app with `BaseWidget` for global providers
3. Create notifiers extending `BaseNotifier` or `PaginatedNotifier`
4. Implement repositories returning `EitherFailureOr<T>`
5. Use pattern matching to handle different states in your UI

## Notes

- This example uses **Riverpod 3.0** syntax (not legacy StateNotifier)
- The package requires `flutter_riverpod: ^3.0.3`
- All notifiers use the `prepareForBuild()` pattern (don't override `build()`)
- States are sealed classes - use pattern matching instead of `.when()` methods
