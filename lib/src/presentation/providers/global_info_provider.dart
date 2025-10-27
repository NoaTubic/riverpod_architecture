import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';

///[globalInfoProvider] can be used to show any info updating [BaseStateNotifier] state.
///
///The entire app is wrapped in [BaseWidget] which listens to this provider and GlobalInfo can be shown above entire
///app by simply calling setGlobalInfo() inside execute > onDataReceived()
final globalInfoProvider =
    NotifierProvider<GlobalInfoNotifier, GlobalInfo?>(GlobalInfoNotifier.new);

class GlobalInfoNotifier extends Notifier<GlobalInfo?> {
  @override
  GlobalInfo? build() => null;

  void set(GlobalInfo? globalInfo) {
    state = globalInfo?.copyWith(uniqueKey: UniqueKey());
  }
}
