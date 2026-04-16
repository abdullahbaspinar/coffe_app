import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:coffe_app/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
    nameController.addListener(checkForm);
    emailController.addListener(checkForm);
    passwordController.addListener(checkForm);
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  bool isPassworHidden = true;
  bool isFormValid = false;

  void checkForm() {
    setState(() {
      isFormValid =
          nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void>_handleSignUp()async{
    if(!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();

    final result = await authViewModel.signUp(name: nameController.text, email: emailController.text, password: passwordController.text);

    if (!mounted) return;

    if (result == null) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SignInPage()),
       (route) => false,
       );
    }else {
      ScaffoldMessenger.of(context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSignUpLogo,
              SizedBox(height: 24),
              _buildSignUpText,
              SizedBox(height: 8),
              _buildSignUpTextDescription,
              SizedBox(height: 16),
              _buildSignUpUsernameLabel,
              SizedBox(height: 16),
              _buildSignUpNameField,
              SizedBox(height: 20),
              _buildSignUpEmailLabel,
              SizedBox(height: 16),
              _buildSignUpEmailField,
              SizedBox(height: 20),
              _buildSignUpPasswordLabel,
              SizedBox(height: 16),
              _buildSignUpPasswordField,
              SizedBox(height: 20),
              _buildSignUpButton(AuthViewModel()),
              SizedBox(height: 16),
              _buildSignUpTermsText,


            ],
          ),)
          
          
         
        ),
      ),
    );
  }

  Widget get _buildSignUpLogo {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png", width: 48, height: 48),
        Text(
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

  Widget get _buildSignUpText {
    return Row(
      children: [
        Text(
          "Sign Up",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignUpTextDescription {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "Lorem lorem lorem lorem  lorem Lorem lorem lorem lorem Lorem lorem lorem lorem",
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

  Widget get _buildSignUpUsernameLabel {
    return Row(
      children: [
        Text(
          "Name",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
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
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Name",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty){
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
            fontSize: 16,
            color: Colors.grey,
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
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
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
                return "geçerli email adresi giriniz";
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
            fontSize: 16,
            color: Colors.grey,
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
            obscureText: isPassworHidden,

            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPassworHidden = !isPassworHidden;
                  });
                },
                icon: Icon(
                  isPassworHidden ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primaryColor,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Şifre boş bırsılmamalı";
              }

              if (value.trim().length < 6) {
                return "Şifre en az 6 karekterden oluşmalı";
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton (AuthViewModel authViewModel) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: 
          authViewModel.isLoading ? null :_handleSignUp,        
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? AppColors.primaryColor : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: const Text(
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
        style: TextStyle(fontSize: 12, color: Colors.grey),
        children: [
          const TextSpan(text: "By tapping Sign up you accept all our "),

          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                print("Terms tıklandı");
              },
              child: Text(
                "terms",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const TextSpan(text: " and ", style: TextStyle(fontSize: 12)),

          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                print("Condition tıklandı");
              },
              child: Text(
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
