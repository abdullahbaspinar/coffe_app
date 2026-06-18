import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:coffe_app/view_model/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkForm);
    emailController.addListener(checkForm);
    passwordController.addListener(checkForm);
  }

  void checkForm() {
    setState(() {
      isFormValid =
          nameController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.removeListener(checkForm);
    emailController.removeListener(checkForm);
    passwordController.removeListener(checkForm);

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await context.read<AuthCubit>().signUp(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
        );

    if (!mounted) return;

    if (result == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      _buildSignUpLogo,
                      const SizedBox(height: 24),
                      _buildSignUpText,
                      const SizedBox(height: 8),
                      _buildSignUpTextDescription,
                      const SizedBox(height: 16),
                      _buildSignUpUsernameLabel,
                      const SizedBox(height: 16),
                      _buildSignUpNameField,
                      const SizedBox(height: 20),
                      _buildSignUpEmailLabel,
                      const SizedBox(height: 16),
                      _buildSignUpEmailField,
                      const SizedBox(height: 20),
                      _buildSignUpPasswordLabel,
                      const SizedBox(height: 16),
                      _buildSignUpPasswordField,
                      const SizedBox(height: 20),
                      _buildSignUpButton(state),
                      const SizedBox(height: 16),
                      _buildSignUpTermsText,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get _buildSignUpLogo {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png", width: 48, height: 48),
        const SizedBox(width: 8),
        const Text(
          "Ombe",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpText {
    return const Row(
      children: [
        Text(
          "Sign Up",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpTextDescription {
    return const Row(
      children: [
        Expanded(
          child: Text(
            "Lorem lorem lorem lorem lorem Lorem lorem lorem lorem Lorem lorem lorem lorem",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpUsernameLabel {
    return const Row(
      children: [
        Text(
          "Name",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textMuted,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpNameField {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Name",
              filled: true,
              fillColor: AppColors.inputFill,
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
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "İsim boş bırakılamaz";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpEmailLabel {
    return const Row(
      children: [
        Text(
          "Email",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textMuted,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpEmailField {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "example@gmail.com",
              filled: true,
              fillColor: AppColors.inputFill,
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
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Email boş bırakılamaz";
              }

              final email = value.trim();

              if (!email.contains("@") || !email.contains(".")) {
                return "Geçerli email adresi giriniz";
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpPasswordLabel {
    return const Row(
      children: [
        Text(
          "Password",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textMuted,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpPasswordField {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: passwordController,
            obscureText: isPasswordHidden,
            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
                icon: Icon(
                  isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primaryColor,
                ),
              ),
              filled: true,
              fillColor: AppColors.inputFill,
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
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Şifre boş bırakılamaz";
              }

              if (value.trim().length < 6) {
                return "Şifre en az 6 karakterden oluşmalı";
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isLoading || !isFormValid ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? AppColors.primaryColor : AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: state.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.secondaryColor,
                ),
              )
            : const Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryColor,
                ),
              ),
      ),
    );
  }

  Widget get _buildSignUpTermsText {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        children: [
          const TextSpan(text: "By tapping Sign up you accept all our "),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                debugPrint("Terms tıklandı");
              },
              child: const Text(
                "terms",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const TextSpan(text: " and "),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                debugPrint("Condition tıklandı");
              },
              child: const Text(
                "conditions",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}