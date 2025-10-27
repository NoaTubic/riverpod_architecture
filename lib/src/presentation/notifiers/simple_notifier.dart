import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/src/presentation/mixins/simple_notifier_mixin.dart';

abstract class SimpleNotifier<T> extends Notifier<T> with SimpleNotifierMixin {
  T prepareForBuild();

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  T build() {
    initWithRef(ref);
    return prepareForBuild();
  }
}

/// AutoDispose variant - In Riverpod 3.0, all notifiers extend Notifier.
/// Auto-dispose behavior is controlled by the provider type.
abstract class AutoDisposeSimpleNotifier<T> extends Notifier<T>
    with SimpleNotifierMixin {
  T prepareForBuild();

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  T build() {
    initWithRef(ref);
    return prepareForBuild();
  }
}

/// Family variant - In Riverpod 3.0, family parameters are passed via build().
abstract class FamilySimpleNotifier<T, Arg> extends Notifier<T>
    with SimpleNotifierMixin {
  T prepareForBuild(Arg arg);

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  T build() {
    // Note: In Riverpod 3.0, family args come from the provider, not build()
    // This will be handled by the provider setup
    throw UnimplementedError(
      'FamilySimpleNotifier requires special provider setup. '
      'Use NotifierProvider.family() and override build() in implementation.',
    );
  }
}

/// AutoDisposeFamily variant - In Riverpod 3.0, all notifiers extend Notifier.
abstract class AutoDisposeFamilySimpleNotifier<T, Arg> extends Notifier<T>
    with SimpleNotifierMixin {
  T prepareForBuild(Arg arg);

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  T build() {
    // Note: In Riverpod 3.0, family args come from the provider, not build()
    throw UnimplementedError(
      'AutoDisposeFamilySimpleNotifier requires special provider setup. '
      'Use NotifierProvider.family() and override build() in implementation.',
    );
  }
}
