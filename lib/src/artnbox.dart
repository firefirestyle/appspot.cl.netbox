part of firestyle.cl.netbox;

class ArtKeyListProp {
  prop.MiniProp prop;
  ArtKeyListProp(this.prop) {}
  List<String> get keys => this.prop.getPropStringList(null, "keys", []);
}

class NewArtProp {
  prop.MiniProp prop;
  NewArtProp(this.prop) {}
}

class ArtInfoProp {
  prop.MiniProp prop;
  ArtInfoProp(this.prop) {}
  String get projectId => prop.getString(ArtNBox.TypeProjectId, "");
  String get userName => prop.getString(ArtNBox.TypeUserName, "");
  String get title => prop.getString(ArtNBox.TypeTitle, "");
  String get tag => prop.getString(ArtNBox.TypeTag, "");
  String get cont => prop.getString(ArtNBox.TypeCont, "");
  String get info => prop.getString(ArtNBox.TypeInfo, "");
  String get type => prop.getString(ArtNBox.TypeType, "");
  String get sign => prop.getString(ArtNBox.TypeSign, "");
  String get articleId => prop.getString(ArtNBox.TypeArticleId, "");
  num get created => prop.getNum(ArtNBox.TypeCreated, 0);
  num get updated => prop.getNum(ArtNBox.TypeUpdated, 0);
  String get secretKey => prop.getString(ArtNBox.TypeSecretKey, "");
  String get target => prop.getString(ArtNBox.TypeTarget, "");
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
  ArtNBox(this.builder, this.backAddr) {}
  //

  Future<ArtInfoProp> getArtFromStringId(String stringId) async {
    var requester = await builder.createRequester();
    var url = ["""${backAddr}/api/v1/art/get""", "?key=" + Uri.encodeComponent(stringId)].join();
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new ErrorProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new ArtInfoProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<ArtInfoProp> getArtFromArticleId(String articleId, String sign, {String mode: ModeSign}) async {
    var requester = await builder.createRequester();
    var url = [
      """${backAddr}/api/v1/art/get""", //
      """?articleId=${Uri.encodeComponent(articleId)}""",
      """&sign=${Uri.encodeComponent(sign)}""",
      """&m=${mode}"""
    ].join();
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new ErrorProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new ArtInfoProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<NewArtProp> newArt(String userName, {String title: "", String cont: ""}) async {
    var requester = await builder.createRequester();
    var url = ["""${backAddr}/api/v1/art/new"""].join();
    var inputData = new prop.MiniProp();
    inputData.setString("ownerName", userName);
    inputData.setString("title", title);
    inputData.setString("content", cont);
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: inputData.toJson());
    if (response.status != 200) {
      throw new ErrorProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new NewArtProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<ArtKeyListProp> findArticle(String cursor) async {
    var url = "${backAddr}/api/v1/art/find";
    var requester = await builder.createRequester();
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new ArtKeyListProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }
}
