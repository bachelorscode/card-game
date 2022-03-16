import 'package:game/src/config.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart'
    show io, Socket, OptionBuilder, protocol, cache;

class RTCController extends GetxController {
  late Socket _socket;
  bool connectd = false;

  connect({required String token}) {
    _socket = io(
      Config.url,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({"hello": "Test"})
          .build(),
    );

    _socket.connect();
    connectd = _socket.connected;
  }

  suspendGame({required Function calllback}) {
    _socket.on('SUSPEND_GAME', (data) => calllback(data));
  }

  unsuspendGame({required Function callback}) {
    print('hey');
    _socket.on('UNSESPEND_GAME', (data) => callback(data));
  }

  createEvent({required String eventName, required Function callback}) {
    _socket.on(eventName, (data) => callback(data));
  }

  emitEvent({required String eventName, required data}) {
    _socket.emit(eventName, data);
  }

  closeConnection() {
    _socket.clearListeners();
    _socket.close();
  }
}
