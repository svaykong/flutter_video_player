import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log("log :: ${toString()}");
}
