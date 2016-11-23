library firestyle.cl.netbox;

import 'dart:async';

import 'package:firefirestyle.httprequest/request.dart' as req;
//import 'package:firefirestyle.httprequest/request_html.dart' as req;
import 'package:firefirestyle.miniprop/miniprop.dart' as pro;
//import 'dart:convert' as conv;
import 'dart:typed_data' as typed;
//
//
part 'src/usernbox.dart';
part 'src/filenbox.dart';
part 'src/menbox.dart';
part 'src/artnbox.dart';
//
//

class ErrorProp {
  pro.MiniProp prop;
  ErrorProp(this.prop) {}
  //"errorCode"
  //"errorMessage"
  int get errorCode => prop.getNum("errorCode", 0);
  String get errorMessage => prop.getString("errorMessage", "");
}
