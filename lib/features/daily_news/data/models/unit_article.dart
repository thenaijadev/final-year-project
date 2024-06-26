// ignore_for_file: public_member_api_docs, sort_constructors_first
class Article {
  String? status;
  List<Items>? items;

  Article({
    this.status,
    this.items,
  });

  Article.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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
