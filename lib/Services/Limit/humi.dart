class HumiLimit {
  final String lower;
  final String higher;
  HumiLimit({required this.lower, required this.higher});
  factory HumiLimit.formRTDB(Map<String, dynamic> data) {
    return HumiLimit(lower: data['LOW'], higher: data['HIGH']);
  }
}
