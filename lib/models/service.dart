class Service{
  String serviceId;
  double price;
  String serviceDescription;


  Service({required this.price,required this.serviceId,required this.serviceDescription});

  Map<String, dynamic> toJson() {
    return {
      "serviceId": serviceId,
      "price": price,
      "serviceDescription": serviceDescription,
    };
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json["serviceId"],
      price: 0.0 + json["price"],
      serviceDescription: json["serviceDescription"],
    );
  }

//

}