class SubredditTestClass {
  String kind;
  SubredditTestClassData data;

  SubredditTestClass({
    this.kind,
    this.data,
  });
  SubredditTestClass.fromJson(Map<String, dynamic> json)
      : kind = json['kind'],
        data = json['data'] != null
            ? SubredditTestClassData.fromJson(json['data'])
            : null;
}

class SubredditTestClassData {
  List<Child> children;

  SubredditTestClassData({
    this.children,
  });
  SubredditTestClassData.fromJson(Map<String, dynamic> json) {
    if (json['children'] != null) {
      children = new List<Child>();
      json['children'].forEach((v) {
        children.add(new Child.fromJson(v));
      });
    }
  }
}

class Child {
  String kind;
  ChildData data;

  Child({
    this.kind,
    this.data,
  });
  Child.fromJson(Map<String, dynamic> json)
      : kind = json["kind"],
        data = json["data"] != null ? ChildData.fromJson(json["data"]) : null;
}

class ChildData {
  String displayname;

  ChildData({
    this.displayname,
  });
  ChildData.fromJson(Map<String, dynamic> json)
      : displayname = json["display_name_prefixed"];
}
