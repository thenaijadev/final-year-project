class Items {
  String? title;
  String? snippet;
  String? publisher;
  String? timestamp;
  String? newsUrl;
  Images? images;

  Items(
      {this.title,
      this.snippet,
      this.publisher,
      this.timestamp,
      this.newsUrl,
      this.images});

  Items.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    snippet = json['snippet'];
    publisher = json['publisher'];
    timestamp = json['timestamp'];
    newsUrl = json['newsUrl'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['snippet'] = snippet;
    data['publisher'] = publisher;
    data['timestamp'] = timestamp;
    data['newsUrl'] = newsUrl;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    return data;
  }
}

class Images {
  String? thumbnail;
  String? thumbnailProxied;

  Images({this.thumbnail, this.thumbnailProxied});

  Images.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'];
    thumbnailProxied = json['thumbnailProxied'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumbnail'] = thumbnail;
    data['thumbnailProxied'] = thumbnailProxied;
    return data;
  }
}
