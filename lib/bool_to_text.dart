bool_to_text({
  required bool value,
  required String true_text,
  required String false_text,
}) {
  return value ? true_text : false_text;
}
