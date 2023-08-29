class Offer {
  String offerID;
  String description;

  Offer({required this.offerID, required this.description});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      offerID: json["offerID"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "offerID": offerID,
      "description": description,
    };
  }
}
