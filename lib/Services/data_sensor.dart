class DataSensor {
  final num humiData;
  final num lightData;
  final String rainData;
  final num soilData;
  final num tempData;

  DataSensor({
    required this.humiData,
    required this.lightData,
    required this.rainData,
    required this.soilData,
    required this.tempData,
  });
  factory DataSensor.formRTDB(Map<String, dynamic> data) {
    return DataSensor(
        humiData: data['Humidity'],
        lightData: data['Light'],
        rainData: data['Rain'],
        soilData: data['Soil'],
        tempData: data['Temperature']);
  }
}
