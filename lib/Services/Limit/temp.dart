class TempLimit {
  final String lower;
  final String higher;
  TempLimit({required this.lower, required this.higher});
  factory TempLimit.formRTDB(Map<String, dynamic> data) {
    return TempLimit(lower: data['LOW'], higher: data['HIGH']);
  }
}
