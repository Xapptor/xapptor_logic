import 'dart:math';

int random_number_with_range(int min, int max) {
  final _random = new Random();
  return min + _random.nextInt(max - min);
}
