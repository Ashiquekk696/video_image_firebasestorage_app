 
class HomeModel {
  String? id;
  String? slug;
  String? createdAt;
  String? updatedAt; 
  int? width;
  int? height;
  String? color;
  String? blurHash;
  String? description;
  String? altDescription;
  List<Null>? breadcrumbs;
  Urls? urls;
  int? likes;
  bool? likedByUser;
  List<Null>? currentUserCollections;
  Sponsorship? sponsorship;

  HomeModel(
      {this.id,
      this.slug,
      this.createdAt,
      this.updatedAt, 
      this.width,
      this.height,
      this.color,
      this.blurHash,
      this.description,
      this.altDescription,
      this.breadcrumbs,
      this.urls,
      this.likes,
      this.likedByUser,
      this.currentUserCollections,
      this.sponsorship});

  HomeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at']; 
    width = json['width'];
    height = json['height'];
    color = json['color'];
    blurHash = json['blur_hash'];
    description = json['description'];
    altDescription = json['alt_description'];
   
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
    likes = json['likes'];
    likedByUser = json['liked_by_user'];
  
    sponsorship = json['sponsorship'] != null
        ? new Sponsorship.fromJson(json['sponsorship'])
        : null;
  }
}

class Urls {
  String? raw;
  String? full;
  String? regular;
  String? small;
  String? thumb;
  String? smallS3;

  Urls(
      {this.raw,
      this.full,
      this.regular,
      this.small,
      this.thumb,
      this.smallS3});

  Urls.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    full = json['full'];
    regular = json['regular'];
    small = json['small'];
    thumb = json['thumb'];
    smallS3 = json['small_s3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['raw'] = this.raw;
    data['full'] = this.full;
    data['regular'] = this.regular;
    data['small'] = this.small;
    data['thumb'] = this.thumb;
    data['small_s3'] = this.smallS3;
    return data;
  }
}

class Sponsorship {
  String? tagline;
  String? taglineUrl;

  Sponsorship({this.tagline, this.taglineUrl});

  Sponsorship.fromJson(Map<String, dynamic> json) {
    tagline = json['tagline'];
    taglineUrl = json['tagline_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tagline'] = this.tagline;
    data['tagline_url'] = this.taglineUrl;
    return data;
  }
}
