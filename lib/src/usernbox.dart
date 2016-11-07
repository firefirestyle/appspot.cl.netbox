part of firestyle.cl.netbox;

//
//

class UserKeyListProp {
  prop.MiniProp prop;
  UserKeyListProp(this.prop) {}
  List<String> get keys => this.prop.getPropStringList(null, "keys", []);
  String get cursorOne => this.prop.getString("cursorOne", "");
  String get cursorNext => this.prop.getString("cursorNext", "");
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
  String get iconUrl => prop.getString("IconUrl", "");
  String get publicInfo => prop.getString("PublicInfo", "");
  String get privateInfo => prop.getString("PrivateInfo", "");
  String get sign => prop.getString("Sign", "");
  String get content => prop.getString("Cont", "");
}

class UserNBox {
  static const String modeNewOwder = "";
  static const String modeMPoint = "-point";
  req.NetBuilder builder;
  String backAddr;
  UserNBox(this.builder, this.backAddr) {}

  Future<String> makeUserBlobFromKey(String key) async {
    return makeUserBlob(key);
  }

  Future<String> makeUserBlobPath(String useName, String dir, String file, {String sign: ""}) async {
    return makeUserBlob("",useName: useName,dir:dir,file: file,sign: sign);
  }

  Future<String> makeUserBlob(String key, {String useName: "", String dir: "", String file: "", String sign: ""}) async {
    key = key.replaceAll("key://", "");
    return [
      """${backAddr}/api/v1/user/getblob""", //
      """?key=${Uri.encodeComponent(key)}""", //
      """&dir=${Uri.encodeComponent(dir)}""",
      """&file=${Uri.encodeComponent(file)}""",
      """&sign=${Uri.encodeComponent(sign)}""",
    ].join("");
  }

  //
  Future<UserInfoProp> getUserInfo(String userName, {String sign:""}) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/user/get?userName=${Uri.encodeComponent(userName)}&sign=${Uri.encodeComponent(sign)}";
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

  Future<UserKeyListProp> findUser(String cursor, {String group: "", String mode: ""}) async {
    var url = "${backAddr}/api/v1/user/find?mode=${Uri.encodeComponent(mode)}&group=${Uri.encodeComponent(group)}";
    var requester = await builder.createRequester();
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserKeyListProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }
}
