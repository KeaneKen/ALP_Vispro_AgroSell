import 'package:flutter/material.dart';
import 'payment_view.dart';

class PaymentStatusView extends StatefulWidget {
  const PaymentStatusView({super.key});

  @override
  State<PaymentStatusView> createState() => _PaymentStatusViewState();
}

class _PaymentStatusViewState extends State<PaymentStatusView> {
  // Dummy data untuk Pre Order items (SUDAH DITAMBAH DP)
  final List<Map<String, dynamic>> preOrderItems = [
    {
      'title': 'Padi Segar Mayur',
      'quantity': 100,
      'unit': 'kg',
      'price': 100000,
      'status': 'Menunggu Panen',
      'image': 'assets/images/farmer.png',
      'dpPaid': 30000,
    },
    {
      'title': 'Jagung Manis Premium',
      'quantity': 50,
      'unit': 'kg',
      'price': 150000,
      'status': 'Menunggu Panen',
      'image': 'assets/images/farmer.png',
      'dpPaid': 50000,
    },
  ];

  // Dummy data untuk Non Pre Order items
  final List<Map<String, dynamic>> nonPreOrderItems = [
    {
      'title': 'Beras Organik Premium',
      'quantity': 25,
      'unit': 'kg',
      'price': 50000,
      'status': 'Siap Kirim',
      'image': 'assets/images/farmer.png',
    },
    {
      'title': 'Sayuran Segar Mix',
      'quantity': 10,
      'unit': 'pack',
      'price': 75000,
      'status': 'Siap Kirim',
      'image': 'assets/images/farmer.png',
    },
    {
      'title': 'Madu Asli Murni',
      'quantity': 5,
      'unit': 'botol',
      'price': 120000,
      'status': 'Siap Kirim',
      'image': 'assets/images/farmer.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2D9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2D9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A8C2E)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Belum Bayar",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF49511B),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= PRE ORDER =================
              _statusTypeCard(
                icon: Icons.calendar_today,
                title: "Pre Order",
                description: "Pesanan dengan jadwal panen tertentu",
                details: [
                  "Pembayaran dimulai sebelum panen",
                  "Harga dapat berubah sesuai kondisi",
                  "Periode panen yang pasti",
                ],
                items: preOrderItems,
                isPreOrder: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentView(
                        isPreOrder: true,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // ================= NON PRE ORDER =================
              _statusTypeCard(
                icon: Icons.shopping_cart,
                title: "Non Pre Order",
                description: "Pesanan barang yang sudah tersedia",
                details: [
                  "Pembayaran untuk barang siap kirim",
                  "Harga tetap dan jelas",
                  "Pengiriman segera setelah pembayaran",
                ],
                items: nonPreOrderItems,
                isPreOrder: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentView(
                        isPreOrder: false,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // STATUS TYPE CARD
  // =====================================================
  Widget _statusTypeCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> details,
    required List<Map<String, dynamic>> items,
    required bool isPreOrder,
    required VoidCallback onTap,
  }) {
    double totalPrice = items.fold(
      0.0,
      (sum, item) =>
          sum + ((item['price'] as int) * (item['quantity'] as int)).toDouble(),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F2D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF7A8C2E),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF49511B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // DETAILS
            ...details.asMap().entries.map((entry) {
              int index = entry.key;
              String detail = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < details.length - 1 ? 12 : 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7A8C2E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        detail,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF49511B),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 20),

            // DIVIDER
            Container(
              height: 1,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),

            // ITEMS LIST
            const Text(
              "Barang yang Harus Dibayar",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF49511B),
              ),
            ),
            const SizedBox(height: 12),
            ...items.asMap().entries.map((entry) {
              int index = entry.key;
              var item = entry.value;
              return Padding(
                padding:
                    EdgeInsets.only(bottom: index < items.length - 1 ? 12 : 0),
                child: _itemRow(
                  title: item['title'],
                  quantity: item['quantity'],
                  unit: item['unit'],
                  price: item['price'],
                  status: item['status'],
                  isPreOrder: isPreOrder,
                  dpPaid: item['dpPaid'] ?? 0,
                ),
              );
            }).toList(),
            const SizedBox(height: 16),

            // TOTAL PRICE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Harga",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Rp. ${totalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ARROW BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F2D9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF7A8C2E),
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // ITEM ROW (FINAL VERSION + DP + SISA PEMBAYARAN)
  // =====================================================
  Widget _itemRow({
    required String title,
    required int quantity,
    required String unit,
    required int price,
    required String status,
    required bool isPreOrder,
    int dpPaid = 0,
  }) {
    int totalItemPrice = price * quantity;
    Color statusColor = isPreOrder ? Colors.orange : Colors.green;

    int remainingPayment =
        isPreOrder ? (totalItemPrice - dpPaid) : 0; // khusus PO

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2D9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE + LABEL STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF49511B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // QTY × PRICE + TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$quantity $unit × Rp. ${price.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                "Rp. ${totalItemPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // TAMBAHKAN DETAIL KHUSUS PRE ORDER
          if (isPreOrder) ...[
            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sudah Dibayar (DP)",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF49511B),
                  ),
                ),
                Text(
                  "Rp. ${dpPaid.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sisa Pembayaran",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Rp. ${remainingPayment.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}