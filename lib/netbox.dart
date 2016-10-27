library firestyle.cl.netbox;

import 'dart:async';

import 'package:firefirestyle.httprequest/request.dart' as req;
import 'package:firefirestyle.httprequest/request_ver_html.dart' as req;
import 'package:firefirestyle.miniprop/miniprop.dart' as prop;
//import 'dart:convert' as conv;
import 'dart:typed_data' as typed;
//
//
//

class LogoutProp {
  prop.MiniProp prop;
  LogoutProp(this.prop) {}
}

class UploadFileProp {
  prop.MiniProp prop;
  UploadFileProp(this.prop) {}

  String get blobKey => prop.getString("blobkey", "");
}

class FileNBox {
  req.NetBuilder builder;
  String backAddr;
  String callbackopt = "cb";
  FileNBox(this.builder, this.backAddr) {}

  Future<String> getFromKey(String key) async {
    return "${backAddr}/api/v1/blob/get?key=${Uri.encodeComponent(key)}";
  }

  Future<UploadFileProp> updateIcon(String accessToken, String dir, String name, typed.Uint8List data) async {
    String url = [
      backAddr, //
      """/api/v1/blob/requesturl""", //
      """?dir=${Uri.encodeComponent(dir)}&file=${Uri.encodeComponent(name)}"""
    ].join("");

    var uelPropObj = new prop.MiniProp();
    uelPropObj.setString("token", accessToken);
    req.Response response = await (await builder.createRequester()).request(req.Requester.TYPE_POST, url, data: uelPropObj.toJson(errorIsThrow: false));
    if (response.status != 200) {
      throw "failed to get request token";
    }
    var responsePropObj = new prop.MiniProp.fromByte(response.response.asUint8List());
    var tokenUrl = responsePropObj.getString("token", "");
    //new prop.MiniProp.fromByte(response.response.asUint8List());
    print(""" TokenUrl = ${tokenUrl} """);
    req.Multipart multipartObj = new req.Multipart();
    var responseFromUploaded = await multipartObj.post(await builder.createRequester(), tokenUrl, [
      new req.MultipartItem.fromList("file", "blob", "image/png", data) //
    ]);
    if (responseFromUploaded.status != 200) {
      throw "failed to uploaded";
    }

    return new UploadFileProp(new prop.MiniProp.fromByte(responseFromUploaded.response.asUint8List(), errorIsThrow: false));
  }
}

class MeNBox {
  req.NetBuilder builder;
  String backAddr;
  String callbackopt = "cb";
  MeNBox(this.builder, this.backAddr) {}
  String makeLoginTwitterUrl(String callbackAddr) {
    return """${backAddr}/api/v1/twitter/tokenurl/redirect?${callbackopt}=${Uri.encodeComponent(callbackAddr)}""";
  }

  Future<LogoutProp> logout(String token) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/me/logout";
    var pro = new prop.MiniProp();
    pro.setString("token", token);

    req.Response response = await requester.request(req.Requester.TYPE_GET, url, data: pro.toJson(errorIsThrow: false));
    if (response.status != 200) {
      throw new Exception("");
    }
    return new LogoutProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<UploadFileProp> updateIcon(String accessToken, String userName, typed.Uint8List data) async {
    return (new FileNBox(builder, backAddr)).updateIcon(accessToken, "/user/" + userName, "meicon", data);
  }
}

class UserInfoProp {
  prop.MiniProp prop;
  UserInfoProp(this.prop) {}

  String get displayName => prop.getString("DisplayName", "");
  String get userName => prop.getString("UserName", "");
  int get created => prop.getNum("Created", 0);
  int get logined => prop.getNum("Logined", 0);
  String get state => prop.getString("State", "");
  int get point => prop.getNum("Point", 0);
  String get iconUr => prop.getString("IconUrl", "");
  String get publicInfo => prop.getString("PublicInfo", "");
  String get privateInfo => prop.getString("PrivateInfo", "");
}

class UserKeyListProp {
  prop.MiniProp prop;
  UserKeyListProp(this.prop) {}
  List<String> get keys => this.prop.getPropStringList(null, "keys", []);
}

//
// /api/v1/art/new

class ErrorProp {
  prop.MiniProp prop;
  ErrorProp(this.prop) {}
  //"errorCode"
  //"errorMessage"
  int get errorCode => prop.getNum("errorCode", 0);
  String get errorMessage => prop.getString("errorMessage", "");
}
class NewArtProp {
  prop.MiniProp prop;
  NewArtProp(this.prop) {}
}

class ArtNBox {
  req.NetBuilder builder;
  String backAddr;
  ArtNBox(this.builder, this.backAddr) {}
  //
  Future<NewArtProp> newArt(String userName,{String title:"", String cont:""}) async {
    var requester = await builder.createRequester();
    var url = ["""${backAddr}/api/v1/art/new"""].join();
    var inputData = new prop.MiniProp();
    inputData.setString("ownerName", userName);
    inputData.setString("title", title);
    inputData.setString("content", cont);
    req.Response response = await requester.request(req.Requester.TYPE_POST, url,data: inputData.toJson());
    if (response.status != 200) {
      throw new ErrorProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new NewArtProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

}

//
//
class UserNBox {
  req.NetBuilder builder;
  String backAddr;
  UserNBox(this.builder, this.backAddr) {}
  //
  Future<UserInfoProp> getUserInfo(String userName) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/user/get?userName=${Uri.encodeComponent(userName)}";
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserInfoProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<UserInfoProp> getUserInfoFromKey(String key) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/user/get?key=${Uri.encodeComponent(key)}";
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserInfoProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<UserKeyListProp> findUser(String cursor) async {
    var url = "${backAddr}/api/v1/user/find";
    var requester = await builder.createRequester();
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserKeyListProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }
}
