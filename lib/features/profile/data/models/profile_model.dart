class ProfileModel {
  final String id;
  final String name;
  final String? country;
  final String? city;
  final String? mobileNumber;
  final String? zipCode;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    required this.name,
    this.country,
    this.city,
    this.mobileNumber,
    this.zipCode,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'],
      city: json['city'],
      mobileNumber: json['mobile_number'],
      zipCode: json['zip_code'],
      profileImage: json['profile_image'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'city': city,
      'mobile_number': mobileNumber,
      'zip_code': zipCode,
      'profile_image': profileImage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
