bool check_if_dates_are_in_the_same_day(DateTime date_1, DateTime date_2) {
  bool same_day = false;
  if (date_1.day == date_2.day &&
      date_1.month == date_2.month &&
      date_1.year == date_2.year) {
    same_day = true;
  }
  return same_day;
}
