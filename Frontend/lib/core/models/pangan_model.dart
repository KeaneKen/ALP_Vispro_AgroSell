class PanganModel {
  final String idPangan;
  final String namaPangan;
  final String deskripsiPangan;
  final double hargaPangan;
  final String idFotoPangan;
  final String category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PanganModel({
    required this.idPangan,
    required this.namaPangan,
    required this.deskripsiPangan,
    required this.hargaPangan,
    required this.idFotoPangan,
    this.category = 'Lainnya',
    this.createdAt,
    this.updatedAt,
  });

  // From JSON
  factory PanganModel.fromJson(Map<String, dynamic> json) {
    return PanganModel(
      idPangan: json['idPangan'] ?? '',
      namaPangan: json['Nama_Pangan'] ?? '',
      deskripsiPangan: json['Deskripsi_Pangan'] ?? '',
      hargaPangan: double.tryParse(json['Harga_Pangan'].toString()) ?? 0.0,
      idFotoPangan: json['idFoto_Pangan'] ?? '',
      category: json['category'] ?? 'Lainnya',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'idPangan': idPangan,
      'Nama_Pangan': namaPangan,
      'Deskripsi_Pangan': deskripsiPangan,
      'Harga_Pangan': hargaPangan,
      'idFoto_Pangan': idFotoPangan,
      'category': category,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // For creating new Pangan (without ID and timestamps)
  Map<String, dynamic> toCreateJson() {
    return {
      'Nama_Pangan': namaPangan,
      'Deskripsi_Pangan': deskripsiPangan,
      'Harga_Pangan': hargaPangan,
      'idFoto_Pangan': idFotoPangan,
      'category': category,
    };
  }
}
