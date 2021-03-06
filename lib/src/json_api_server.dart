import 'dart:io';

import 'package:json_api/handler.dart';
import 'package:json_api/http.dart';
import 'package:json_api_server/src/dart_io_http_handler.dart';
import 'package:pedantic/pedantic.dart';

class JsonApiServer {
  JsonApiServer(
    this._handler, {
    this.host = 'localhost',
    this.port = 8080,
  });

  /// Server host name
  final String host;

  /// Server port
  final int port;

  final Handler<HttpRequest, HttpResponse> _handler;
  HttpServer _server;

  /// Server uri
  Uri get uri => Uri(scheme: 'http', host: host, port: port);

  /// starts the server
  Future<void> start() async {
    if (_server != null) return;
    try {
      _server = await HttpServer.bind(host, port);
      unawaited(_server.forEach(DartIOHttpHandler(_handler)));
    } on Exception {
      await stop();
      rethrow;
    }
  }

  /// Stops the server
  Future<void> stop({bool force = false}) async {
    if (_server == null) return;
    await _server.close(force: force);
    _server = null;
  }
}
