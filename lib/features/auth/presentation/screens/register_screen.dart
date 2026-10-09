import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/widgets/company_footer.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _passwordController = TextEditingController();

  AppRole _selectedRole = AppRole.customer;
  String _selectedProvince = 'Bagmati Province (बागमती प्रदेश)';
  bool _obscurePassword = true;

  final List<String> _nepalProvinces = [
    'Bagmati Province (बागमती प्रदेश)',
    'Gandaki Province (गण्डकी प्रदेश)',
    'Koshi Province (कोशी प्रदेश)',
    'Lumbini Province (लुम्बिनी प्रदेश)',
    'Madhesh Province (मधेश प्रदेश)',
    'Karnali Province (कर्णाली प्रदेश)',
    'Sudurpashchim Province (सुदूरपश्चिम प्रदेश)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authNotifierProvider.notifier).signUp(
          email: _emailController.text,
          password: _passwordController.text,
          fullName: _nameController.text,
          role: _selectedRole,
          phoneNumber: _phoneController.text.isNotEmpty
              ? '+977${_phoneController.text.replaceAll(' ', '')}'
              : null,
          businessName: _selectedRole == AppRole.businessOwner || _selectedRole == AppRole.staff
              ? _businessNameController.text
              : null,
          province: _selectedProvince,
          city: 'Kathmandu / Pokhara',
        );

    if (success && mounted) {
      final role = ref.read(currentRoleProvider);
      context.go(role.defaultRoutePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);
    final dynamicTitle = authState.dynamicAppTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text('$dynamicTitle नयाँ खाता दर्ता'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '$dynamicTitle मा जोडिनुहोस्',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'आफ्नो आवश्यकता अनुसार भूमिका (Role) छनोट गर्नुहोस्',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'तपाईंको खाता प्रकार (Account Role)',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _RoleTabItem(
                              title: 'ग्राहक',
                              subtitle: 'Customer',
                              isSelected: _selectedRole == AppRole.customer,
                              onTap: () => setState(() => _selectedRole = AppRole.customer),
                            ),
                          ),
                          Expanded(
                            child: _RoleTabItem(
                              title: 'व्यापारी',
                              subtitle: 'Merchant',
                              isSelected: _selectedRole == AppRole.businessOwner,
                              onTap: () => setState(() => _selectedRole = AppRole.businessOwner),
                            ),
                          ),
                          Expanded(
                            child: _RoleTabItem(
                              title: 'कर्मचारी',
                              subtitle: 'Staff',
                              isSelected: _selectedRole == AppRole.staff,
                              onTap: () => setState(() => _selectedRole = AppRole.staff),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'पूरा नाम (Full Name)',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'उदा. Aarav Sharma / सीता दाहाल',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'कृपया नाम लेख्नुहोस्' : null,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'इमेल ठेगाना (Email)',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'yourname@domain.com.np',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? 'मान्य इमेल आवश्यक छ' : null,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'मोबाइल नम्बर (Nepal Phone: +977)',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          child: Text('+977', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ),
                        hintText: '98XXXXXXXX',
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_selectedRole == AppRole.businessOwner || _selectedRole == AppRole.staff) ...[
                      Text(
                        'व्यवसाय वा पसलको नाम (Business / Store Name)',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _businessNameController,
                        decoration: const InputDecoration(
                          hintText: 'उदा. Himalayan Organic Mart',
                          prefixIcon: Icon(Icons.storefront_outlined),
                        ),
                        validator: (v) {
                          if (_selectedRole != AppRole.customer && (v == null || v.trim().isEmpty)) {
                            return 'व्यवसायको नाम आवश्यक छ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text(
                      'प्रदेश (Province)',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedProvince,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      items: _nepalProvinces
                          .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedProvince = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'सुरक्षित पासवर्ड (Password)',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'कम्तिमा ६ वर्ण (Min 6 characters)',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.lightTextMuted,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.length < 6) ? 'पासवर्ड कम्तिमा ६ अक्षरको हुनुपर्छ' : null,
                    ),
                    const SizedBox(height: 24),

                    if (authState.errorMessage != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          authState.errorMessage!,
                          style: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],

                    ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleRegister,
                      child: authState.isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Text('खाता सिर्जना गर्नुहोस् (Register Now)'),
                    ),
                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('पहिले नै खाता छ? (Already registered?) '),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text(
                            'यहाँ लगइन गर्नुहोस्',
                            style: TextStyle(color: AppColors.accentDark, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Permanent Footer Branding
                    const CompanyFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleTabItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleTabItem({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isSelected ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? AppColors.accentLight : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
