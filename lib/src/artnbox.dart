part of firestyle.cl.netbox;

class ArtKeyListProp {
  pro.MiniProp prop;
  ArtKeyListProp(this.prop) {}
  List<String> get keys => this.prop.getPropStringList(null, "keys", []);
  String get cursorOne => this.prop.getPropString(null, "cursorOne", "");
  String get cursorNext => this.prop.getPropString(null, "cursorNext", "");
}

class NewArtProp {
  pro.MiniProp prop;
  NewArtProp(this.prop) {}
  String get articleId => this.prop.getString("articleId", "");
}

class ArtInfoProp {
  pro.MiniProp prop;

  ArtInfoProp(this.prop) {
    if (this.prop == null) {
      this.prop = new pro.MiniProp();
    }
  }

  factory ArtInfoProp.empty() {
    return new ArtInfoProp(null);
  }

  String get projectId => prop.getString(ArtNBox.TypeProjectId, "");
  String get userName => prop.getString(ArtNBox.TypeUserName, "");
  String get userSign => prop.getString("userSign", "");
  String get title => prop.getString(ArtNBox.TypeTitle, "");
  List<String> get tags => prop.getPropStringList(null, ArtNBox.TypeTag, []);
  String get cont => prop.getString(ArtNBox.TypeCont, "");
  String get info => prop.getString(ArtNBox.TypeInfo, "");
  String get sign => prop.getString(ArtNBox.TypeSign, "");
  String get articleId => prop.getString(ArtNBox.TypeArticleId, "");
  List<String> get propNames => prop.getPropStringList(null, "PropNames", []);
  List<String> get propValues => prop.getPropStringList(null, "PropValues", []);

  num get created => prop.getNum(ArtNBox.TypeCreated, 0);
  num get updated => prop.getNum(ArtNBox.TypeUpdated, 0);
  num get lat => prop.getNum("Lat", 0);
  num get lng => prop.getNum("Lng", 0);
  String get secretKey => prop.getString(ArtNBox.TypeSecretKey, "");
  String get iconUrl => prop.getString("IconUrl", "");
  String getProp(String name, String defaultValue) {
    int index = propNames.indexOf(name);
    if (index <= -1) {
      return defaultValue;
    } else {
      var propObj = new pro.MiniProp.fromString(propValues[index]);
      return propObj.getString(name, defaultValue);
    }
  }
}

class ArtNBox {
  static final String TypeProjectId = "ProjectId";
  static final String TypeUserName = "UserName";
  static final String TypeTitle = "Title";
  static final String TypeTag = "Tag";
  static final String TypeCont = "Cont";
  static final String TypeInfo = "Info";
  static final String TypeType = "Type";
  static final String TypeSign = "Sign";
  static final String TypeArticleId = "ArticleId";
  static final String TypeCreated = "Created";
  static final String TypeUpdated = "Updated";
  static final String TypeSecretKey = "SecretKey";
  static final String TypeTarget = "Target";
  //
  static const String ModeQuery = "q";
  static const String ModeSign = "s";

  req.NetBuilder builder;
  String backAddr;
  String basePath;
  ArtNBox(this.builder, this.backAddr, {this.basePath: "/api/v1/art"}) {}
  //

  Future<String> makeBlobUrlFromKey(String key) async {
    return makeArtBlob(key);
  }

  Future<String> makeArtBlob(String key, {String userName: "", String dir: "", String file: "", String sign: ""}) async {
    key = key.replaceAll("key://", "");
    return [
      """${backAddr}${this.basePath}/getblob""", //
      """?key=${Uri.encodeComponent(key)}""", //
      """&userName=${Uri.encodeComponent(userName)}""",
      """&dir=${Uri.encodeComponent(dir)}""",
      """&file=${Uri.encodeComponent(file)}""",
      """&sign=${Uri.encodeComponent(sign)}""",
    ].join("");
  }

  Future<ArtInfoProp> getArtFromStringId(String stringId) async {
    var requester = await builder.createRequester();
    var url = ["""${backAddr}${this.basePath}/get""", "?key=" + Uri.encodeComponent(stringId)].join();
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new ErrorProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new ArtInfoProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<ArtInfoProp> getArtFromArticleId(String articleId, String sign, {String mode: ModeSign}) async {
    var requester = await builder.createRequester();
    var url = [
      """${backAddr}${this.basePath}/get""", //
      """?articleId=${Uri.encodeComponent(articleId)}""",
      """&sign=${Uri.encodeComponent(sign)}"""
    ].join();
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new ErrorProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new ArtInfoProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<NewArtProp> newArt(String accessToken,
      {String articleId: "", //
      String title: "",
      String cont: "",
      String info: "",
      String target: "",
      List<String> tags,
      int lat: 0,
      int lng: 0,
      Map<String, String> props: const {}}) async {
    var requester = await builder.createRequester();
    var url = ["""${backAddr}${this.basePath}/new"""].join();
    var inputData = new pro.MiniProp();
    inputData.setString("title", title);
    inputData.setString("content", cont);
    inputData.setString("token", accessToken);
    inputData.setString("target", target);
    inputData.setString("articleId", articleId);
    inputData.setString("info", info);
    inputData.setNum("lat", lat);
    inputData.setNum("lng", lng);
    inputData.setPropStringList(null, "tags", tags);
    {
      List<String> keys = [];
      List<String> values = [];
      for (var k in props.keys) {
        keys.add(k);
        values.add(props[k]);
      }
      inputData.setPropStringList(null, "propKey", keys);
      inputData.setPropStringList(null, "propValue", values);
    }
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: inputData.toJson());
    if (response.status != 200) {
      throw new ErrorProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new NewArtProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<NewArtProp> updateArt(String accessToken, String articleId,
      { //
      String title: "",
      String cont: "",
      String info: "",
      List<String> tags,
      int lat: 0,
      int lng: 0,
      Map<String, String> props: const {}}) async {
    var requester = await builder.createRequester();
    var url = ["""${backAddr}${this.basePath}/update"""].join();
    var inputData = new pro.MiniProp();
    inputData.setString("title", title);
    inputData.setString("content", cont);
    inputData.setString("token", accessToken);
    inputData.setString("articleId", articleId);
    inputData.setString("info", info);
    inputData.setNum("lat", lat);
    inputData.setNum("lng", lng);
    inputData.setPropStringList(null, "tags", tags);
    {
      List<String> keys = [];
      List<String> values = [];
      for (var k in props.keys) {
        keys.add(k);
        values.add(props[k]);
      }
      inputData.setPropStringList(null, "propKey", keys);
      inputData.setPropStringList(null, "propValue", values);
    }
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: inputData.toJson());
    if (response.status != 200) {
      throw new ErrorProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new NewArtProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<ArtKeyListProp> findArticle(String cursor, {String userName: "", Map<String,String> props: const{}, List<String> tags: const[]}) async {
    var urls = ["""${backAddr}${this.basePath}/find?cursor=${Uri.encodeComponent(cursor)}"""];
    if(userName != "" && userName != null) {
      urls.add("""&userNam=${Uri.encodeComponent(userName)}""");
    }
    //
    for(String k in props.keys) {
      urls.add("""&p-${Uri.encodeComponent(k)}=${Uri.encodeComponent(props[k])}""");
    }
    //
    for(int i=1;i<tags.length;i++) {
      urls.add("&t-${i}=${Uri.encodeComponent(tags[i])}");
    }
    //
    var url = urls.join("");
    var requester = await builder.createRequester();
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new ArtKeyListProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  //UrlArtFindMe
  Future<ArtKeyListProp> findArticleWithToken(String token, String cursor, {String userName: "", String target: ""}) async {
    var url = "${backAddr}${this.basePath}/find_with_token";
    var propObj = new pro.MiniProp();
    propObj.setString("token", token);
    propObj.setString("target", target);
    propObj.setString("userName", userName);
    var requester = await builder.createRequester();
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: propObj.toJson());
    if (response.status != 200) {
      throw new Exception("");
    }
    return new ArtKeyListProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<ArtKeyListProp> deleteArticleWithToken(String token, String articleId) async {
    var url = "${backAddr}${this.basePath}/delete";
    var propObj = new pro.MiniProp();
    propObj.setString("token", token);
    propObj.setString("articleId", articleId);
    var requester = await builder.createRequester();
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: propObj.toJson());
    if (response.status != 200) {
      throw new Exception("");
    }
    return new ArtKeyListProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  ///api/v1/art/requestbloburl
  Future<UploadFileProp> updateFile(String accessToken, String articleId, String dir, String name, typed.Uint8List data) async {
    String url = [
      backAddr, //
      """${this.basePath}/requestbloburl""",
    ].join("");

    var uelPropObj = new pro.MiniProp();
    uelPropObj.setString("token", accessToken);
    uelPropObj.setString("articleId", articleId);
    uelPropObj.setString("dir", dir);
    uelPropObj.setString("file", name);
    req.Response response = await (await builder.createRequester()).request(req.Requester.TYPE_POST, url, data: uelPropObj.toJson(errorIsThrow: false));
    if (response.status != 200) {
      throw "failed to get request token";
    }
    var responsePropObj = new pro.MiniProp.fromByte(response.response.asUint8List());
    var tokenUrl = responsePropObj.getString("token", "");
    var propName = responsePropObj.getString("name", "file");
    print(""" TokenUrl = ${tokenUrl} """);
    req.Multipart multipartObj = new req.Multipart();
    var responseFromUploaded = await multipartObj.post(await builder.createRequester(), tokenUrl, [
      new req.MultipartItem.fromList(propName, "blob", "image/png", data) //
    ]);
    if (responseFromUploaded.status != 200) {
      throw "failed to uploaded";
    }

    return new UploadFileProp(new pro.MiniProp.fromByte(responseFromUploaded.response.asUint8List(), errorIsThrow: false));
  }
}
