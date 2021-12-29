import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  late IO.Socket _socket;
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;

  SocketService() {
    this._initconfig();
  }

  void _initconfig() {
    this._socket = IO.io('https://flutter-socket-votes-app.herokuapp.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    socket.on('disconect', (_) {
      print('disconect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    socket.connect();

    socket.on('nuevo-mensaje', (payload) {
      print('nuevo-mensaje: $payload');
    });
  }
}
