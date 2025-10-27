import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/base_notifier.dart';
import 'package:riverpod_architecture/src/presentation/mixins/base_notifier_mixin.dart';
import 'package:riverpod_architecture/src/presentation/mixins/simple_notifier_mixin.dart';

abstract class BaseNotifier<T> extends Notifier<BaseState<T>>
    with SimpleNotifierMixin, BaseNotifierMixin<T> {
  void prepareForBuild();

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  BaseState<T> build() {
    initWithRefAndGetOrUpdateState(
      ref,
      ({newState}) {
        if (newState != null) state = newState;
        return state;
      },
    );
    prepareForBuild();
    return const BaseState.initial();
  }
}

/// AutoDispose variant - In Riverpod 3.0, all notifiers extend Notifier.
/// Auto-dispose behavior is controlled by the provider type.
abstract class AutoDisposeBaseNotifier<T> extends Notifier<BaseState<T>>
    with SimpleNotifierMixin, BaseNotifierMixin<T> {
  void prepareForBuild();

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  BaseState<T> build() {
    initWithRefAndGetOrUpdateState(
      ref,
      ({newState}) {
        if (newState != null) state = newState;
        return state;
      },
    );
    prepareForBuild();
    return const BaseState.initial();
  }
}

/// Family variant - In Riverpod 3.0, all notifiers extend Notifier.
abstract class FamilyBaseNotifier<T, Arg> extends Notifier<BaseState<T>>
    with SimpleNotifierMixin, BaseNotifierMixin<T> {
  void prepareForBuild(Arg arg);

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  BaseState<T> build() {
    initWithRefAndGetOrUpdateState(
      ref,
      ({newState}) {
        if (newState != null) state = newState;
        return state;
      },
    );
    // Family args will need to be handled by implementation
    throw UnimplementedError(
      'FamilyBaseNotifier requires special provider setup. '
      'Use NotifierProvider.family() and pass arg to prepareForBuild().',
    );
  }
}

/// AutoDisposeFamily variant - In Riverpod 3.0, all notifiers extend Notifier.
abstract class AutoDisposeFamilyBaseNotifier<T, Arg>
    extends Notifier<BaseState<T>>
    with SimpleNotifierMixin, BaseNotifierMixin<T> {
  void prepareForBuild(Arg arg);

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  BaseState<T> build() {
    initWithRefAndGetOrUpdateState(
      ref,
      ({newState}) {
        if (newState != null) state = newState;
        return state;
      },
    );
    // Family args will need to be handled by implementation
    throw UnimplementedError(
      'AutoDisposeFamilyBaseNotifier requires special provider setup. '
      'Use NotifierProvider.family() and pass arg to prepareForBuild().',
    );
  }
}
