String dateToString(DateTime date) {
  DateTime now = DateTime.now();
  DateTime left = DateTime.fromMillisecondsSinceEpoch(
      (date.millisecondsSinceEpoch - now.millisecondsSinceEpoch) * 1000);
  date = left;
  if (date.year > 1970) {
    return '${date.year - 1970} year(s)';
  } else if (date.month > 1) {
    return '${date.month - 1} month(s)';
  } else if (date.day > 1) {
    return '${date.day - 1} day(s)';
  } else if (date.hour > 7) {
    return '${date.hour - 7} hour(s)';
  } else if (date.minute > 0) {
    return '${date.minute} minute(s)';
  } else if (date.second > 0) {
    return '${date.second} second(s)';
  }
  return 'Due date passed';
}
