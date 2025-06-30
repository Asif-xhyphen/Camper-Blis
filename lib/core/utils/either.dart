import 'package:freezed_annotation/freezed_annotation.dart';

part 'either.freezed.dart';

@freezed
class Either<L, R> with _$Either<L, R> {
  const factory Either.left(L value) = Left<L, R>;
  const factory Either.right(R value) = Right<L, R>;
}

extension EitherX<L, R> on Either<L, R> {
  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L? get leftOrNull => fold((l) => l, (r) => null);
  R? get rightOrNull => fold((l) => null, (r) => r);

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    return when(left: onLeft, right: onRight);
  }
}
