import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/paginated_notifier.dart';
import 'package:riverpod_architecture/src/presentation/mixins/paginated_notifier_mixin.dart';
import 'package:riverpod_architecture/src/presentation/mixins/paginated_stream_notifier_mixin.dart';
import 'package:riverpod_architecture/src/presentation/mixins/simple_notifier_mixin.dart';

abstract class PaginatedNotifier<Entity, Param>
    extends Notifier<PaginatedState<Entity>>
    with
        SimpleNotifierMixin,
        PaginatedStreamNotifierMixin<Entity, Param>,
        PaginatedNotifierMixin<Entity, Param> {
  ({PaginatedState<Entity> initialState, bool useGlobalFailure})
      prepareForBuild();

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  PaginatedState<Entity> build() {
    initWithRefAndGetOrUpdateState(
      ref,
      ({newState}) {
        if (newState != null) state = newState;
        return state;
      },
    );
    final data = prepareForBuild();
    setUserGlobalFailure(data.useGlobalFailure);
    return data.initialState;
  }
}

/// AutoDispose variant - In Riverpod 3.0, all notifiers extend Notifier.
/// Auto-dispose behavior is controlled by the provider type.
abstract class AutoDisposePaginatedNotifier<Entity, Param>
    extends Notifier<PaginatedState<Entity>>
    with
        SimpleNotifierMixin,
        PaginatedStreamNotifierMixin<Entity, Param>,
        PaginatedNotifierMixin<Entity, Param> {
  ({PaginatedState<Entity> initialState, bool useGlobalFailure})
      prepareForBuild();

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  PaginatedState<Entity> build() {
    initWithRefAndGetOrUpdateState(
      ref,
      ({newState}) {
        if (newState != null) state = newState;
        return state;
      },
    );
    final data = prepareForBuild();
    setUserGlobalFailure(data.useGlobalFailure);
    return data.initialState;
  }
}

/// Family variant - In Riverpod 3.0, all notifiers extend Notifier.
abstract class FamilyPaginatedNotifier<Entity, Param, Arg>
    extends Notifier<PaginatedState<Entity>>
    with
        SimpleNotifierMixin,
        PaginatedStreamNotifierMixin<Entity, Param>,
        PaginatedNotifierMixin<Entity, Param> {
  ({PaginatedState<Entity> initialState, bool useGlobalFailure})
      prepareForBuild(Arg arg);

  @nonVirtual
  @override
  PaginatedState<Entity> build() {
    initWithRefAndGetOrUpdateState(
      ref,
      ({newState}) {
        if (newState != null) state = newState;
        return state;
      },
    );
    throw UnimplementedError(
      'FamilyPaginatedNotifier requires special provider setup. '
      'Use NotifierProvider.family() and pass arg to prepareForBuild().',
    );
  }
}

/// AutoDisposeFamily variant - In Riverpod 3.0, all notifiers extend Notifier.
abstract class AutoDisposeFamilyPaginatedNotifier<Entity, Param, Arg>
    extends Notifier<PaginatedState<Entity>>
    with
        SimpleNotifierMixin,
        PaginatedStreamNotifierMixin<Entity, Param>,
        PaginatedNotifierMixin<Entity, Param> {
  ({PaginatedState<Entity> initialState, bool useGlobalFailure})
      prepareForBuild(Arg arg);

  @nonVirtual
  @override
  PaginatedState<Entity> build() {
    initWithRefAndGetOrUpdateState(
      ref,
      ({newState}) {
        if (newState != null) state = newState;
        return state;
      },
    );
    throw UnimplementedError(
      'AutoDisposeFamilyPaginatedNotifier requires special provider setup. '
      'Use NotifierProvider.family() and pass arg to prepareForBuild().',
    );
  }
}
