class TarotCard {
  int number;
  String name;
  String storytelling;
  String image;
  TarotCard({
    required this.number,
    required this.name,
    required this.storytelling,
    required this.image,
  });
  factory TarotCard.fromJson(Map<String, dynamic> json) {
    final imagePath = "assets/img/tarot_cards/${json['image']}";
    return TarotCard(
      number : json['number'],
      name : json['name'],
      storytelling : json['storytelling'],
      image : imagePath,
    );
  }
}