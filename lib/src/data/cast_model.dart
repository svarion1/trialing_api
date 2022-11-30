import 'dart:ui';

class CastModel {
CastModel({
    required this.person,

  });

  Person person;




  factory CastModel.fromJson(Map<String, dynamic> json) => CastModel(
        person: Person.fromJson(json["person"]),



      );

  Map<String, dynamic> toJson() => {
        "person": person!.toJson(),

      };
}

class Person {
  int id;
  String url;
  String name;
  Image image;

  Person({
    required this.id,
    required this.url,
    required this.name,
    required this.image,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["id"],
        url: json["url"],
        name: json["name"],
        image: Image.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['url'] = this.url;
        data['name'] = this.name;
        if (this.image != null) {
        data['image'] = this.image!.toJson();
        }

        return data;
      }

}

class Image {
  String medium;
  String original;

  Image({
    required this.medium,
    required this.original,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        medium: json["medium"],
        original: json["original"],
      );

  Map<String, dynamic> toJson() => {
        "medium": medium,
        "original": original,
      };

}