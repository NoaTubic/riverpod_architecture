# Riverpod Architecture

[![Pub Version](https://img.shields.io/pub/v/riverpod_architecture)](https://pub.dev/packages/riverpod_architecture)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Flutter state management architecture built on **Riverpod 3.0**, providing reusable notifier classes and utilities for clean, scalable applications. This package reduces boilerplate by providing standardized patterns for handling state, errors, pagination, and data mapping.

## Features

✅ **Modern Riverpod 3.0** - Fully migrated to latest Riverpod with `Notifier` base classes
✅ **State Management** - `BaseNotifier` for handling initial/loading/error/data states
✅ **Pagination** - Built-in `PaginatedNotifier` with infinite scroll support
✅ **Error Handling** - Functional error handling with `Either<Failure, T>`
✅ **Global Providers** - App-wide loading, failure, and info notifications
✅ **Data Mapping** - Mappers for API responses, forms, and requests
✅ **Type Safety** - Sealed classes with pattern matching
✅ **Auto Dispose** - Memory-efficient with auto-dispose variants

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  riverpod_architecture: ^2.0.0
  flutter_riverpod: ^3.0.3
  either_dart: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Wrap your app with `BaseWidget`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
      onGlobalFailure: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.title),
            backgroundColor: Colors.red,
          ),
        );
      },
      onGlobalInfo: (info) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(info.message)),
        );
      },
      child: MaterialApp(
        title: 'My App',
        home: const HomeScreen(),
      ),
    );
  }
}
```

### 2. Create a Repository with `Either` error handling

```dart
import 'package:either_dart/either.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';

class UserRepository {
  EitherFailureOr<User> getUser(int id) async {
    try {
      // Your API call here
      final response = await api.getUser(id);
      return Right(User.fromJson(response));
    } catch (error, stackTrace) {
      return Left(
        Failure(
          title: 'Failed to fetch user',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
```

### 3. Create a Notifier

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/base_notifier.dart';

class UserNotifier extends AutoDisposeBaseNotifier<User> {
  late final UserRepository _repository;

  @override
  void prepareForBuild() {
    _repository = UserRepository();
  }

  Future<void> fetchUser(int userId) async {
    await execute(_repository.getUser(userId));
  }

  Future<void> refresh() async {
    await execute(_repository.getUser(_currentUserId));
  }
}

final userNotifierProvider =
    NotifierProvider.autoDispose<UserNotifier, BaseState<User>>(
  UserNotifier.new,
);
```

### 4. Use in UI with Pattern Matching

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/base_notifier.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: switch (userState) {
        BaseInitial() => const Center(
            child: Text('Press button to load user'),
          ),
        BaseLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        BaseError(:final failure) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${failure.title}'),
                ElevatedButton(
                  onPressed: () => ref.read(userNotifierProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        BaseData(:final data) => UserDetailsWidget(user: data),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(userNotifierProvider.notifier).fetchUser(1),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

## Core Concepts

### State Types

#### BaseState `<T>`

For single-value state management:

- `BaseInitial` - Initial empty state
- `BaseLoading` - Loading state
- `BaseError(Failure)` - Error with failure details
- `BaseData(T)` - Success with data

#### PaginatedState `<T>`

For paginated data:

- `PaginatedLoading` - Loading first page
- `PaginatedLoadingMore(List<T>)` - Loading more items
- `PaginatedLoaded(List<T>, isLastPage)` - Successfully loaded
- `PaginatedError(List<T>, Failure)` - Error preserving already-loaded data

### Notifier Types

Each notifier type has **4 variants**:

| Base Class                            | Auto Dispose                               | Family                                     | Auto Dispose + Family                                 |
| ------------------------------------- | ------------------------------------------ | ------------------------------------------ | ----------------------------------------------------- |
| `BaseNotifier<T>`                   | `AutoDisposeBaseNotifier<T>`             | `FamilyBaseNotifier<T, Arg>`             | `AutoDisposeFamilyBaseNotifier<T, Arg>`             |
| `PaginatedNotifier<T, Param>`       | `AutoDisposePaginatedNotifier<T, Param>` | `FamilyPaginatedNotifier<T, Param, Arg>` | `AutoDisposeFamilyPaginatedNotifier<T, Param, Arg>` |
| `PaginatedStreamNotifier<T, Param>` | (same variants)                            | (same variants)                            | (same variants)                                       |

**Recommended:** Use `AutoDispose` variants by default for memory efficiency.

### Pagination Example

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/paginated_notifier.dart';
import 'package:either_dart/either.dart';

class UsersNotifier extends AutoDisposePaginatedNotifier<User, void> {
  late final UserRepository _repository;

  @override
  ({PaginatedState<User> initialState, bool useGlobalFailure})
      prepareForBuild() {
    _repository = UserRepository();
    // Automatically load first page
    getInitialList();
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

final usersNotifierProvider =
    NotifierProvider.autoDispose<UsersNotifier, PaginatedState<User>>(
  UsersNotifier.new,
);
```

#### Using in UI

```dart
class UsersListScreen extends ConsumerWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(usersNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: switch (usersState) {
        PaginatedLoading() => const Center(child: CircularProgressIndicator()),
        PaginatedLoadingMore(:final list) => _buildList(context, ref, list, isLoadingMore: true),
        PaginatedLoaded(:final list, :final isLastPage) => _buildList(context, ref, list, isLastPage: isLastPage),
        PaginatedError(:final list, :final failure) => list.isEmpty
            ? ErrorWidget(failure)
            : _buildList(context, ref, list, error: failure.title),
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<User> users, {
    bool isLoadingMore = false,
    bool isLastPage = false,
    String? error,
  }) {
    return ListView.builder(
      itemCount: users.length + (isLoadingMore || !isLastPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == users.length) {
          if (isLoadingMore) {
            return const Center(child: CircularProgressIndicator());
          }
          return ElevatedButton(
            onPressed: () => ref.read(usersNotifierProvider.notifier).getNextPage(),
            child: const Text('Load More'),
          );
        }
        return UserTile(user: users[index]);
      },
    );
  }
}
```

## Advanced Features

### Global Providers

The package provides three global providers for app-wide notifications:

```dart
// Show global loading overlay
ref.read(globalLoadingProvider.notifier).show();
ref.read(globalLoadingProvider.notifier).clear();

// Show global failure notification
ref.read(globalFailureProvider.notifier).set(
  Failure(title: 'Something went wrong'),
);

// Show global info notification
ref.read(globalInfoProvider.notifier).set(
  GlobalInfo(
    globalInfoStatus: GlobalInfoStatus.success,
    message: 'Operation completed successfully',
  ),
);
```

### Data Mappers

The package includes mapper interfaces for clean data layer patterns:

#### EntityMapper

```dart
class UserMapper extends EntityMapper<User, UserResponse> {
  @override
  User mapToEntity(UserResponse response) {
    return User(
      id: response.id,
      name: response.fullName,
      email: response.emailAddress,
    );
  }
}
```

#### FormMapper

```dart
class LoginFormMapper extends FormMapper<LoginRequest, LoginForm> {
  @override
  LoginRequest mapToRequest(LoginForm form) {
    return LoginRequest(
      email: form.email.trim(),
      password: form.password,
    );
  }
}
```

### Custom State Handling

Override behavior with callbacks:

```dart
Future<void> fetchUser(int userId) async {
  await execute(
    _repository.getUser(userId),
    withLoadingState: true,
    globalLoading: false,
    globalFailure: true,
    onDataReceived: (user) {
      // Custom data handling
      print('User loaded: ${user.name}');
      return true; // true to update state, false to handle manually
    },
    onFailureOccurred: (failure) {
      // Custom error handling
      print('Error: ${failure.title}');
      return true; // true to show globally, false to handle manually
    },
  );
}
```

## Important Rules

### DO NOT Override `build()` Method

The `build()` method is marked `@nonVirtual`. Instead, override `prepareForBuild()`:

```dart
// ❌ DON'T DO THIS
@override
BaseState<User> build() {
  // This will cause errors!
}

// ✅ DO THIS
@override
void prepareForBuild() {
  _repository = ref.read(userRepositoryProvider);
}
```

### Use Pattern Matching, Not `.when()`

States are sealed classes without `.when()` methods. Use Dart 3 pattern matching:

```dart
// ❌ DON'T DO THIS
state.when(
  loading: () => LoadingWidget(),
  data: (data) => DataWidget(data),
  // ...
);

// ✅ DO THIS
switch (state) {
  case BaseLoading():
    return LoadingWidget();
  case BaseData(:final data):
    return DataWidget(data);
  // ...
}
```

## Example Project

A complete example app demonstrating all features is available in the [`example/`](example/) directory. It includes:

- **BaseNotifier Example** - Single user fetch with error handling
- **PaginatedNotifier Example** - User list with infinite scroll
- **Mock Repository** - Clean repository pattern with `Either`
- **Pattern Matching** - Modern Dart 3 state handling

Run the example:

```bash
cd example
flutter pub get
flutter run
```

## Migration from Riverpod 2.x

If you're migrating from an older version using `StateNotifier`:

1. Replace `StateNotifier` with `Notifier`
2. Replace `AutoDisposeNotifier` → `Notifier` (use provider type for auto-dispose)
3. Use `NotifierProvider.autoDispose()` instead of `AutoDisposeNotifierProvider`
4. Update family syntax to `NotifierProvider.family()`
5. Override `prepareForBuild()` instead of constructor initialization

## Package Structure

```
lib/
├── riverpod_architecture.dart          # Main export
├── base_notifier.dart                  # BaseNotifier exports
├── paginated_notifier.dart             # Pagination exports
└── src/
  ├── data/
  │   ├── mappers/                    # Mapper interfaces
  │   │   ├── entity_mapper.dart
  │   │   ├── form_mapper.dart
  │   │   ├── form_with_option_mapper.dart
  │   │   ├── mappers.dart
  │   │   └── request_mapper.dart
  │   └── mixins/
  │       └── error_to_failure_mixin.dart
  ├── domain/
  │   ├── either.dart                 # Either/Failure helpers
  │   └── entities/
  │       ├── failure.dart
  │       ├── global_info.dart
  │       ├── paginated_list.dart
  │       └── enums/
  │           └── global_info_status.dart
  ├── extensions/
  │   ├── int_extension.dart
  │   └── iterable_extensions.dart
  └── presentation/
    ├── mixins/                     # Notifier mixins
    │   ├── base_notifier_mixin.dart
    │   ├── paginated_notifier_mixin.dart
    │   ├── paginated_stream_notifier_mixin.dart
    │   └── simple_notifier_mixin.dart
    ├── notifiers/                  # Sealed states and notifiers
    │   ├── base_notifier.dart
    │   ├── base_state.dart
    │   ├── paginated_notifier.dart
    │   ├── paginated_state.dart
    │   ├── paginated_stream_notifier.dart
    │   └── simple_notifier.dart
    ├── providers/                  # Global providers
    │   ├── global_failure_provider.dart
    │   ├── global_info_provider.dart
    │   └── global_loading_provider.dart
    └── widgets/                    # BaseWidget, PaginatedListView
      ├── base_loading_indicator.dart
      ├── base_widget.dart
      └── paginated_list_view.dart
```

## Requirements

- **Dart SDK**: `>=3.0.0 <4.0.0`
- **Flutter**: Latest stable
- **Riverpod**: `^3.0.3`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

Based on [Q-Architecture](https://github.com/Q-Agency/Q-Architecture), fully migrated to Riverpod 3.0 with modern patterns.

## Links

- **Repository**: [github.com/NoaTubic/riverpod_architecture](https://github.com/NoaTubic/riverpod_architecture)
- **Pub.dev**: [pub.dev/packages/riverpod_architecture](https://pub.dev/packages/riverpod_architecture)
- **Issues**: [github.com/NoaTubic/riverpod_architecture/issues](https://github.com/NoaTubic/riverpod_architecture/issues)
- **Riverpod Docs**: [riverpod.dev](https://riverpod.dev)
