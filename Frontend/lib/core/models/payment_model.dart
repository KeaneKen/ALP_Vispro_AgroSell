import 'cart_model.dart';

class PaymentModel {
  final String idPayment;
  final String idCart;
  final double totalHarga;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Optional: Include cart details when fetched from backend
  final CartModel? cart;

  PaymentModel({
    required this.idPayment,
    required this.idCart,
    required this.totalHarga,
    this.createdAt,
    this.updatedAt,
    this.cart,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      idPayment: json['idPayment'] ?? '',
      idCart: json['idCart'] ?? '',
      totalHarga: double.tryParse(json['Total_Harga']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      cart: json['cart'] != null 
          ? CartModel.fromJson(json['cart']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPayment': idPayment,
      'idCart': idCart,
      'Total_Harga': totalHarga,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'idCart': idCart,
      'Total_Harga': totalHarga,
    };
  }
}
