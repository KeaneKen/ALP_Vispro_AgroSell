import 'payment_model.dart';

class RiwayatModel {
  final String idHistory;
  final String idPayment;
  final String status; // processing, given_to_courier, on_the_way, arrived, completed, cancelled
  final String? deliveryAddress;
  final String? phoneNumber;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Optional: Include payment details when fetched from backend
  final PaymentModel? payment;

  RiwayatModel({
    required this.idHistory,
    required this.idPayment,
    this.status = 'processing',
    this.deliveryAddress,
    this.phoneNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.payment,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      idHistory: json['idHistory'] ?? '',
      idPayment: json['idPayment'] ?? '',
      status: json['status'] ?? 'processing',
      deliveryAddress: json['delivery_address'],
      phoneNumber: json['phone_number'],
      notes: json['notes'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      payment: json['payment'] != null 
          ? PaymentModel.fromJson(json['payment']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idHistory': idHistory,
      'idPayment': idPayment,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = {
      'idPayment': idPayment,
      'status': status,
    };
    
    if (deliveryAddress != null) data['delivery_address'] = deliveryAddress;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (notes != null) data['notes'] = notes;
    
    return data;
  }
}
