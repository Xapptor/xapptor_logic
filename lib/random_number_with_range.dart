import 'dart:math';

// Return a random number between a range.

int random_number_with_range(int min, int max) {
  final _random = new Random();
  return min + _random.nextInt(max - min);
}
