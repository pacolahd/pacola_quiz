import 'package:dartz/dartz.dart';
import 'package:pacola_quiz/core/errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultStream<T> = Stream<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
