/// Represents a successful operation that doesn't return a value.
/// Used as the Right value in Either<Failure, Unit> for operations like save, delete, etc.
class Unit {
  const Unit();

  @override
  bool operator ==(Object other) => other is Unit;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'Unit()';
}
