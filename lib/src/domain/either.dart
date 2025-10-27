import 'package:either_dart/either.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';

typedef EitherFailureOr<T> = Future<Either<Failure, T>>;
typedef StreamFailureOr<T> = Stream<Either<Failure, T>>;
typedef PaginatedEitherFailureOr<Entity>
    = Future<Either<Failure, PaginatedList<Entity>>>;
