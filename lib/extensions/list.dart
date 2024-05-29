extension Swap on List {
  void swap(int firstIndex, int secondIndex) {
    final temp = this[firstIndex];
    this[firstIndex] = this[secondIndex];
    this[secondIndex] = temp;
  }
}
