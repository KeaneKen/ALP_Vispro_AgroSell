import 'package:flutter/material.dart';
import '../viewmodel/forgot_password_viewmodel.dart';
import '../../../core/theme/app_colors.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final ForgotPasswordViewModel _viewModel = ForgotPasswordViewModel();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
  }

  void _onViewModelChange() {
    if (_viewModel.isResetSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.successMessage!),
          backgroundColor: AppColors.success,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
    if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel.errorMessage!)),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Text(
                    'AgroSell',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Title
                Text(
                  'Lupa Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Masukkan email Anda untuk mereset password',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Reset Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _viewModel.isLoading
                        ? null
                        : () => _viewModel.sendResetEmail(_emailController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textLight,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _viewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Kirim Link Reset',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Back to Login
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Kembali ke Login',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}