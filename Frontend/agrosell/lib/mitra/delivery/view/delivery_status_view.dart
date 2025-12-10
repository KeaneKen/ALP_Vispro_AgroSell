import 'package:flutter/material.dart';

class DeliveryStatusView extends StatelessWidget {
  final String? categoryName;
  
  const DeliveryStatusView({super.key, this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Menggunakan categoryName untuk menampilkan produk yang sesuai
    String productName = categoryName ?? "Padi";
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Lacak Delivery - $productName"),
        backgroundColor: const Color(0xFF7A8C2E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal Delivery Timeline
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menuju Alamatmu (Active)
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              border: Border.all(color: Colors.green, width: 2),
                            ),
                            child: const Icon(
                              Icons.directions_bike,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Sedang",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Text(
                            "Dikirim",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Garis penghubung 1
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.grey[300],
                      ),
                    ),
                    
                    // Dikirim
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[400]!, width: 2),
                            ),
                            child: Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Menuju Alamatmu",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Garis penghubung 3
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.grey[300],
                      ),
                    ),
                    
                    // Selesai
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[400]!, width: 2),
                            ),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Selesai",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Divider
              const Divider(thickness: 1),
              
              const SizedBox(height: 16),
              
              // Order Details with Image
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: _getProductImage(productName),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Order Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Barang Pesanan",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        const Text(
                          "Jumlah Pesanan",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getProductQuantity(productName),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        const Text(
                          "Total Harga",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getProductPrice(productName),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Divider
              const Divider(thickness: 1),
              
              const SizedBox(height: 20),
              
              // Order Timeline (Vertical)
              const Text(
                "Rincian Pesanan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              const TimelineItem(
                time: "25 Nov 17:43",
                description: "Pesanan tiba di alamat tujuan.",
                isActive: true,
              ),
              const TimelineItem(
                time: "25 Nov 17:37",
                description: "Pesanan dalam proses pengantaran.",
                isActive: true,
              ),
              const TimelineItem(
                time: "25 Nov 17:19",
                description: "Pesanan telah diserahkan ke jasa kirim untuk diproses.",
                isActive: true,
              ),
              const TimelineItem(
                time: "25 Nov 16:54",
                description: "Kurir ditugaskan untuk menjemput pesanan.",
                isActive: true,
              ),
              const TimelineItem(
                time: "25 Nov 16:50",
                description: "Pengirim telah mengatur pengiriman. Menunggu pesanan diserahkan ke pihak jasa kirim.",
                isActive: true,
              ),
              const TimelineItem(
                time: "25 Nov 16:49",
                description: "Pesanan Dibuat",
                isActive: true,
              ),
              
              const SizedBox(height: 24),
              
              // Address Section
              const Text(
                "Alamat Detail",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wesconde",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Jl Karaeng Loe Sero, No. 55, Tombolo, Kec. Somba Opu, Kebupaten Gowa, Sulawesi Selatan 90233, Indonesia",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function untuk mendapatkan gambar berdasarkan kategori
  AssetImage _getProductImage(String productName) {
    if (productName.toLowerCase().contains('jagung')) {
      return const AssetImage('assets/images/jagung.png');
    } else if (productName.toLowerCase().contains('cabai')) {
      return const AssetImage('assets/images/cabai.png');
    } else if (productName.toLowerCase().contains('padi')) {
      return const AssetImage('assets/images/padi.png');
    } else {
      return const AssetImage('assets/images/farmer.png');
    }
  }

  // Helper function untuk mendapatkan jumlah berdasarkan kategori
  String _getProductQuantity(String productName) {
    if (productName.toLowerCase().contains('jagung')) {
      return "2 Ton";
    } else if (productName.toLowerCase().contains('cabai')) {
      return "500 Kg";
    } else if (productName.toLowerCase().contains('padi')) {
      return "1 Ton";
    } else {
      return "1 Paket";
    }
  }

  // Helper function untuk mendapatkan harga berdasarkan kategori
  String _getProductPrice(String productName) {
    if (productName.toLowerCase().contains('jagung')) {
      return "Rp. 6.000.000";
    } else if (productName.toLowerCase().contains('cabai')) {
      return "Rp. 8.000.000";
    } else if (productName.toLowerCase().contains('padi')) {
      return "Rp. 10.000.000";
    } else {
      return "Rp. 5.000.000";
    }
  }
}

class TimelineItem extends StatelessWidget {
  final String time;
  final String description;
  final bool isActive;
  
  const TimelineItem({
    super.key,
    required this.time,
    required this.description,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.green : Colors.grey[400],
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(vertical: 2),
              ),
            ],
          ),
          
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}