

class Favourite {
  final int id;
  final int showId;
  final bool isFavourite;

 const Favourite({
    required this.id,
    required this.showId,
    required this.isFavourite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'showId': showId,
      'isFavourite': isFavourite,
    };
  }

  String toString() {
    return 'Favourite{id: $id, showId: $showId, isFavourite: $isFavourite}';
  }

  fromMap(Map<String, dynamic> map) {
    return Favourite(
      id: map['id'],
      showId: map['showId'],
      isFavourite: map['isFavourite'],
    );
  }

}