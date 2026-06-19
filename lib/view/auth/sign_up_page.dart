import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:coffe_app/view_model/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
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
                    body: SafeArea(
            child: Padding(
              padding: AppSpacing.padding24,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.s24),
                      _buildSignUpLogo,
                      const SizedBox(height: AppSpacing.s24),
                      _buildSignUpText,
                      const SizedBox(height: AppSpacing.s8),
                      _buildSignUpTextDescription,
                      const SizedBox(height: AppSpacing.s16),
                      _buildSignUpUsernameLabel,
                      const SizedBox(height: AppSpacing.s16),
                      _buildSignUpNameField,
                      const SizedBox(height: AppSpacing.s20),
                      _buildSignUpEmailLabel,
                      const SizedBox(height: AppSpacing.s16),
                      _buildSignUpEmailField,
                      const SizedBox(height: AppSpacing.s20),
                      _buildSignUpPasswordLabel,
                      const SizedBox(height: AppSpacing.s16),
                      _buildSignUpPasswordField,
                      const SizedBox(height: AppSpacing.s20),
                      _buildSignUpButton(state),
                      const SizedBox(height: AppSpacing.s16),
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
        SizedBox(width: AppSpacing.s8),
        Text(
          "Ombe",
          style: TextStyle(
            color: context.appTextPrimary,
            fontSize: AppTypography.size24,
            fontWeight: AppTypography.bold,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpText {
    return Row(
      children: [
        Text(
          "Sign Up",
          style: TextStyle(
            fontWeight: AppTypography.bold,
            color: context.appTextPrimary,
            fontSize: AppTypography.size24,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpTextDescription {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Lorem lorem lorem lorem lorem Lorem lorem lorem lorem Lorem lorem lorem lorem",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: AppTypography.regular,
              color: context.appTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpUsernameLabel {
    return Row(
      children: [
        Text(
          "Name",
          style: TextStyle(
            fontSize: AppTypography.size16,
            color: context.appTextMuted,
            fontWeight: AppTypography.regular,
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
              fillColor: context.appInputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.border(AppRadius.size16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.border(AppRadius.size16),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.border(AppRadius.size16),
                borderSide: BorderSide(
                  color: context.appPrimary,
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
    return Row(
      children: [
        Text(
          "Email",
          style: TextStyle(
            fontSize: AppTypography.size16,
            color: context.appTextMuted,
            fontWeight: AppTypography.regular,
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
              fillColor: context.appInputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.border(AppRadius.size16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.border(AppRadius.size16),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.border(AppRadius.size16),
                borderSide: BorderSide(
                  color: context.appPrimary,
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
    return Row(
      children: [
        Text(
          "Password",
          style: TextStyle(
            fontSize: AppTypography.size16,
            color: context.appTextMuted,
            fontWeight: AppTypography.regular,
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
                  color: context.appPrimary,
                ),
              ),
              filled: true,
              fillColor: context.appInputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.border(AppRadius.size16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.border(AppRadius.size16),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.border(AppRadius.size16),
                borderSide: BorderSide(
                  color: context.appPrimary,
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
          backgroundColor: isFormValid ? context.appPrimary : AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size18),
          ),
          elevation: 0,
        ),
        child: state.isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.appSecondary,
                ),
              )
            : Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: AppTypography.size18,
                  fontWeight: AppTypography.semiBold,
                  color: context.appSecondary,
                ),
              ),
      ),
    );
  }

  Widget get _buildSignUpTermsText {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: AppTypography.size12, color: context.appTextMuted),
        children: [
          const TextSpan(text: "By tapping Sign up you accept all our "),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                debugPrint("Terms tıklandı");
              },
              child: Text(
                "terms",
                style: TextStyle(
                  color: context.appPrimary,
                  fontWeight: AppTypography.semiBold,
                  fontSize: AppTypography.size12,
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
              child: Text(
                "conditions",
                style: TextStyle(
                  color: context.appPrimary,
                  fontWeight: AppTypography.semiBold,
                  fontSize: AppTypography.size12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}