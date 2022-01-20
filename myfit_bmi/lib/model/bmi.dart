class Bmi {
  final double weight;
  final double size;

  int getBmi() {
    return (weight / (size * size)).round();
  }

  Bmi(this.weight, this.size);
}