import 'package:firefirestyle.httprequest/request.dart';
import 'package:firefirestyle.httprequest/request_io.dart';
import 'package:firefirestyle.cl.netbox/netbox.dart';
import 'package:firefirestyle.cl.netbox/netbox_io.dart';

import 'dart:io';
import 'dart:async';

main(List<String> args) async {
  String backAddr = args[0];
  OAuthLoginHelper helper = new OAuthLoginHelper(OAuthLoginHelperType.twitter,backAddr);
  print("start");
  MeNBoxLoginCB cbinfo = await helper.login();
  print("a : ${cbinfo.permission}");
  print("b : ${cbinfo.token}");
  print("c : ${cbinfo.userName}");
  print("d : ${cbinfo.error}");
  print("end");

}
