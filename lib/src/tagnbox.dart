part of firestyle.cl.netbox;

class TagAddTagProp {
  pro.MiniProp prop;
  TagAddTagProp(this.prop) {}
}

class TagNBox {
  req.NetBuilder builder;
  String backAddr;
  TagNBox(this.builder, this.backAddr) {}

  Future<Object> addTag(String accessToken, String value, List<String> tags) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/tag/add";
    pro.MiniProp propObj = new pro.MiniProp();
    propObj.setPropStringList(null, "tags", tags);
    propObj.setString("value", value);
    propObj.setString("token", accessToken);
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: propObj.toJson());
    if (response.status != 200) {
      throw new Exception("");
    }
    return new TagAddTagProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }
}
