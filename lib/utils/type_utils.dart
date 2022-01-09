

DateTime? convertStringToDateTime(String dateTimeString) {
  final String parsedDateTimeString = dateTimeString.replaceAll("/", "-");
  return DateTime.parse(parsedDateTimeString);
}

