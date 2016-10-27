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
}

class ArtNBox {
  req.NetBuilder builder;
  String backAddr;
  ArtNBox(this.builder, this.backAddr) {}
  //

  Future<ArtInfoProp> getArt(String stringId) async {
    var requester = await builder.createRequester();
    var url = ["""${backAddr}/api/v1/art/get""","?key="+Uri.encodeComponent(stringId)].join();
    req.Response response = await requester.request(req.Requester.TYPE_POST, url);
    if (response.status != 200) {
      throw new ErrorProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new ArtInfoProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

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
