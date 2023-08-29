class BarberReviews {
  String userId;
  double rating;

  BarberReviews({required this.userId, required this.rating});

  factory BarberReviews.fromJson(Map<String, dynamic> json) {
    return BarberReviews(
      userId: json["userId"],
      rating:0.0 + json["rating"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "rating": rating,
    };
  }
}
