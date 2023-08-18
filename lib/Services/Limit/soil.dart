class SoilLimit {
  final String lower;
  final String higher;
  SoilLimit({required this.lower, required this.higher});
  factory SoilLimit.formRTDB(Map<String, dynamic> data) {
    return SoilLimit(lower: data['LOW'], higher: data['HIGH']);
  }
}