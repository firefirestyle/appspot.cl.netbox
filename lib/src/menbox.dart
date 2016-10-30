part of firestyle.cl.netbox;

class LogoutProp {
  prop.MiniProp prop;
  LogoutProp(this.prop) {}
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
    return updateFile(accessToken, userName,  "", "meicon", data);
  }

  //
  //
  //
  Future<UploadFileProp> updateFile(String accessToken, String userName, String dir, String name, typed.Uint8List data) async {
    String url = [
      backAddr, //
      """/api/v1/user/requestbloburl""", //
      """?userName=${Uri.encodeComponent(userName)}""", //
      """&dir=${Uri.encodeComponent(dir)}""",
      """&file=${Uri.encodeComponent(name)}"""
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
