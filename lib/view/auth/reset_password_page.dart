import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildResetPasswordLogo,
              const SizedBox(height: 16),
              _buildResetPasswordTitle,
              const SizedBox(height: 8),
              _buildResetPasswordDescription,
              const SizedBox(height: 16),
              _buildResetPasswordEmailLabel,
              const SizedBox(height: 16),
              _buildResetPasswordEmailField,
              const SizedBox(height: 16),
              _buildResetPasswordSubmitButton,
              const SizedBox(height: 16),
              _buildResetPasswordBottomText,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildResetPasswordLogo {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png", width: 48, height: 48),
        const SizedBox(width: 8),
        const Text(
          "Ombe",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget get _buildResetPasswordTitle {
    return const Row(
      children: [
        Text(
          "Forgot Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget get _buildResetPasswordDescription {
    return const Row(
      children: [
        Expanded(
          child: Text(
            "Lorem lorem lorem lorem lorem Lorem lorem lorem lorem Lorem lorem lorem lorem",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _buildResetPasswordEmailLabel {
    return const Row(
      children: [
        Text(
          "Email",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget get _buildResetPasswordEmailField {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email Address",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget get _buildResetPasswordSubmitButton {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: const Text(
          "SUBMIT",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryColor,
          ),
        ),
      ),
    );
  }

  Widget get _buildResetPasswordBottomText {
    return Row(
      children: [
        const Text(
          "Sign in to your registered account",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignInPage()),
            );
          },
          child: const Text(
            "Login here",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}