import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/pre_order_model.dart';
import 'detail_po_view.dart';

class ListPOViewModel extends ChangeNotifier {
  List<PreOrderModel> _poList = [];
  bool _isLoading = false;
  String _filterStatus = 'all';

  List<PreOrderModel> get poList => _filteredList;
  bool get isLoading => _isLoading;
  String get filterStatus => _filterStatus;

  List<PreOrderModel> get _filteredList {
    if (_filterStatus == 'all') return _poList;
    return _poList.where((po) => po.status == _filterStatus).toList();
  }

  Future<void> fetchPOList() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _poList = [
      PreOrderModel(
        id: 'PO-001',
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
        ],
      ),
      PreOrderModel(
        id: 'PO-002',
        supplierName: 'Supplier B',
        orderDate: DateTime(2024, 1, 14),
        deliveryDate: DateTime(2024, 1, 24),
        totalAmount: 7500000,
        status: 'pending',
        items: [
          POItem(
            productName: 'Product B',
            quantity: 50,
            price: 150000,
            unit: 'pcs',
          ),
        ],
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }
}

class ListPOView extends StatefulWidget {
  const ListPOView({super.key});

  @override
  State<ListPOView> createState() => _ListPOViewState();
}

class _ListPOViewState extends State<ListPOView> {
  final ListPOViewModel _viewModel = ListPOViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchPOList();
    });
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Purchase Order'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah',
            onPressed: () {
              Navigator.pushNamed(context, '/po-form');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildPOList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _viewModel.filterStatus,
              decoration: InputDecoration(
                labelText: 'Filter Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Semua')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'approved', child: Text('Approved')),
                DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
              ],
              onChanged: (value) {
                _viewModel.setFilterStatus(value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPOList() {
    if (_viewModel.poList.isEmpty) {
      return const Center(child: Text('Tidak ada data PO'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _viewModel.poList.length,
      itemBuilder: (context, index) {
        final po = _viewModel.poList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Image.network(
                  _getCategoryThumbUrl(po),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(po.supplierName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${po.id}'),
                Text('Total: Rp ${po.totalAmount.toStringAsFixed(0)}'),
                Text('Status: ${po.status}'),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary, // FIX
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailPOView(poId: po.id)),
              );
            },
          ),
        );
      },
    );
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

  String _getCategoryThumbUrl(PreOrderModel po) {
    // Gunakan supplierName dulu (bisa berisi nama komoditas), lalu item pertama
    final fromSupplier = po.supplierName.toLowerCase().trim();
    final fromItem = po.items.isNotEmpty
        ? po.items.first.productName.toLowerCase().trim()
        : '';
    final name = fromSupplier.isNotEmpty ? fromSupplier : fromItem;
    if (name.contains('jagung') || name.contains('corn')) {
      return 'https://images.unsplash.com/photo-1604335399105-1f91c5b1d9f8?q=80&w=200&auto=format&fit=crop';
    }
    if (name.contains('cabai') ||
        name.contains('chili') ||
        name.contains('cabe')) {
      return 'https://www.shutterstock.com/shutterstock/photos/2556563607/display_1500/stock-photo-bird-s-eye-chili-or-thai-chili-background-texture-top-view-bird-s-eye-chili-in-supermarket-photo-2556563607.jpg';
    }
    if (name.contains('padi') || name.contains('rice')) {
      return 'https://images.unsplash.com/photo-1504274066651-8d31a536b11e?q=80&w=200&auto=format&fit=crop';
    }
    return 'https://picsum.photos/200';
  }
}
