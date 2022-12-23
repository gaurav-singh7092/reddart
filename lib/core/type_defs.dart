import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/failure.dart';

typedef FutureEither<T> = Future<Either<failure, T>>;
typedef FutureVoid = FutureEither<void>;
