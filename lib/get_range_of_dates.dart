List<DateTime> get_range_of_dates(DateTime date_1, DateTime date_2) {
  int dates_difference_in_days = date_2.difference(date_1).inDays;

  List<DateTime> range_of_dates = [];

  for (var i = 0; i <= dates_difference_in_days; i++) {
    range_of_dates.add(
      DateTime(
        date_1.year,
        date_1.month,
        date_1.day + i,
      ),
    );
  }
  //debugPrint("range_of_dates");
  //debugPrint(range_of_dates);
  return range_of_dates;
}
