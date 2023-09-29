import 'dart:math';

// Return a random number between a range.

int random_number_with_range(int min, int max) {
  final random = Random();
  return min + random.nextInt(max - min);
}
