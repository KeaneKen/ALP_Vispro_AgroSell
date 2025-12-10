import 'package:agrosell/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// Model untuk data bank
class Bank {
  final String name;
  final String code;
  final String iconPath;
  final String accountNumber;
  final String accountName;

  Bank({
    required this.name,
    required this.code,
    required this.iconPath,
    required this.accountNumber,
    required this.accountName,
  });
}

// Model untuk data e-wallet
class EWallet {
  final String name;
  final String code;
  final String iconPath;
  final String phoneNumber;
  final String accountName;

  EWallet({
    required this.name,
    required this.code,
    required this.iconPath,
    required this.phoneNumber,
    required this.accountName,
  });
}

// Model untuk data cicilan
class Installment {
  final String name;
  final String code;
  final String iconPath;
  final List<String> tenors;
  final String interestRate;

  Installment({
    required this.name,
    required this.code,
    required this.iconPath,
    required this.tenors,
    required this.interestRate,
  });
}

class PaymentView extends StatefulWidget {
  final bool isPreOrder;
  final String? categoryName;

  const PaymentView({super.key, this.isPreOrder = false, this.categoryName});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String? _selectedPaymentMethod;
  Bank? _selectedBank;
  EWallet? _selectedEWallet;
  Installment? _selectedInstallment;
  String? _selectedTenor;
  bool _isPaying = false;
  
  // Daftar metode pembayaran
  final List<Map<String, String>> _paymentMethods = [
    {'method': 'Bank Transfer', 'details': 'BCA, Mandiri, BRI'},
    {'method': 'E-Wallet', 'details': 'GoPay, OVO, Dana'},
    {'method': 'Cicilan', 'details': 'Tenor 3, 6, 12 bulan'},
  ];

  // Daftar bank untuk transfer
  final List<Bank> _banks = [
    Bank(
      name: 'BCA',
      code: '014',
      iconPath: 'assets/images/bca.png',
      accountNumber: '1234567890',
      accountName: 'AGROSELL INDONESIA',
    ),
    Bank(
      name: 'Mandiri',
      code: '008',
      iconPath: 'assets/images/mandiri.png',
      accountNumber: '0987654321',
      accountName: 'AGROSELL INDONESIA',
    ),
    Bank(
      name: 'BRI',
      code: '002',
      iconPath: 'assets/images/bri.png',
      accountNumber: '1122334455',
      accountName: 'AGROSELL INDONESIA',
    ),
    Bank(
      name: 'BNI',
      code: '009',
      iconPath: 'assets/images/bni.png',
      accountNumber: '5566778899',
      accountName: 'AGROSELL INDONESIA',
    ),
  ];

  // Daftar e-wallet
  final List<EWallet> _eWallets = [
    EWallet(
      name: 'GoPay',
      code: 'GOPAY',
      iconPath: 'assets/images/gopay.png',
      phoneNumber: '081234567890',
      accountName: 'AGROSELL INDONESIA',
    ),
    EWallet(
      name: 'OVO',
      code: 'OVO',
      iconPath: 'assets/images/ovo.png',
      phoneNumber: '081234567891',
      accountName: 'AGROSELL INDONESIA',
    ),
    EWallet(
      name: 'Dana',
      code: 'DANA',
      iconPath: 'assets/images/dana.png',
      phoneNumber: '081234567892',
      accountName: 'AGROSELL INDONESIA',
    ),
    EWallet(
      name: 'ShopeePay',
      code: 'SHOPEEPAY',
      iconPath: 'assets/images/shopeepay.png',
      phoneNumber: '081234567893',
      accountName: 'AGROSELL INDONESIA',
    ),
  ];

  // Daftar cicilan
  final List<Installment> _installments = [
    Installment(
      name: 'Kredivo',
      code: 'KREDIVO',
      iconPath: 'assets/images/kredivo.png',
      tenors: ['3 Bulan', '6 Bulan', '12 Bulan'],
      interestRate: '0%',
    ),
    Installment(
      name: 'Akulaku',
      code: 'AKULAKU',
      iconPath: 'assets/images/akulaku.png',
      tenors: ['3 Bulan', '6 Bulan', '12 Bulan'],
      interestRate: '1.5%',
    ),
    Installment(
      name: 'Indodana',
      code: 'INDODANA',
      iconPath: 'assets/images/indodana.png',
      tenors: ['3 Bulan', '6 Bulan'],
      interestRate: '2%',
    ),
  ];

  Widget _buildDynamicPaymentItemCard() {
    final name = (widget.categoryName ?? '').toLowerCase();
    if (name.contains('cabai') ||
        name.contains('chili') ||
        name.contains('cabe')) {
      return _paymentItemCard(
        imagePath: "assets/images/cabai.png",
        title: itemTitle,
        price: itemPrice,
      );
    } else if (name.contains('padi') || name.contains('rice')) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: const Text(
                'Cabai',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49511B),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF49511B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    itemPrice,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7A8C2E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return _paymentItemCard(
        imagePath: "assets/images/farmer.png",
        title: itemTitle,
        price: itemPrice,
      );
    }
  }

  late String pageTitle;
  late String itemTitle;
  late String itemPrice;

  @override
  void initState() {
    super.initState();
    if (widget.isPreOrder) {
      pageTitle = "Status Pembayaran Pre Order";
      itemTitle = "Padi Segar";
      itemPrice = "Rp. 5.000.000";
    } else {
      pageTitle = _getPaymentLabel(widget.categoryName);
      final name = (widget.categoryName ?? '').toLowerCase();
      if (name.contains('jagung') || name.contains('corn')) {
        itemTitle = "Jagung Premium";
        itemPrice = "Rp. 3.000.000";
      } else if (name.contains('cabai') ||
          name.contains('chili') ||
          name.contains('cabe')) {
        itemTitle = "Cabai Merah";
        itemPrice = "Rp. 8.000.000";
      } else if (name.contains('padi') || name.contains('rice')) {
        itemTitle = "Beras Organik Premium";
        itemPrice = "Rp. 5.000.000";
      } else {
        itemTitle = "Produk Pertanian";
        itemPrice = "Rp. 1.000.000";
      }
    }
  }

  // Fungsi helper label dinamis
  String _getPaymentLabel(String? category) {
    final name = (category ?? '').toLowerCase();
    if (name.contains('jagung') || name.contains('corn')) {
      return 'Status Pembayaran Jagung';
    }
    if (name.contains('cabai') ||
        name.contains('chili') ||
        name.contains('cabe')) {
      return 'Status Pembayaran Cabai';
    }
    if (name.contains('padi') || name.contains('rice')) {
      return 'Status Pembayaran Padi';
    }
    return 'Status Pembayaran';
  }

  // Fungsi untuk menangani pembayaran
  void _handlePayment() {
    if (_selectedPaymentMethod == null) {
      _showPaymentMethodWarning();
      return;
    }

    // Validasi berdasarkan metode pembayaran
    switch (_selectedPaymentMethod) {
      case 'Bank Transfer':
        if (_selectedBank == null) {
          _showSelectionWarning('Silakan pilih bank terlebih dahulu untuk metode Bank Transfer.');
          return;
        }
        break;
      case 'E-Wallet':
        if (_selectedEWallet == null) {
          _showSelectionWarning('Silakan pilih e-wallet terlebih dahulu untuk metode E-Wallet.');
          return;
        }
        break;
      case 'Cicilan':
        if (_selectedInstallment == null) {
          _showSelectionWarning('Silakan pilih penyedia cicilan terlebih dahulu.');
          return;
        }
        if (_selectedTenor == null) {
          _showSelectionWarning('Silakan pilih tenor cicilan terlebih dahulu.');
          return;
        }
        break;
    }

    setState(() {
      _isPaying = true;
    });

    // Simulasi proses pembayaran
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isPaying = false;
      });
      _showPaymentSuccessDialog();
    });
  }

  // Fungsi untuk menampilkan bottom sheet pilihan
  void _showSelectionBottomSheet(String type) {
    switch (type) {
      case 'bank':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => BankSelectionBottomSheet(
            banks: _banks,
            onBankSelected: (bank) {
              setState(() {
                _selectedBank = bank;
                _selectedEWallet = null;
                _selectedInstallment = null;
                _selectedTenor = null;
              });
              Navigator.pop(context);
            },
          ),
        );
        break;
      case 'ewallet':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => EWalletSelectionBottomSheet(
            eWallets: _eWallets,
            onEWalletSelected: (eWallet) {
              setState(() {
                _selectedEWallet = eWallet;
                _selectedBank = null;
                _selectedInstallment = null;
                _selectedTenor = null;
              });
              Navigator.pop(context);
            },
          ),
        );
        break;
      case 'installment':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => InstallmentSelectionBottomSheet(
            installments: _installments,
            onInstallmentSelected: (installment) {
              setState(() {
                _selectedInstallment = installment;
                _selectedBank = null;
                _selectedEWallet = null;
                _selectedTenor = null;
              });
              Navigator.pop(context);
            },
          ),
        );
        break;
    }
  }

  // Fungsi untuk menampilkan halaman instruksi
  void _showPaymentInstructions() {
    if (_selectedPaymentMethod == 'Bank Transfer' && _selectedBank != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BankPaymentInstructionsPage(
            bank: _selectedBank!,
            totalAmount: widget.isPreOrder
                ? "Rp. 10.000.170.000"
                : "Rp. 5.000.060.000",
          ),
        ),
      ).then((value) {
        if (value == true) {
          _handlePayment();
        }
      });
    } else if (_selectedPaymentMethod == 'E-Wallet' && _selectedEWallet != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EWalletPaymentInstructionsPage(
            eWallet: _selectedEWallet!,
            totalAmount: widget.isPreOrder
                ? "Rp. 10.000.170.000"
                : "Rp. 5.000.060.000",
          ),
        ),
      ).then((value) {
        if (value == true) {
          _handlePayment();
        }
      });
    } else if (_selectedPaymentMethod == 'Cicilan' && _selectedInstallment != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InstallmentPaymentInstructionsPage(
            installment: _selectedInstallment!,
            selectedTenor: _selectedTenor!,
            totalAmount: widget.isPreOrder
                ? "Rp. 10.000.170.000"
                : "Rp. 5.000.060.000",
          ),
        ),
      ).then((value) {
        if (value == true) {
          _handlePayment();
        }
      });
    }
  }

  // Fungsi untuk menampilkan peringatan pilih metode pembayaran
  void _showPaymentMethodWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Metode Pembayaran'),
        content: const Text('Silakan pilih metode pembayaran terlebih dahulu sebelum melanjutkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan peringatan pilihan
  void _showSelectionWarning(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Opsi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog pembayaran sukses
  void _showPaymentSuccessDialog() {
    String paymentMethodText = '';
    
    switch (_selectedPaymentMethod) {
      case 'Bank Transfer':
        paymentMethodText = 'Pembayaran via ${_selectedBank!.name} berhasil!';
        break;
      case 'E-Wallet':
        paymentMethodText = 'Pembayaran menggunakan ${_selectedEWallet!.name} berhasil!';
        break;
      case 'Cicilan':
        paymentMethodText = 'Pembayaran cicilan via ${_selectedInstallment!.name} ($_selectedTenor) berhasil!';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pembayaran Sukses!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text(
              paymentMethodText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${widget.isPreOrder ? "Rp. 10.000.170.000" : "Rp. 5.000.060.000"}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A8C2E),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan card yang dipilih
  Widget _buildSelectedPaymentCard() {
    if (_selectedPaymentMethod == 'Bank Transfer' && _selectedBank != null) {
      return _buildSelectedBankCard();
    } else if (_selectedPaymentMethod == 'E-Wallet' && _selectedEWallet != null) {
      return _buildSelectedEWalletCard();
    } else if (_selectedPaymentMethod == 'Cicilan' && _selectedInstallment != null) {
      return _buildSelectedInstallmentCard();
    }
    return const SizedBox();
  }

  // Fungsi untuk menampilkan card bank yang dipilih
  Widget _buildSelectedBankCard() {
    if (_selectedBank == null) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF7A8C2E), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bank yang Dipilih:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      setState(() {
                        _selectedBank = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A8C2E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _selectedBank!.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A8C2E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedBank!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF49511B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kode: ${_selectedBank!.code}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Color(0xFF7A8C2E)),
                    onPressed: _showPaymentInstructions,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menampilkan card e-wallet yang dipilih
  Widget _buildSelectedEWalletCard() {
    if (_selectedEWallet == null) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF7A8C2E), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'E-Wallet yang Dipilih:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      setState(() {
                        _selectedEWallet = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A8C2E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _selectedEWallet!.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A8C2E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedEWallet!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF49511B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kode: ${_selectedEWallet!.code}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Color(0xFF7A8C2E)),
                    onPressed: _showPaymentInstructions,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menampilkan card cicilan yang dipilih
  Widget _buildSelectedInstallmentCard() {
    if (_selectedInstallment == null) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF7A8C2E), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cicilan yang Dipilih:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      setState(() {
                        _selectedInstallment = null;
                        _selectedTenor = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A8C2E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _selectedInstallment!.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A8C2E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedInstallment!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF49511B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kode: ${_selectedInstallment!.code}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Color(0xFF7A8C2E)),
                    onPressed: _showPaymentInstructions,
                  ),
                ],
              ),
              if (_selectedTenor != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A8C2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Tenor: $_selectedTenor',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7A8C2E),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Tenor Selection
        if (_selectedInstallment != null && _selectedTenor == null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Tenor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF49511B),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedInstallment!.tenors.map((tenor) {
                    return ChoiceChip(
                      label: Text(tenor),
                      selected: _selectedTenor == tenor,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTenor = selected ? tenor : null;
                        });
                      },
                      selectedColor: const Color(0xFF7A8C2E),
                      labelStyle: TextStyle(
                        color: _selectedTenor == tenor ? Colors.white : const Color(0xFF49511B),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2D9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A8C2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              pageTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= BADGE =================
              if (widget.isPreOrder)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A8C2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Pre Order",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A8C2E),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Siap Kirim",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // ================= PAYMENT ITEM CARD =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        (widget.categoryName ?? '').toLowerCase().contains('cabai') ||
                            (widget.categoryName ?? '').toLowerCase().contains('chili') ||
                            (widget.categoryName ?? '').toLowerCase().contains('cabe')
                            ? "assets/images/cabai.png"
                            : "assets/images/farmer.png",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF49511B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            itemPrice,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7A8C2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ================= DETAIL PESANAN =================
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail Pesanan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF49511B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.isPreOrder) ...[
                      _detailRow("Subtotal Pre Order", itemPrice),
                      const SizedBox(height: 12),
                      _detailRow("Biaya Admin", "Rp. 50.000"),
                      const SizedBox(height: 12),
                      _detailRow("Biaya Reservasi", "Rp. 100.000"),
                      const SizedBox(height: 12),
                      _detailRow("Ongkir Estimasi", "Rp. 20.000"),
                    ] else ...[
                      _detailRow("Subtotal", itemPrice),
                      const SizedBox(height: 12),
                      _detailRow("Biaya Admin", "Rp. 50.000"),
                      const SizedBox(height: 12),
                      _detailRow("Ongkir", "Rp. 10.000"),
                    ],
                    const SizedBox(height: 20),
                    Container(height: 1, color: Colors.grey[300]),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF49511B),
                          ),
                        ),
                        Text(
                          widget.isPreOrder
                              ? "Rp. 10.000.170.000"
                              : "Rp. 5.000.060.000",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A8C2E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ================= PAYMENT METHOD =================
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pilih Metode Pembayaran",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF49511B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._paymentMethods.map((method) {
                      final isSelected = _selectedPaymentMethod == method['method'];
                      return Column(
                        children: [
                          _paymentMethodCard(
                            method: method['method']!,
                            details: method['details']!,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedPaymentMethod = method['method'];
                                // Reset selection jika bukan metode yang dipilih
                                if (method['method'] != 'Bank Transfer') {
                                  _selectedBank = null;
                                }
                                if (method['method'] != 'E-Wallet') {
                                  _selectedEWallet = null;
                                }
                                if (method['method'] != 'Cicilan') {
                                  _selectedInstallment = null;
                                  _selectedTenor = null;
                                }
                              });
                            },
                          ),
                          if (method != _paymentMethods.last)
                            const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),

                    // Tombol pilih berdasarkan metode yang dipilih
                    if (_selectedPaymentMethod != null) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                switch (_selectedPaymentMethod) {
                                  case 'Bank Transfer':
                                    _showSelectionBottomSheet('bank');
                                    break;
                                  case 'E-Wallet':
                                    _showSelectionBottomSheet('ewallet');
                                    break;
                                  case 'Cicilan':
                                    _showSelectionBottomSheet('installment');
                                    break;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7A8C2E),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(
                                _selectedPaymentMethod == 'Bank Transfer'
                                    ? Icons.account_balance
                                    : _selectedPaymentMethod == 'E-Wallet'
                                      ? Icons.wallet
                                      : Icons.credit_card,
                                size: 20,
                              ),
                              label: Text(
                                _selectedPaymentMethod == 'Bank Transfer'
                                    ? (_selectedBank == null ? 'Pilih Bank' : 'Ubah Bank')
                                    : _selectedPaymentMethod == 'E-Wallet'
                                      ? (_selectedEWallet == null ? 'Pilih E-Wallet' : 'Ubah E-Wallet')
                                      : (_selectedInstallment == null ? 'Pilih Cicilan' : 'Ubah Cicilan'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Tampilkan card yang sudah dipilih
              _buildSelectedPaymentCard(),

              const SizedBox(height: 40),

              // ================= BAYAR BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isPaying ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A8C2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isPaying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _getPayButtonText(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getPayButtonText() {
    if (_selectedPaymentMethod == 'Bank Transfer' && _selectedBank != null) {
      return 'Bayar via ${_selectedBank!.name}';
    } else if (_selectedPaymentMethod == 'E-Wallet' && _selectedEWallet != null) {
      return 'Bayar via ${_selectedEWallet!.name}';
    } else if (_selectedPaymentMethod == 'Cicilan' && _selectedInstallment != null && _selectedTenor != null) {
      return 'Bayar Cicilan via ${_selectedInstallment!.name}';
    }
    return "Bayar Sekarang";
  }

  // =====================================================
  // PAYMENT ITEM CARD
  // =====================================================
  Widget _paymentItemCard({
    required String imagePath,
    required String title,
    required String price,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 40, backgroundImage: AssetImage(imagePath)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF49511B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A8C2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // DETAIL ROW
  // =====================================================
  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF49511B),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // PAYMENT METHOD CARD
  // =====================================================
  Widget _paymentMethodCard({
    required String method,
    required String details,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF7A8C2E) : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF7A8C2E) : const Color(0xFFBDBDBD),
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF7A8C2E) : const Color(0xFF49511B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF7A8C2E),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// BOTTOM SHEET UNTUK MEMILIH BANK
// =====================================================
class BankSelectionBottomSheet extends StatelessWidget {
  final List<Bank> banks;
  final Function(Bank) onBankSelected;

  const BankSelectionBottomSheet({
    super.key,
    required this.banks,
    required this.onBankSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Bank',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF49511B),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF49511B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: banks.length,
              itemBuilder: (context, index) {
                final bank = banks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () {
                      onBankSelected(bank);
                    },
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A8C2E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          bank.name.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A8C2E),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      bank.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF49511B),
                      ),
                    ),
                    subtitle: Text(
                      'Kode: ${bank.code}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF7A8C2E),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// BOTTOM SHEET UNTUK MEMILIH E-WALLET
// =====================================================
class EWalletSelectionBottomSheet extends StatelessWidget {
  final List<EWallet> eWallets;
  final Function(EWallet) onEWalletSelected;

  const EWalletSelectionBottomSheet({
    super.key,
    required this.eWallets,
    required this.onEWalletSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih E-Wallet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF49511B),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF49511B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: eWallets.length,
              itemBuilder: (context, index) {
                final eWallet = eWallets[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () {
                      onEWalletSelected(eWallet);
                    },
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A8C2E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          eWallet.name.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A8C2E),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      eWallet.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF49511B),
                      ),
                    ),
                    subtitle: Text(
                      'Kode: ${eWallet.code}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF7A8C2E),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// BOTTOM SHEET UNTUK MEMILIH CICILAN
// =====================================================
class InstallmentSelectionBottomSheet extends StatelessWidget {
  final List<Installment> installments;
  final Function(Installment) onInstallmentSelected;

  const InstallmentSelectionBottomSheet({
    super.key,
    required this.installments,
    required this.onInstallmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Cicilan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF49511B),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF49511B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: installments.length,
              itemBuilder: (context, index) {
                final installment = installments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () {
                      onInstallmentSelected(installment);
                    },
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A8C2E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          installment.name.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A8C2E),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      installment.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF49511B),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kode: ${installment.code}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tenor: ${installment.tenors.join(', ')}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF7A8C2E),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// HALAMAN INSTRUKSI PEMBAYARAN BANK
// =====================================================
class BankPaymentInstructionsPage extends StatelessWidget {
  final Bank bank;
  final String totalAmount;

  const BankPaymentInstructionsPage({
    super.key,
    required this.bank,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A8C2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              'Instruksi ${bank.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Bank Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A8C2E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        bank.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A8C2E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    bank.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF49511B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kode Bank: ${bank.code}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Informasi Rekening
            const Text(
              'Informasi Rekening Tujuan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF49511B),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  _infoRow('Nomor Rekening', bank.accountNumber),
                  const SizedBox(height: 12),
                  _infoRow('Nama Pemilik', bank.accountName),
                  const SizedBox(height: 12),
                  _infoRow('Jumlah Transfer', totalAmount),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Instruksi Transfer
            const Text(
              'Instruksi Transfer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF49511B),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _instructionStep(1, 'Buka aplikasi atau website ${bank.name}'),
                  const SizedBox(height: 12),
                  _instructionStep(2, 'Masuk ke menu Transfer'),
                  const SizedBox(height: 12),
                  _instructionStep(3, 'Masukkan nomor rekening tujuan di atas'),
                  const SizedBox(height: 12),
                  _instructionStep(4, 'Masukkan jumlah transfer sesuai total'),
                  const SizedBox(height: 12),
                  _instructionStep(5, 'Konfirmasi dan selesaikan transfer'),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Catatan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7A8C2E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF7A8C2E)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pastikan transfer sesuai dengan jumlah total. Pembayaran akan diproses dalam 1x24 jam setelah transfer berhasil.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF49511B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A8C2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Saya Sudah Transfer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF49511B),
          ),
        ),
      ],
    );
  }

  Widget _instructionStep(int step, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF7A8C2E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            instruction,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF49511B),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================
// HALAMAN INSTRUKSI PEMBAYARAN E-WALLET
// =====================================================
class EWalletPaymentInstructionsPage extends StatelessWidget {
  final EWallet eWallet;
  final String totalAmount;

  const EWalletPaymentInstructionsPage({
    super.key,
    required this.eWallet,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A8C2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              'Instruksi ${eWallet.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card E-Wallet Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A8C2E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        eWallet.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A8C2E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    eWallet.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF49511B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kode: ${eWallet.code}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Informasi Pembayaran
            const Text(
              'Informasi Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF49511B),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  _infoRow('Nomor Tujuan', eWallet.phoneNumber),
                  const SizedBox(height: 12),
                  _infoRow('Nama Pemilik', eWallet.accountName),
                  const SizedBox(height: 12),
                  _infoRow('Jumlah Transfer', totalAmount),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Instruksi Pembayaran
            const Text(
              'Instruksi Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF49511B),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _instructionStep(1, 'Buka aplikasi ${eWallet.name} di smartphone Anda'),
                  const SizedBox(height: 12),
                  _instructionStep(2, 'Masuk ke menu Transfer atau Bayar'),
                  const SizedBox(height: 12),
                  _instructionStep(3, 'Masukkan nomor tujuan di atas'),
                  const SizedBox(height: 12),
                  _instructionStep(4, 'Masukkan jumlah transfer sesuai total'),
                  const SizedBox(height: 12),
                  _instructionStep(5, 'Konfirmasi dan selesaikan pembayaran'),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Catatan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7A8C2E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF7A8C2E)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pastikan saldo e-wallet mencukupi. Pembayaran akan diproses segera setelah pembayaran berhasil.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF49511B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A8C2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Saya Sudah Bayar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF49511B),
          ),
        ),
      ],
    );
  }

  Widget _instructionStep(int step, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF7A8C2E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            instruction,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF49511B),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================
// HALAMAN INSTRUKSI PEMBAYARAN CICILAN
// =====================================================
class InstallmentPaymentInstructionsPage extends StatelessWidget {
  final Installment installment;
  final String selectedTenor;
  final String totalAmount;

  const InstallmentPaymentInstructionsPage({
    super.key,
    required this.installment,
    required this.selectedTenor,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung cicilan per bulan
    double total = double.parse(totalAmount.replaceAll('Rp. ', '').replaceAll('.', '').replaceAll(',', ''));
    int months = int.parse(selectedTenor.split(' ')[0]);
    double monthlyPayment = total / months;
    
    String formattedMonthly = 'Rp. ${monthlyPayment.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A8C2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              'Instruksi ${installment.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Installment Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A8C2E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        installment.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A8C2E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    installment.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF49511B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kode: ${installment.code}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Detail Cicilan
            const Text(
              'Detail Cicilan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF49511B),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  _infoRow('Total Pembelian', totalAmount),
                  const SizedBox(height: 12),
                  _infoRow('Tenor', selectedTenor),
                  const SizedBox(height: 12),
                  _infoRow('Suku Bunga', installment.interestRate),
                  const SizedBox(height: 12),
                  _infoRow('Cicilan per Bulan', formattedMonthly),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Instruksi Pengajuan
            const Text(
              'Instruksi Pengajuan Cicilan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF49511B),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _instructionStep(1, 'Buka aplikasi ${installment.name} di smartphone Anda'),
                  const SizedBox(height: 12),
                  _instructionStep(2, 'Masuk ke menu Belanja Cicilan atau Kredit'),
                  const SizedBox(height: 12),
                  _instructionStep(3, 'Pilih produk yang ingin dibeli secara cicilan'),
                  const SizedBox(height: 12),
                  _instructionStep(4, 'Pilih tenor $selectedTenor sesuai pilihan Anda'),
                  const SizedBox(height: 12),
                  _instructionStep(5, 'Ikuti proses verifikasi dan pengajuan kredit'),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Catatan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7A8C2E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF7A8C2E)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pengajuan cicilan akan diverifikasi dalam 1-2 jam kerja. Pastikan data diri Anda lengkap dan valid.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF49511B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A8C2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Ajukan Cicilan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF49511B),
          ),
        ),
      ],
    );
  }

  Widget _instructionStep(int step, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF7A8C2E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            instruction,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF49511B),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}