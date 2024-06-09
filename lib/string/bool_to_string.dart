String bool_to_string({
  required bool value,
  required String true_text,
  required String false_text,
}) =>
    value ? true_text : false_text;
