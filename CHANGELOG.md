# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-10-27

### Fixed

- Documentation: Updated package structure in README to accurately reflect the current `lib/` layout.
- Documentation: Clarified package structure in CHANGELOG entry; no runtime code changes.

## [1.0.1] - 2025-10-25

### Fixed

- Fixed pubspec.yaml description length (reduced to meet pub.dev requirements)
- Formatted all Dart files with `dart format`
- Included example project in published package for pub.dev scoring
- Updated .pubignore to properly include example directory

## [1.0.0][1.0.0] - 2025-10-25

### 🎉 Initial Release

First stable release of **riverpod_architecture** - A modern Flutter state management architecture built on Riverpod 3.0.

### ✨ Features

#### State Management

- **BaseNotifier** - Handles single-value state with initial/loading/error/data states
- **PaginatedNotifier** - Built-in pagination with infinite scroll support
- **PaginatedStreamNotifier** - Stream-based pagination for real-time data
- **SimpleNotifier** - Base-level notifier with utility methods

#### Notifier Variants

Each notifier type includes 4 variants:

- Base notifier
- AutoDispose variant (memory-efficient)
- Family variant (parameterized)
- AutoDisposeFamily variant (both features combined)

#### State Types

- **BaseState`<T>`** - Sealed class with `BaseInitial`, `BaseLoading`, `BaseError`, `BaseData`
- **PaginatedState`<T>`** - Sealed class with `PaginatedLoading`, `PaginatedLoadingMore`, `PaginatedLoaded`, `PaginatedError`
- Type-safe pattern matching with Dart 3

#### Error Handling

- Functional error handling with `Either<Failure, T>`
- `EitherFailureOr<T>` type alias for Future-based operations
- `StreamFailureOr<T>` type alias for Stream-based operations
- `Failure` entity with title, error details, and stack traces

#### Global Providers

- **globalLoadingProvider** - App-wide loading indicator
- **globalFailureProvider** - Global error notifications
- **globalInfoProvider** - Global info messages
- All global providers migrated to Riverpod 3.0 NotifierProvider

#### Data Layer Utilities

- **EntityMapper<Entity, Response>** - Map API responses to domain entities
- **FormMapper<Request, Form>** - Map forms to API requests
- **RequestMapper<Request, Param>** - Map parameters to API requests
- **FormWithOptionMapper<Request, Form, Option>** - Form mapping with options
- **ErrorToFailureMixin** - Automatic error to failure conversion

#### UI Components

- **BaseWidget** - Root widget for global providers (loading, failure, info)
- **PaginatedListView** - Ready-to-use widget for paginated lists
- Customizable loading indicators, error handlers, and refresh controls

#### Developer Experience

- Comprehensive documentation and examples
- Type-safe sealed classes with pattern matching
- Auto-disposal for memory efficiency
- Built-in throttling and debouncing
- Custom state handling callbacks

### 📚 Documentation

- Complete README with installation and usage examples
- Full example project demonstrating all features:
  - BaseNotifier example (user detail screen)
  - PaginatedNotifier example (user list with pagination)
  - Mock repository with Either pattern
  - Pattern matching in UI
- Detailed API documentation
- Migration guide from other patterns

### 🛠️ Technical Details

- **Riverpod Version**: 3.0.3
- **Dart SDK**: >=3.0.0 <4.0.0
- **Dependencies**:
  - `flutter_riverpod: ^3.0.3`
  - `either_dart: ^1.0.0`
  - `equatable: ^2.0.7`
  - `meta: ^1.16.0`

### 📦 Package Structure

```
lib/
├── riverpod_architecture.dart          # Main export
├── base_notifier.dart                  # BaseNotifier exports
├── paginated_notifier.dart             # Pagination exports
└── src/
  ├── data/
  │   ├── mappers/
  │   │   ├── entity_mapper.dart
  │   │   ├── form_mapper.dart
  │   │   ├── form_with_option_mapper.dart
  │   │   ├── mappers.dart
  │   │   └── request_mapper.dart
  │   └── mixins/
  │       └── error_to_failure_mixin.dart
  ├── domain/
  │   ├── either.dart
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
    ├── mixins/
    │   ├── base_notifier_mixin.dart
    │   ├── paginated_notifier_mixin.dart
    │   ├── paginated_stream_notifier_mixin.dart
    │   └── simple_notifier_mixin.dart
    ├── notifiers/
    │   ├── base_notifier.dart
    │   ├── base_state.dart
    │   ├── paginated_notifier.dart
    │   ├── paginated_state.dart
    │   ├── paginated_stream_notifier.dart
    │   └── simple_notifier.dart
    ├── providers/
    │   ├── global_failure_provider.dart
    │   ├── global_info_provider.dart
    │   └── global_loading_provider.dart
    └── widgets/
      ├── base_loading_indicator.dart
      ├── base_widget.dart
      └── paginated_list_view.dart
```

### 🎯 Design Principles

- **Modern Riverpod 3.0** - Fully compatible with latest Riverpod
- **Type Safety** - Sealed classes and pattern matching
- **Clean Architecture** - Clear separation of concerns
- **Memory Efficient** - Auto-dispose variants by default
- **Developer Friendly** - Reduced boilerplate, clear patterns
- **Production Ready** - Comprehensive error handling and testing

### 📝 Important Notes

- **Override `prepareForBuild()`** not `build()` - The build method is marked `@nonVirtual`
- **Use pattern matching** - States are sealed classes without `.when()` methods
- **Use auto-dispose** - Recommended for memory efficiency
- **Global providers** - Set up `BaseWidget` at app root for global notifications

### 🙏 Credits

Based on [Q-Architecture](https://github.com/Q-Agency/Q-Architecture), fully migrated to Riverpod 3.0 with modern patterns and best practices.

---

[1.0.0]: https://github.com/NoaTubic/riverpod_architecture/releases/tag/v1.0.0
