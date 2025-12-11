class BumdesModel {
  final String idBumdes;
  final String namaBumdes;
  final String noTelpBumdes;
  final String emailBumdes;
  final String passwordBumdes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BumdesModel({
    required this.idBumdes,
    required this.namaBumdes,
    required this.noTelpBumdes,
    required this.emailBumdes,
    required this.passwordBumdes,
    this.createdAt,
    this.updatedAt,
  });

  factory BumdesModel.fromJson(Map<String, dynamic> json) {
    return BumdesModel(
      idBumdes: json['idBumdes'] ?? '',
      namaBumdes: json['Nama_Bumdes'] ?? '',
      noTelpBumdes: json['NoTelp_Bumdes'] ?? '',
      emailBumdes: json['Email_Bumdes'] ?? '',
      passwordBumdes: json['Password_Bumdes'] ?? '',
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
      'idBumdes': idBumdes,
      'Nama_Bumdes': namaBumdes,
      'NoTelp_Bumdes': noTelpBumdes,
      'Email_Bumdes': emailBumdes,
      'Password_Bumdes': passwordBumdes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'Nama_Bumdes': namaBumdes,
      'NoTelp_Bumdes': noTelpBumdes,
      'Email_Bumdes': emailBumdes,
      'Password_Bumdes': passwordBumdes,
    };
  }
}
