import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/src/domain/entities/failure.dart';

///[globalFailureProvider] can be used to show the failure without updating [BaseStateNotifier] state.
///
///The entire app is wrapped in [BaseWidget] which listens to this provider and failure can be shown above entire
///app by simply setting [globalFailure] to true when calling [BaseStateNotifier.execute] method.
final globalFailureProvider =
    NotifierProvider<GlobalFailureNotifier, Failure?>(
  GlobalFailureNotifier.new,
);

class GlobalFailureNotifier extends Notifier<Failure?> {
  @override
  Failure? build() => null;

  void set(Failure? failure) {
    state = failure?.copyWith(uniqueKey: UniqueKey());
  }
}
