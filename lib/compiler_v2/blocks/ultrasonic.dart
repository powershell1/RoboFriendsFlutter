import '../../bluetooth/bluetooth.dart';
import '../compiler.dart';

class UltrasonicGet extends BlockFunctions {
  @override
  Future<num> runCode() async {
    await super.runCode();
    // print(BluetoothConnection.sensorValues);
    return BluetoothConnection.sensorValues[SensorType.ultrasonic] ?? 0;
  }
}