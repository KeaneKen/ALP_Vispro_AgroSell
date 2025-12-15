import 'package:flutter/material.dart';

class OrderStatusTimeline extends StatelessWidget {
  final String status;
  final Function(String)? onStatusChange; // For BumDES to change status
  final Function()? onConfirmDelivery; // For Mitra to confirm
  final bool isMitra; // Is current user Mitra?
  final bool isBumdes; // Is current user BumDES?

  const OrderStatusTimeline({
    Key? key,
    required this.status,
    this.onStatusChange,
    this.onConfirmDelivery,
    this.isMitra = false,
    this.isBumdes = false,
  }) : super(key: key);

  // Status order and labels
  static const List<String> _statusOrder = [
    'processing',
    'given_to_courier',
    'on_the_way',
    'arrived',
    'completed'
  ];

  static const Map<String, String> _statusLabels = {
    'processing': 'Sedang Diproses',
    'given_to_courier': 'Diberikan ke Kurir',
    'on_the_way': 'Dalam Perjalanan',
    'arrived': 'Sampai Tujuan',
    'completed': 'Pesanan Selesai',
  };

  int _getStatusIndex() {
    return _statusOrder.indexOf(status);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getStatusIndex();

    return Column(
      children: [
        // Timeline visualization
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status Pesanan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildTimeline(currentIndex),
            ],
          ),
        ),
        // Status details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusLabels[status] ?? status,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(),
                        ),
                  ),
                  const SizedBox(height: 8),
                  _getStatusDescription(),
                  const SizedBox(height: 16),
                  // Action buttons
                  if (isBumdes && currentIndex < _statusOrder.length - 1)
                    _buildBumdesActionButton(context, currentIndex),
                  if (isMitra && status == 'arrived')
                    _buildMitraConfirmButton(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(int currentIndex) {
    return Column(
      children: List.generate(
        _statusOrder.length,
        (index) {
          final isCompleted = index <= currentIndex;
          final isCurrent = index == currentIndex;

          return Column(
            children: [
              Row(
                children: [
                  // Status circle
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? Colors.green : Colors.grey[300],
                    ),
                    child: Center(
                      child: Icon(
                        _getStatusIcon(_statusOrder[index]),
                        color: isCompleted ? Colors.white : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Status label
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _statusLabels[_statusOrder[index]] ?? '',
                          style: TextStyle(
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            color: isCompleted ? Colors.black : Colors.grey,
                          ),
                        ),
                        if (isCurrent)
                          Text(
                            'Saat ini',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              // Connector line
              if (index < _statusOrder.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                  child: Container(
                    height: 20,
                    width: 2,
                    color: isCompleted ? Colors.green : Colors.grey[300],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'processing':
        return Icons.schedule;
      case 'given_to_courier':
        return Icons.local_shipping;
      case 'on_the_way':
        return Icons.directions_car;
      case 'arrived':
        return Icons.location_on;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor() {
    if (status == 'completed') {
      return Colors.green;
    } else if (status == 'arrived') {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  Text _getStatusDescription() {
    final descriptions = {
      'processing': 'Pesanan Anda sedang diproses oleh penjual.',
      'given_to_courier': 'Pesanan telah diserahkan kepada kurir pengiriman.',
      'on_the_way': 'Pesanan sedang dalam perjalanan menuju Anda.',
      'arrived': 'Pesanan telah sampai di tujuan. Silakan ambil atau konfirmasi penerimaan.',
      'completed': 'Pesanan telah diterima. Terima kasih telah berbelanja!',
    };

    return Text(
      descriptions[status] ?? '',
      style: const TextStyle(fontSize: 13, color: Colors.grey),
    );
  }

  Widget _buildBumdesActionButton(BuildContext context, int currentIndex) {
    final nextStatus = _statusOrder[currentIndex + 1];
    final nextLabel = _statusLabels[nextStatus] ?? '';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onStatusChange?.call(nextStatus),
        child: Text('Ubah ke: $nextLabel'),
      ),
    );
  }

  Widget _buildMitraConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showConfirmDialog(context),
        icon: const Icon(Icons.check),
        label: const Text('Pesanan Selesai'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Penerimaan'),
        content: const Text(
          'Apakah Anda yakin pesanan telah diterima dengan baik?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirmDelivery?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Ya, Konfirmasi'),
          ),
        ],
      ),
    );
  }
}
