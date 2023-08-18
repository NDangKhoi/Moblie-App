class LightLimit {
  final String lower;
  final String higher;
  LightLimit({required this.lower, required this.higher});
  factory LightLimit.formRTDB(Map<String, dynamic> data) {
    return LightLimit(lower: data['LOW'], higher: data['HIGH']);
  }
}
