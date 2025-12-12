import 'package:flutter/material.dart';
import '../viewmodel/login_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../main.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = LoginViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
  }

  void _onViewModelChange() {
    if (_viewModel.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
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
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildLoginTypeButton(String label, String type) {
    final isSelected = _viewModel.loginAs == type;
    return GestureDetector(
      onTap: () => _viewModel.setLoginAs(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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

                /// TITLE "AgroSell"
                Center(
                  child: Text(
                    'AgroSell',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// MASUK
                Text(
                  'Masuk',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                AnimatedBuilder(
                  animation: _viewModel,
                  builder: (context, child) {
                    return Text(
                      'Masuk sebagai ${_viewModel.loginAs == 'mitra' ? 'Mitra' : 'BUMDes'}',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// LOGIN AS TOGGLE
                Center(
                  child: AnimatedBuilder(
                    animation: _viewModel,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLoginTypeButton('Mitra', 'mitra'),
                            const SizedBox(width: 8),
                            _buildLoginTypeButton('BUMDes', 'bumdes'),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                /// EMAIL FIELD
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: AppColors.textPrimary),
                  ),
                ),

                const SizedBox(height: 20),

                /// PASSWORD FIELD
                AnimatedBuilder(
                  animation: _viewModel,
                  builder: (context, child) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: !_viewModel.isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _viewModel.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _viewModel.togglePasswordVisibility,
                        ),
                      ),
                    );
                  },
                ),

                /// LUPA PASSWORD
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// BUTTON LOGIN
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _viewModel.isLoading
                        ? null
                        : () => _viewModel.login(
                              _emailController.text,
                              _passwordController.text,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textLight,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: _viewModel.isLoading
                        ? const CircularProgressIndicator(color: AppColors.primaryLight)
                        : const Text('Masuk'),
                  ),
                ),

                const SizedBox(height: 20),

                /// REGISTER
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Belum memiliki akun? ',
                        style: TextStyle(color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: 'Daftar sekarang',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
