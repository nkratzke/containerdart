import 'package:start/start.dart';

main() {
  start(port: 8080).then((Server app) {
    app.static('../build/web');
  });
}