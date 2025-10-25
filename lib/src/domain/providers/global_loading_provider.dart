import 'package:flutter_riverpod/flutter_riverpod.dart';

///[globalLoadingProvider] can be used to show the loading indicator without updating [BaseStateNotifier]
///state. The entire app is wrapped in [BaseWidget] and [BaseLoadingIndicator] can be shown above entire
///app by simply calling [showGlobalLoading]. To hide [BaseLoadingIndicator] simply call [clearGlobalLoading]
final globalLoadingProvider =
    NotifierProvider<GlobalLoadingNotifier, bool>(GlobalLoadingNotifier.new);

class GlobalLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;

  void clear() => state = false;
}
