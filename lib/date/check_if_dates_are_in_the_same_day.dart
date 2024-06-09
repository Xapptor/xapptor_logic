bool check_if_dates_are_in_the_same_day(
  DateTime date_1,
  DateTime date_2,
) {
  bool result = false;

  bool same_day = date_1.day == date_2.day;
  bool same_month = date_1.month == date_2.month;
  bool same_year = date_1.year == date_2.year;

  if (same_day && same_month && same_year) result = true;
  return result;
}
