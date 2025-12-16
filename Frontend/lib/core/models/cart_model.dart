class CartModel {
  final String idCart;
  final String idPangan;
  final int jumlahPembelian;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Optional: Include pangan details when fetched from backend
  final PanganDetails? pangan;

  CartModel({
    required this.idCart,
    required this.idPangan,
    required this.jumlahPembelian,
    this.createdAt,
    this.updatedAt,
    this.pangan,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      idCart: json['idCart'] ?? '',
      idPangan: json['idPangan'] ?? '',
      jumlahPembelian: json['Jumlah_Pembelian'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      pangan: json['pangan'] != null 
          ? PanganDetails.fromJson(json['pangan']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCart': idCart,
      'idPangan': idPangan,
      'Jumlah_Pembelian': jumlahPembelian,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'idPangan': idPangan,
      'Jumlah_Pembelian': jumlahPembelian,
    };
  }
}

// Helper class for pangan details in cart
class PanganDetails {
  final String namaPangan;
  final double hargaPangan;

  PanganDetails({
    required this.namaPangan,
    required this.hargaPangan,
  });

  factory PanganDetails.fromJson(Map<String, dynamic> json) {
    return PanganDetails(
      namaPangan: json['Nama_Pangan'] ?? '',
      hargaPangan: double.tryParse(json['Harga_Pangan'].toString()) ?? 0.0,
    );
  }
}
