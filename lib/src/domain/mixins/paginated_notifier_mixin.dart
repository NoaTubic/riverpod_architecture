import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_architecture/paginated_notifier.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';
import 'package:riverpod_architecture/src/domain/mixins/paginated_stream_notifier_mixin.dart';

typedef PaginatedEitherFailureOr<Entity>
    = Future<Either<Failure, PaginatedList<Entity>>>;

mixin PaginatedNotifierMixin<Entity, Param>
    on PaginatedStreamNotifierMixin<Entity, Param> {
  @protected
  PaginatedEitherFailureOr<Entity> getListOrFailure(
    int page, [
    Param? parameter,
  ]);

  @override
  PaginatedStreamFailureOr<Entity> getListStreamOrFailure(
    int page, [
    Param? parameter,
  ]) =>
      getListOrFailure(page, parameter).asStream();
}
