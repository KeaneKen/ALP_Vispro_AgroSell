import 'package:flutter/material.dart';
import '../services/pangan_repository.dart';
import '../services/mitra_repository.dart';
import '../services/bumdes_repository.dart';

/// Test Widget to verify backend connection
/// 
/// Usage: Add this to your app for quick testing
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => BackendConnectionTest()),
/// );
/// ```
class BackendConnectionTest extends StatefulWidget {
  const BackendConnectionTest({Key? key}) : super(key: key);

  @override
  State<BackendConnectionTest> createState() => _BackendConnectionTestState();
}

class _BackendConnectionTestState extends State<BackendConnectionTest> {
  final PanganRepository _panganRepo = PanganRepository();
  final MitraRepository _mitraRepo = MitraRepository();
  final BumdesRepository _bumdesRepo = BumdesRepository();

  bool _isLoading = false;
  String _status = 'Ready to test connection';
  Color _statusColor = Colors.blue;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing connection to backend...';
      _statusColor = Colors.orange;
    });

    try {
      // Test 1: Fetch Pangan
      final pangans = await _panganRepo.getAllPangan();
      
      // Test 2: Fetch Mitra
      final mitras = await _mitraRepo.getAllMitra();
      
      // Test 3: Fetch Bumdes
      final bumdes = await _bumdesRepo.getAllBumdes();

      setState(() {
        _isLoading = false;
        _status = '''
✅ SUCCESS! Backend is connected!

📦 Products: ${pangans.length} found
👥 Mitra: ${mitras.length} found
🏢 Bumdes: ${bumdes.length} found

Your app is ready to use the backend!
        ''';
        _statusColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '''
❌ CONNECTION FAILED

Error: ${e.toString()}

Troubleshooting:
1. Is Laravel running? (php artisan serve)
2. Check the IP in api_config.dart
3. Are you on the same WiFi network?
        ''';
        _statusColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Connection Test'),
        backgroundColor: _statusColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isLoading
                          ? Icons.sync
                          : _statusColor == Colors.green
                              ? Icons.check_circle
                              : _statusColor == Colors.red
                                  ? Icons.error
                                  : Icons.info,
                      size: 48,
                      color: _statusColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: _statusColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testConnection,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_isLoading ? 'Testing...' : 'Test Connection'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Backend Information:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Android Emulator', 'http://10.0.2.2:8000/api'),
            _buildInfoRow('iOS Simulator', 'http://localhost:8000/api'),
            _buildInfoRow('Physical Device', 'http://192.168.1.19:8000/api'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
