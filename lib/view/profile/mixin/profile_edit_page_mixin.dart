import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/view/profile/profile_edit.dart';
import 'package:coffe_app/view_model/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin ProfileEditPageMixin on State<ProfileEditPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    emailController = TextEditingController(text: widget.profile.email);
    phoneController = TextEditingController(
      text: widget.profile.phone?.toString() ?? '',
    );
    addressController = TextEditingController(text: widget.profile.address ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  int? parsePhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    return int.tryParse(digits);
  }

  Future<void> handleSave() async {
    if (!formKey.currentState!.validate()) return;

    final cubit = context.read<ProfileCubit>();
    final error = await cubit.updateProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: parsePhone(phoneController.text),
      address: addressController.text.trim(),
    );

    if (!mounted) return;

    if (error == null) {
      closePage();
      return;
    }

    showSnackBar(error);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void closePage() {
    AppRouter.pop();
  }
}
