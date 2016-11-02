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

  String makeLoginFacebookUrl(String callbackAddr) {
    return """${backAddr}/api/v1/facebook/tokenurl/redirect?${callbackopt}=${Uri.encodeComponent(callbackAddr)}""";
  }

  Future<UserInfoProp> getMeInfo(String accessToken) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/me/get";
    var inputData = new prop.MiniProp();
    inputData.setString("token", accessToken);
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: inputData.toJson(errorIsThrow: false));
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserInfoProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<UserInfoProp> updateUserInfo(String accessToken, String userName, {String displayName: "", String cont: "", List<String> tags}) async {
    var requester = await builder.createRequester();
    var url = ["""${backAddr}/api/v1/me/update"""].join();
    var inputData = new prop.MiniProp();
    inputData.setString("token", accessToken);
    inputData.setString("userName", userName);
    inputData.setString("displayName", displayName);
    inputData.setString("content", cont);
    inputData.setPropStringList(null, "tags", tags);
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: inputData.toJson());
    if (response.status != 200) {
      throw new ErrorProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new UserInfoProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
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
    return updateFile(accessToken, userName, "", "meicon", data);
  }

  //
  //
  //
  Future<UploadFileProp> updateFile(String accessToken, String userName, String dir, String name, typed.Uint8List data) async {
    String url = [
      backAddr, //
      """/api/v1/user/requestbloburl"""
    ].join("");

    var uelPropObj = new prop.MiniProp();
    uelPropObj.setString("token", accessToken);
    uelPropObj.setString("userName", userName);
    uelPropObj.setString("dir", dir);
    uelPropObj.setString("file", name);
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
