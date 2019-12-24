class Reddit {
  String kind;
  Data data;

  Reddit({this.kind, this.data});

  Reddit.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  String modhash;
  List<Children> children;

  Data({
    this.modhash,
    this.children,
  });

  Data.fromJson(Map<String, dynamic> json) {
    modhash = json['modhash'];
    if (json['children'] != null) {
      children = new List<Children>();
      json['children'].forEach((v) {
        children.add(new Children.fromJson(v));
      });
    }
  }
}

class Children {
  String kind;
  Post post;

  Children({this.kind, this.post});

  Children.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    post = json['data'] != null ? new Post.fromJson(json['data']) : null;
  }
}

class Post {
  String subreddit,
      title,
      name,
      subredditType,
      thumbnail,
      subredditId,
      id,
      postHint,
      author,
      permalink,
      url;
  Preview preview;

  Post(
      {this.subreddit,
      this.title,
      this.name,
      this.subredditType,
      this.thumbnail,
      this.postHint,
      this.preview});

  Post.fromJson(Map<String, dynamic> json) {
    subreddit = json['subreddit'];
    title = json['title'];
    postHint = json['post_hint'];
    name = json['name'];
    subredditType = json['subreddit_type'];
    thumbnail = json['thumbnail'];
    id = json['id'];
    author = json['author'];
    permalink = json['permalink'];
    url = json['url'];
    preview =
        json['preview'] != null ? new Preview.fromJson(json['preview']) : null;
  }
}

class Preview {
  List<Images> images;
  bool enabled;

  Preview({this.images, this.enabled});

  Preview.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    enabled = json['enabled'];
  }
}

class Images {
  Source source;
  List<Resolutions> resolutions;
  String id;

  Images({this.source, this.resolutions, this.id});

  Images.fromJson(Map<String, dynamic> json) {
    source =
        json['source'] != null ? new Source.fromJson(json['source']) : null;
    if (json['resolutions'] != null) {
      resolutions = new List<Resolutions>();
      json['resolutions'].forEach((v) {
        resolutions.add(new Resolutions.fromJson(v));
      });
    }
    id = json['id'];
  }
}

class Source {
  String url;
  int width;
  int height;

  Source({this.url, this.width, this.height});

  Source.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }
}

class Resolutions {
  String url;
  int width;
  int height;

  Resolutions({this.url, this.width, this.height});

  Resolutions.fromJson(Map<String, dynamic> json) {
    url = json['url'].replaceAll('amp;', '');
    width = json['width'];
    height = json['height'];
  }
}
