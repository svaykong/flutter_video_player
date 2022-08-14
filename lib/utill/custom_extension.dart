import 'dart:developer' as dev show log;

extension CustomLog on Object {
  void log(message) => dev.log("log::$message");
}
