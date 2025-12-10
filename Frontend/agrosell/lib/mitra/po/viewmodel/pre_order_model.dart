class PreOrderModel {
  final String id;
  final String supplierName;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final double totalAmount;
  final String status;
  final List<POItem> items;

  PreOrderModel({
    required this.id,
    required this.supplierName,
    required this.orderDate,
    required this.deliveryDate,
    required this.totalAmount,
    required this.status,
    required this.items,
  });
}

class POItem {
  final String productName;
  final int quantity;
  final double price;
  final String unit;

  POItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.unit,
  });
}