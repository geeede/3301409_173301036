// To parse this JSON data, do
//
//     final mediaStack = mediaStackFromJson(jsonString);

import 'dart:convert';

MediaStack mediaStackFromJson(String str) => MediaStack.fromJson(json.decode(str));

String mediaStackToJson(MediaStack data) => json.encode(data.toJson());

class MediaStack {

  MediaStack({
    this.pagination,
    this.data,
  });

  Pagination? pagination;
  List<Datum>? data;

  factory MediaStack.fromJson(Map<String, dynamic> json) => MediaStack(
    pagination: Pagination.fromJson(json["pagination"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination!.toJson(),
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.author,
    this.title,
    this.description,
    this.url,
    this.source,
    this.image,
    this.category,
    this.language,
    this.country,
    this.publishedAt,
  });

  dynamic author;
  String? title;
  String? description;
  String? url;
  Source? source;
  String? image;
  Category? category;
  Language? language;
  Country? country;
  DateTime? publishedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    author: json["author"],
    title: json["title"],
    description: json["description"],
    url: json["url"],
    source: sourceValues.map[json["source"]],
    image: json["image"],
    category: categoryValues.map[json["category"]],
    language: languageValues.map[json["language"]],
    country: countryValues.map[json["country"]],
    publishedAt: DateTime.parse(json["published_at"]),
  );

  Map<String, dynamic> toJson() => {
    "author": author,
    "title": title,
    "description": description,
    "url": url,
    "source": sourceValues.reverse[source],
    "image": image,
    "category": categoryValues.reverse[category],
    "language": languageValues.reverse[language],
    "country": countryValues.reverse[country],
    "published_at": publishedAt?.toIso8601String(),
  };
}

enum Category { GENERAL }

final categoryValues = EnumValues({
  "general": Category.GENERAL
});

enum Country { TR }

final countryValues = EnumValues({
  "tr": Country.TR
});

enum Language { EN }

final languageValues = EnumValues({
  "en": Language.EN
});

enum Source { YENI_SAFAK }

final sourceValues = EnumValues({
  "Yeni Safak": Source.YENI_SAFAK
});

class Pagination {
  Pagination({
    this.limit,
    this.offset,
    this.count,
    this.total,
  });

  int? limit;
  int? offset;
  int? count;
  int? total;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    limit: json["limit"],
    offset: json["offset"],
    count: json["count"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "offset": offset,
    "count": count,
    "total": total,
  };
}

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);



  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
