class BmiValue {
  final double weight;
  final double size;

  int getBmi() {
    return (weight / (size * size)).round();
  }

  BmiValue(this.weight, this.size);
}