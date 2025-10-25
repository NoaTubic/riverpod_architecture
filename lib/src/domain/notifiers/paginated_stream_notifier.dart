import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/paginated_notifier.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';
import 'package:riverpod_architecture/src/domain/mixins/paginated_stream_notifier_mixin.dart';
import 'package:riverpod_architecture/src/domain/mixins/simple_notifier_mixin.dart';

typedef PaginatedStreamFailureOr<Entity>
    = Stream<Either<Failure, PaginatedList<Entity>>>;

abstract class PaginatedStreamNotifier<Entity, Param>
    extends Notifier<PaginatedState<Entity>>
    with SimpleNotifierMixin, PaginatedStreamNotifierMixin<Entity, Param> {
  ({PaginatedState<Entity> initialState, bool useGlobalFailure})
      prepareForBuild();

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  PaginatedState<Entity> build() {
    initWithRefAndGetOrUpdateState(ref, ({newState}) {
      if (newState != null) state = newState;
      return state;
    });
    final data = prepareForBuild();
    setUserGlobalFailure(data.useGlobalFailure);
    return data.initialState;
  }
}

/// AutoDispose variant - In Riverpod 3.0, all notifiers extend Notifier.
/// Auto-dispose behavior is controlled by the provider type.
abstract class AutoDisposePaginatedStreamNotifier<Entity, Param>
    extends Notifier<PaginatedState<Entity>>
    with SimpleNotifierMixin, PaginatedStreamNotifierMixin<Entity, Param> {
  ({PaginatedState<Entity> initialState, bool useGlobalFailure})
      prepareForBuild();

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  PaginatedState<Entity> build() {
    initWithRefAndGetOrUpdateState(ref, ({newState}) {
      if (newState != null) state = newState;
      return state;
    });
    final data = prepareForBuild();
    setUserGlobalFailure(data.useGlobalFailure);
    return data.initialState;
  }
}

/// Family variant - In Riverpod 3.0, all notifiers extend Notifier.
abstract class FamilyPaginatedStreamNotifier<Entity, Param, Arg>
    extends Notifier<PaginatedState<Entity>>
    with SimpleNotifierMixin, PaginatedStreamNotifierMixin<Entity, Param> {
  ({PaginatedState<Entity> initialState, bool useGlobalFailure})
      prepareForBuild(Arg arg);

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  PaginatedState<Entity> build() {
    initWithRefAndGetOrUpdateState(ref, ({newState}) {
      if (newState != null) state = newState;
      return state;
    });
    throw UnimplementedError(
      'FamilyPaginatedStreamNotifier requires special provider setup. '
      'Use NotifierProvider.family() and pass arg to prepareForBuild().',
    );
  }
}

/// AutoDisposeFamily variant - In Riverpod 3.0, all notifiers extend Notifier.
abstract class AutoDisposeFamilyPaginatedStreamNotifier<Entity, Param, Arg>
    extends Notifier<PaginatedState<Entity>>
    with SimpleNotifierMixin, PaginatedStreamNotifierMixin<Entity, Param> {
  ({PaginatedState<Entity> initialState, bool useGlobalFailure})
      prepareForBuild(Arg arg);

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  PaginatedState<Entity> build() {
    initWithRefAndGetOrUpdateState(ref, ({newState}) {
      if (newState != null) state = newState;
      return state;
    });
    throw UnimplementedError(
      'AutoDisposeFamilyPaginatedStreamNotifier requires special provider setup. '
      'Use NotifierProvider.family() and pass arg to prepareForBuild().',
    );
  }
}
