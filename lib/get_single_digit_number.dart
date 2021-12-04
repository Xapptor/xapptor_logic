int get_single_digit_number_from_string(String key) {
  List<int> key_code_units = key.codeUnits;
  int code_units_summary = 0;

  key_code_units.forEach((code_unit) {
    code_units_summary += code_unit;
  });

  //print("key_code_units: " + key_code_units.toString());

  return get_single_digit_number_fron_number(code_units_summary);
}

int get_single_digit_number_fron_number(int number) {
  int single_digit_summary = add_numbers_between_them(number);
  //print("single_digit_summary: " + single_digit_summary.toString());

  int security_counter = 0;
  while (single_digit_summary.toString().length > 1 && security_counter < 10) {
    single_digit_summary = add_numbers_between_them(single_digit_summary);

    //print("single_digit_summary: " + single_digit_summary.toString());

    security_counter++;
  }
  return single_digit_summary;
}

int add_numbers_between_them(int number) {
  String number_string = number.toString();
  int number_string_summary = 0;

  number_string.split('').forEach((char) {
    number_string_summary += int.parse(char);
  });

  return number_string_summary;
}
