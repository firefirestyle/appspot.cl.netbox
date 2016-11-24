library firestyle.cl.netbox.io;

import "netbox.dart";

import 'package:firefirestyle.httprequest/request.dart';
import 'package:firefirestyle.httprequest/request_io.dart';
import 'package:firefirestyle.cl.netbox/netbox.dart';
import 'dart:io';
import 'dart:async';

enum OAuthLoginHelperType { facebook, twitter }

class OAuthLoginHelper {
  OAuthLoginHelperType type;
  String backAddr;
  String host;
  int port;

  OAuthLoginHelper(this.type, this.backAddr, {this.host: "localhost", this.port: 8085}) {}

  login({int timeoutSec: 180}) async {
    IONetBuilder builder = new IONetBuilder();
    MeNBox mebox = new MeNBox(builder, backAddr);
    Completer completer = new Completer();
    //
    Process process = null;
    HttpServer server = null;
    closeInner() {
      if (completer.isCompleted == false) {
        try {
          server.close(force: true);
        } catch (e) {}
        try {
          process.kill();
        } catch (e) {}
      }
    }
    server = await HttpServer.bind(host, port);
    server.listen((HttpRequest request) {
      print("<<uri>> ${request.uri.toString()}");
      if (request.uri.path == "/auth") {
        print("<<query param>> ${request.uri.queryParameters}");
        closeInner();//isMaster: 255, token: PuUrsNSqX0CyVoLVB21D33KJBcY=SS50kQpUdqnC/NNNvDE/4eFRU58=SkM1VDZZRVhD, userName: JC5T6YEXC}
        completer.complete();
      }
    });
    //
    //
    new Future.delayed(new Duration(seconds: timeoutSec)).then((v) {
      closeInner();
      completer.completeError("timeout");
    });
    //
    String oauthUrl = "";
    if (type == OAuthLoginHelperType.twitter) {
      oauthUrl = mebox.makeLoginTwitterUrl("http://localhost:8085/auth");
    } else {
      oauthUrl = mebox.makeLoginFacebookUrl("http://localhost:8085/auth");
    }
    process = await runBrowser(oauthUrl);
    //

    completer.future;
  }

  Future<Process> runBrowser(String url) async {
    String command = "start";
    if (Platform.isLinux) {
      command = "x-www-browser";
    } else if (Platform.isMacOS) {
      command = "open";
    } else if (Platform.isWindows) {
      command = "explorer";
    } else if (Platform.isIOS) {} else if (Platform.isAndroid) {}
    return await Process.start(command, [url]);
  }
}
