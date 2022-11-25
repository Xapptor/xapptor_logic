import 'dart:math';

class RandomAlphanumeric {
  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  String generate({required int length}) {
    Random random = Random();

    Iterable<int> char_list = Iterable.generate(
      length,
      (_) => chars.codeUnitAt(
        random.nextInt(chars.length),
      ),
    );
    return String.fromCharCodes(char_list);
  }

  String range5() {
    return generate(length: 5);
  }

  String range10() {
    return generate(length: 10);
  }

  String range15() {
    return generate(length: 15);
  }

  // Firebase Dcoument ID length is 20
  String range20() {
    return generate(length: 20);
  }

  String range30() {
    return generate(length: 30);
  }
}
