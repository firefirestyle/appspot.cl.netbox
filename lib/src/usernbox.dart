part of firestyle.cl.netbox;

//
//

class UserKeyListProp {
  prop.MiniProp prop;
  UserKeyListProp(this.prop) {}
  List<String> get keys => this.prop.getPropStringList(null, "keys", []);
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