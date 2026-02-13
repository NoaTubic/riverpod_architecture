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

/// Family variant - In Riverpod 3.0, family notifiers accept an argument via constructor.
abstract class FamilySimpleNotifier<T, Arg> extends Notifier<T>
    with SimpleNotifierMixin {
  FamilySimpleNotifier(this.arg);

  final Arg arg;

  T prepareForBuild(Arg arg);

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  T build() {
    initWithRef(ref);
    return prepareForBuild(arg);
  }
}

/// AutoDisposeFamily variant - In Riverpod 3.0, family notifiers accept an argument via constructor.
abstract class AutoDisposeFamilySimpleNotifier<T, Arg> extends Notifier<T>
    with SimpleNotifierMixin {
  AutoDisposeFamilySimpleNotifier(this.arg);

  final Arg arg;

  T prepareForBuild(Arg arg);

  /// do not override in child classes, use prepareForBuild instead
  @nonVirtual
  @override
  T build() {
    initWithRef(ref);
    return prepareForBuild(arg);
  }
}
