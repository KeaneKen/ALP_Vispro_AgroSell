class BumdesModel {
  final String idBumdes;
  final String namaBumdes;
  final String noTelpBumdes;
  final String emailBumdes;
  final String passwordBumdes;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BumdesModel({
    required this.idBumdes,
    required this.namaBumdes,
    this.noTelpBumdes = '',
    required this.emailBumdes,
    required this.passwordBumdes,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
  });

  factory BumdesModel.fromJson(Map<String, dynamic> json) {
    return BumdesModel(
      idBumdes: json['idBumDES'] ?? json['idBumDes'] ?? json['idBumdes'] ?? '',
      namaBumdes: json['Nama_BumDES'] ?? json['name'] ?? json['Nama_Bumdes'] ?? '',
      noTelpBumdes: json['NoTelp_BumDES'] ?? json['phone'] ?? json['NoTelp_Bumdes'] ?? '',
      emailBumdes: json['Email_BumDES'] ?? json['email'] ?? json['Email_Bumdes'] ?? '',
      passwordBumdes: json['Password_BumDES'] ?? json['password'] ?? json['Password_Bumdes'] ?? '',
      profilePicture: json['profile_picture'],
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
      'idBumDes': idBumdes,
      'name': namaBumdes,
      'phone': noTelpBumdes,
      'email': emailBumdes,
      'password': passwordBumdes,
      'profile_picture': profilePicture,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'idBumdes': idBumdes,
      'name': namaBumdes,
      'phone': noTelpBumdes,
      'email': emailBumdes,
      'password': passwordBumdes,
    };
  }
}
