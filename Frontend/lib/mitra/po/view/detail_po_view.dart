import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/pre_order_model.dart';

class DetailPOView extends StatefulWidget {
  final String? poId;

  const DetailPOView({super.key, this.poId});

  @override
  State<DetailPOView> createState() => _DetailPOViewState();
}

class _DetailPOViewState extends State<DetailPOView> {
  PreOrderModel? _poDetail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPODetail();
  }

  Future<void> _fetchPODetail() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _poDetail = PreOrderModel(
        id: widget.poId ?? 'PO-UNDEFINED',
        supplierName: 'Supplier A',
        orderDate: DateTime(2024, 1, 15),
        deliveryDate: DateTime(2024, 1, 25),
        totalAmount: 5000000,
        status: 'approved',
        items: [
          POItem(
            productName: 'Product A',
            quantity: 100,
            price: 20000,
            unit: 'pcs',
          ),
          POItem(
            productName: 'Product B',
            quantity: 50,
            price: 60000,
            unit: 'pcs',
          ),
          POItem(
            productName: 'Product C',
            quantity: 75,
            price: 35000,
            unit: 'pcs',
          ),
        ],
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft, // Rata kiri
          child: Padding(
            padding: const EdgeInsets.only(left: 0), // Tidak ada padding kiri
            child: Text(
              'Detail Pre-Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [],
        // Menghapus centerTitle agar title rata kiri
        centerTitle: false,
        // Menambahkan padding di title untuk jarak dari leading
        titleSpacing: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _poDetail == null
              ? const Center(child: Text('Data tidak ditemukan'))
              : _buildDetailContent(),
    );
  }

  Widget _buildDetailContent() {
    final po = _poDetail!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRowWithWhiteBackground('ID PO', po.id),
                  _buildDetailRowWithWhiteBackground('Supplier', po.supplierName),
                  _buildDetailRowWithWhiteBackground(
                    'Tanggal Pesan',
                    _formatDate(po.orderDate),
                  ),
                  _buildDetailRowWithWhiteBackground(
                    'Tanggal Kirim',
                    _formatDate(po.deliveryDate),
                  ),
                  _buildDetailRowWithWhiteBackground(
                    'Total',
                    'Rp ${po.totalAmount.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.border.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Panen',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRowWithWhiteBackground(
                          'Jadwal Panen',
                          _getHarvestSchedule(),
                        ),
                        _buildDetailRowWithWhiteBackground(
                          'Kondisi Panen',
                          _getHarvestCondition(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithWhiteBackground(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getHarvestSchedule() {
    final po = _poDetail!;
    final estimate = po.deliveryDate.subtract(const Duration(days: 2));
    return '${estimate.day}/${estimate.month}/${estimate.year} (Estimasi)';
  }

  String _getHarvestCondition() {
    final status = _poDetail!.status;
    if (status == 'approved') return 'Siap panen dalam beberapa hari';
    if (status == 'pending') return 'Dalam persiapan, monitoring cuaca';
    if (status == 'rejected') return 'Tertunda, menunggu konfirmasi ulang';
    return 'Normal';
  }
}