import 'package:start/start.dart';

main() {
  start(host: '0.0.0.0', port: 8080).then((Server app) {
    app.static('../build/web');
  });
}