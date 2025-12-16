class MitraModel {
  final String idMitra;
  final String namaMitra;
  final String noTelpMitra;
  final String emailMitra;
  final String passwordMitra;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MitraModel({
    required this.idMitra,
    required this.namaMitra,
    this.noTelpMitra = '',
    required this.emailMitra,
    required this.passwordMitra,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
  });

  factory MitraModel.fromJson(Map<String, dynamic> json) {
    return MitraModel(
      idMitra: json['idMitra'] ?? '',
      namaMitra: json['Nama_Mitra'] ?? '',
      noTelpMitra: json['NoTelp_Mitra'] ?? '',
      emailMitra: json['Email_Mitra'] ?? '',
      passwordMitra: json['Password_Mitra'] ?? '',
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
      'idMitra': idMitra,
      'Nama_Mitra': namaMitra,
      'NoTelp_Mitra': noTelpMitra,
      'Email_Mitra': emailMitra,
      'Password_Mitra': passwordMitra,
      'profile_picture': profilePicture,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'Nama_Mitra': namaMitra,
      'NoTelp_Mitra': noTelpMitra,
      'Email_Mitra': emailMitra,
      'Password_Mitra': passwordMitra,
    };
  }
}
