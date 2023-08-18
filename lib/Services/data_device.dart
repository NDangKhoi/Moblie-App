class DataDevice {
  final String pumpData;
  final String fanData;
  final String lampData;
  final String stepperData;
  DataDevice(
      {required this.pumpData,
      required this.fanData,
      required this.lampData,
      required this.stepperData});
  factory DataDevice.formRTDB(Map<String, dynamic> data) {
    return DataDevice(
        lampData: data['Lamp'],
        fanData: data['Fan'],
        pumpData: data['Pump'],
        stepperData: data['Stepper']);
  }
}
