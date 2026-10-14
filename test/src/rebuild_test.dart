// ignore_for_file: invalid_use_of_protected_member
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_architecture/base_notifier.dart';
import 'package:riverpod_architecture/paginated_notifier.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';

final _dependency = NotifierProvider<_Counter, int>(_Counter.new);

class _Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

class _WatchingNotifier extends BaseNotifier<int> {
  @override
  void prepareForBuild() => ref.watch(_dependency);

  Future<void> load() =>
      execute(Future.value(const Right(1)), globalLoading: true);
}

final _watching = NotifierProvider<_WatchingNotifier, BaseState<int>>(
  _WatchingNotifier.new,
);

class _WatchingPaginated extends PaginatedNotifier<int, void> {
  @override
  ({PaginatedState<int> initialState, bool useGlobalFailure})
  prepareForBuild() {
    ref.watch(_dependency);
    return (
      initialState: const PaginatedState.loading(),
      useGlobalFailure: true,
    );
  }

  @override
  PaginatedEitherFailureOr<int> getListOrFailure(int page, [void parameter]) =>
      Future.value(
        const Right(PaginatedList(data: [1], page: 1, isLast: true)),
      );
}

final _paginated = NotifierProvider<_WatchingPaginated, PaginatedState<int>>(
  _WatchingPaginated.new,
);

void main() {
  group('a notifier whose dependency changes', () {
    test('BaseNotifier still works after a rebuild', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(_watching, (_, _) {});

      container.read(_dependency.notifier).increment();
      container.read(_watching);
      await container.read(_watching.notifier).load();

      expect(container.read(_watching), const BaseState.data(1));
    });

    test('PaginatedNotifier still works after a rebuild', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(_paginated, (_, _) {});

      container.read(_dependency.notifier).increment();
      expect(container.read(_paginated), const PaginatedState<int>.loading());
      await container.read(_paginated.notifier).getInitialList();

      expect(
        container.read(_paginated),
        const PaginatedState.loaded([1], isLastPage: true),
      );
    });
  });

  testWidgets('BaseWidget can wrap MaterialApp, as the README shows', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: BaseWidget(
          onGlobalFailure: (_) {},
          onGlobalInfo: (_) {},
          child: const MaterialApp(home: Text('home')),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('the global loading overlay shows above MaterialApp', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: BaseWidget(
          onGlobalFailure: (_) {},
          onGlobalInfo: (_) {},
          child: const MaterialApp(home: Text('home')),
        ),
      ),
    );
    container.read(globalLoadingProvider.notifier).show();
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(BaseLoadingIndicator), findsOneWidget);
  });

  testWidgets('a global failure can show a snackbar via MaterialApp.builder', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          builder:
              (context, child) => BaseWidget(
                onGlobalFailure:
                    (failure) => ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(failure.title))),
                onGlobalInfo: (_) {},
                child: child!,
              ),
          home: const Scaffold(body: Text('home')),
        ),
      ),
    );
    container
        .read(globalFailureProvider.notifier)
        .set(Failure.generic(title: 'boom'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('boom'), findsOneWidget);
  });
}
