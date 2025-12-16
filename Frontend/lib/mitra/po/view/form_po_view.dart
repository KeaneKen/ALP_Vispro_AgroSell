import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/pre_order_model.dart';

class FormPOViewModel extends ChangeNotifier {
  final List<POItem> _items = [];
  String supplierName = '';
  String phoneNumber = '';
  String address = '';
  DateTime orderDate = DateTime.now();
  DateTime deliveryDate = DateTime.now().add(const Duration(days: 7));
  bool isLoading = false;

  List<POItem> get items => _items;

  void setSupplierName(String value) {
    supplierName = value;
    notifyListeners();
  }

  void setPhone(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  void setAddress(String value) {
    address = value;
    notifyListeners();
  }

  void setOrderDate(DateTime date) {
    orderDate = date;
    notifyListeners();
  }

  void setDeliveryDate(DateTime date) {
    deliveryDate = date;
    notifyListeners();
  }

  void addItem(POItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  Future<bool> submitPO() async {
    if (supplierName.isEmpty || phoneNumber.isEmpty || address.isEmpty || _items.isEmpty) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    notifyListeners();
    return true;
  }
}

class FormPOView extends StatefulWidget {
  final PreOrderModel? poToEdit;

  const FormPOView({super.key, this.poToEdit});

  @override
  State<FormPOView> createState() => _FormPOViewState();
}

class _FormPOViewState extends State<FormPOView> {
  final FormPOViewModel _viewModel = FormPOViewModel();
  final _formKey = GlobalKey<FormState>();

  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() => setState(() {}));

    if (widget.poToEdit != null) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    final po = widget.poToEdit!;
    _viewModel.supplierName = po.supplierName;
    _viewModel.orderDate = po.orderDate;
    _viewModel.deliveryDate = po.deliveryDate;

    for (var item in po.items) {
      _viewModel.addItem(item);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _productNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Satuan'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final item = POItem(
                  productName: _productNameController.text,
                  quantity: int.parse(_quantityController.text),
                  price: double.parse(_priceController.text),
                  unit: _unitController.text,
                );
                _viewModel.addItem(item);
                _clearItemFields();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tambah ke Daftar'),
            ),
          ],
        );
      },
    );
  }

  void _clearItemFields() {
    _productNameController.clear();
    _quantityController.clear();
    _priceController.clear();
    _unitController.clear();
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sukses!"),
        content: const Text("Pre-Order berhasil disimpan 🎉"),
        actions: [
          TextButton(
            onPressed: () {
              // Close the success dialog
              Navigator.pop(context);
              // Close the parent PO dialog and return `true` so the caller can refresh
              Navigator.pop(context, true);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _showWarningPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Peringatan"),
        content: const Text("Harap isi semua kolom dan tambah minimal satu item."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BACK BUTTON + TITLE
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.poToEdit == null ? 'Buat PO Baru' : 'Edit PO',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // FORM INPUTS
                TextFormField(
                  initialValue: _viewModel.supplierName,
                  decoration: InputDecoration(
                    labelText: 'Nama Mitra',
                    prefixIcon: Icon(Icons.store, color: AppColors.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: _viewModel.setSupplierName,
                  validator: (value) =>
                      value!.isEmpty ? 'Masukkan nama mitra' : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: _viewModel.setPhone,
                  validator: (value) =>
                      value!.isEmpty ? 'Masukkan nomor telepon' : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Alamat Tujuan',
                    prefixIcon:
                        Icon(Icons.location_on, color: AppColors.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: _viewModel.setAddress,
                  validator: (value) =>
                      value!.isEmpty ? 'Masukkan alamat tujuan' : null,
                ),

                const SizedBox(height: 20),

                // DATE PICKERS
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Pesan'),
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _viewModel.orderDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                _viewModel.setOrderDate(date);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(_formatDate(_viewModel.orderDate)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Kirim'),
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _viewModel.deliveryDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                _viewModel.setDeliveryDate(date);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(_formatDate(_viewModel.deliveryDate)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ITEMS LIST
                _buildItemList(),

                const SizedBox(height: 20),

                // SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _viewModel.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate() ||
                                _viewModel.items.isEmpty) {
                              _showWarningPopup();
                              return;
                            }

                            final success = await _viewModel.submitPO();
                            if (success) _showSuccessPopup();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.save),
                    label: _viewModel.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Submit PO'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemList() {
    if (_viewModel.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _viewModel.items.length,
      itemBuilder: (context, index) {
        final item = _viewModel.items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(item.productName),
            subtitle: Text(
              '${item.quantity} ${item.unit} @ Rp ${item.price.toStringAsFixed(0)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rp ${(item.price * item.quantity).toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _viewModel.removeItem(index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
