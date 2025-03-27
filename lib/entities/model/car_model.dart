class CarModel {
  final String model;
  final int year;
  final String vehicleTag;
  final dynamic timestamp; // New field for date-time with seconds

  CarModel({
    required this.model,
    required this.year,
    required this.vehicleTag,
    required this.timestamp,
  });

  // Convert CarModel to Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      "model": model,
      "year": year,
      "vehicleTag": vehicleTag,
      "timestamp": timestamp, // Save timestamp as a string
    };
  }

  // Convert JSON to CarModel (for retrieval)
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      model: json["model"] ?? "",
      year: json["year"] ?? 0,
      vehicleTag: json["vehicleTag"] ?? "",
      timestamp: json["timestamp"] ?? "", // Retrieve timestamp
    );
  }
}
