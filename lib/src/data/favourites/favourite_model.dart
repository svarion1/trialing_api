

class Favourite {
  final int id;
  final int isFavourite;

 const Favourite({
    required this.id,

    required this.isFavourite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'isFavourite': isFavourite,
    };
  }

  String toString() {
    return 'Favourite{id: $id, isFavourite: $isFavourite}';
  }

  fromMap(Map<String, dynamic> map) {
    return Favourite(
      id: map['id'],
      isFavourite: map['isFavourite'],
    );
  }

}