import 'dart:isolate';
import 'dart:typed_data';

import '../image/image.dart';
import 'command.dart';
import 'execute_result.dart';

class _Params {
  final SendPort port;
  final Command? command;
  _Params(this.port, this.command);
}

Future<Image?> _getImage(_Params p) async {
  await p.command?.execute();
  final res = p.command?.outputImage;
  Isolate.exit(p.port, res);
}

Future<Uint8List?> _getBytes(_Params p) async {
  await p.command?.execute();
  final res = p.command?.outputBytes;
  Isolate.exit(p.port, res);
}

Future<ExecuteResult> _getResult(_Params p) async {
  await p.command?.execute();
  Isolate.exit(p.port, ExecuteResult(p.command?.outputImage,
      p.command?.outputBytes, p.command?.outputObject));
}

Future<ExecuteResult> executeCommandAsync(Command? command) async {
  final port = ReceivePort();
  await Isolate.spawn(_getResult, _Params(port.sendPort, command));
  return await port.first as ExecuteResult;
}

Future<Image?> executeCommandImage(Command? command) async {
  await command?.execute();
  return command?.outputImage;
}

Future<Image?> executeCommandImageAsync(Command? command) async {
  final port = ReceivePort();
  await Isolate.spawn(_getImage, _Params(port.sendPort, command));
  return await port.first as Image?;
}

Future<Uint8List?> executeCommandBytes(Command? command) async {
  await command?.execute();
  return command?.outputBytes;
}

Future<Uint8List?> executeCommandBytesAsync(Command? command) async {
  final port = ReceivePort();
  await Isolate.spawn(_getBytes, _Params(port.sendPort, command));
  return await port.first as Uint8List?;
}
