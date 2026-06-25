import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/model/user_profile.dart';
import 'package:coffe_app/view_model/profile/profile_cubit.dart';
import 'package:coffe_app/view_model/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  final UserProfile profile;

  const ProfileEditPage({
    super.key,
    required this.profile,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(
      text: widget.profile.phone?.toString() ?? '',
    );
    _addressController =
        TextEditingController(text: widget.profile.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  int? _parsePhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    return int.tryParse(digits);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<ProfileCubit>();

    final error = await cubit.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _parsePhone(_phoneController.text),
      address: _addressController.text.trim(),
    );

    if (!mounted) return;

    if (error == null) {
      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.replaceFirst('Exception: ', '')),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.appBackground,
        appBar: _buildAppBar,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final isSaving = state is ProfileUpdating;

              return SingleChildScrollView(
                padding: AppSpacing.padding24,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatar,
                      const SizedBox(height: AppSpacing.s24),
                      _buildNameLabel,
                      const SizedBox(height: AppSpacing.s8),
                      _buildNameField,
                      const SizedBox(height: AppSpacing.s16),
                      _buildEmailLabel,
                      const SizedBox(height: AppSpacing.s8),
                      _buildEmailField,
                      const SizedBox(height: AppSpacing.s16),
                      _buildPhoneLabel,
                      const SizedBox(height: AppSpacing.s8),
                      _buildPhoneField,
                      const SizedBox(height: AppSpacing.s16),
                      _buildAddressLabel,
                      const SizedBox(height: AppSpacing.s8),
                      _buildAddressField,
                      const SizedBox(height: AppSpacing.s24),
                      _buildSaveButton(isSaving),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: context.appBackground,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: context.appTextPrimary),
        ),
      ),
      title: Text(
        'Edit Profile',
        style: TextStyle(
          color: context.appTextPrimary,
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.bold,
        ),
      ),
    );
  }

  Widget get _buildAvatar {
    return Center(
      child: CircleAvatar(
        radius: 60,
        backgroundColor: context.appPrimaryTint,
        child: Icon(
          Icons.person_rounded,
          size: 56,
          color: context.appPrimary,
        ),
      ),
    );
  }

  Widget get _buildNameLabel => _buildFieldLabel('Name');

  Widget get _buildEmailLabel => _buildFieldLabel('Email');

  Widget get _buildPhoneLabel => _buildFieldLabel('Mobile Phone');

  Widget get _buildAddressLabel => _buildFieldLabel('Address');

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppTypography.size16,
        color: context.appTextMuted,
        fontWeight: AppTypography.regular,
      ),
    );
  }

  Widget get _buildNameField {
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration('Full Name'),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'İsim boş bırakılamaz';
        }
        return null;
      },
    );
  }

  Widget get _buildEmailField {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      readOnly: true,
      decoration: _inputDecoration('Email Address'),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email boş bırakılamaz';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Geçerli email adresi giriniz';
        }
        return null;
      },
    );
  }

  Widget get _buildPhoneField {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration('Mobile Phone'),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return null;

        final digits = value.replaceAll(RegExp(r'\D'), '');
        if (digits.length < 10) {
          return 'Geçerli telefon numarası giriniz';
        }
        if (int.tryParse(digits) == null) {
          return 'Sadece rakam giriniz';
        }
        return null;
      },
    );
  }

  Widget get _buildAddressField {
    return TextFormField(
      controller: _addressController,
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.done,
      maxLines: 2,
      decoration: _inputDecoration('Address'),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
        borderRadius: BorderRadius.all(AppRadius.corner(AppRadius.size16)),
        borderSide: BorderSide(
          color: context.appPrimary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isSaving) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isSaving ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.appPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size18),
          ),
          elevation: 0,
        ),
        child: isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text(
                'SAVE',
                style: TextStyle(
                  fontSize: AppTypography.size18,
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}
