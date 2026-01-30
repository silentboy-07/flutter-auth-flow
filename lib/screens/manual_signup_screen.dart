import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../widgets/swipe_button.dart';
import 'user_details_screen.dart';

class ManualSignupScreen extends StatefulWidget {
  const ManualSignupScreen({super.key});

  @override
  State<ManualSignupScreen> createState() => _ManualSignupScreenState();
}

class _ManualSignupScreenState extends State<ManualSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _instagramController = TextEditingController();
  final _youtubeController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  bool _isFormValid = false;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
    _instagramController.addListener(_validateForm);
    _youtubeController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _instagramController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _fullNameController.text.isNotEmpty &&
          _usernameController.text.length >= 3 &&
          _instagramController.text.isNotEmpty &&
          _youtubeController.text.isNotEmpty &&
          _selectedDate != null &&
          _selectedGender != null &&
          Validators.validateAge(_selectedDate) == null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 13),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.white,
              surface: AppColors.veryLightCyan,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _validateForm();
    }
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate() && _isFormValid) {
      final user = UserModel(
        fullName: _fullNameController.text.trim(),
        email: '${_usernameController.text.trim()}@example.com',
        username: _usernameController.text.trim(),
        dateOfBirth: _selectedDate,
        gender: _selectedGender,
        instagramUsername: _instagramController.text.trim(),
        youtubeChannelUsername: _youtubeController.text.trim(),
        signupType: 'Manual',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailsScreen(user: user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightCyan,
              AppColors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: AppColors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: AppColors.mediumCyan.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.darkCyan,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Full Name Field
                        _buildTextField(
                          controller: _fullNameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_rounded,
                          validator: Validators.validateFullName,
                        ),
                        const SizedBox(height: 20),

                        // Username Field
                        _buildTextField(
                          controller: _usernameController,
                          label: 'Username',
                          hint: 'Minimum 3 characters',
                          icon: Icons.alternate_email,
                          validator: Validators.validateUsername,
                        ),
                        const SizedBox(height: 20),

                        // Date of Birth Field
                        InkWell(
                          onTap: () => _selectDate(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedDate != null &&
                                        Validators.validateAge(_selectedDate) !=
                                            null
                                    ? AppColors.errorColor
                                    : AppColors.lightCyan,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: AppColors.mediumCyan.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.veryLightCyan,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.cake_rounded,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Date of Birth',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedDate != null
                                            ? DateFormat('dd MMM yyyy')
                                                .format(_selectedDate!)
                                            : 'Tap to select date',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _selectedDate != null
                                              ? AppColors.textDark
                                              : AppColors.textLight,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_selectedDate != null &&
                            Validators.validateAge(_selectedDate) != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 16),
                            child: Text(
                              Validators.validateAge(_selectedDate)!,
                              style: const TextStyle(
                                color: AppColors.errorColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Gender Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.lightCyan,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: AppColors.mediumCyan.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedGender,
                            decoration: InputDecoration(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.veryLightCyan,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.people_rounded,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              labelText: 'Gender',
                              border: InputBorder.none,
                            ),
                            items: _genderOptions.map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                              _validateForm();
                            },
                            validator: Validators.validateGender,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Instagram Username Field
                        _buildTextField(
                          controller: _instagramController,
                          label: 'Instagram Username',
                          hint: '@username',
                          icon: Icons.camera_alt_rounded,
                          validator: Validators.validateInstagram,
                        ),
                        const SizedBox(height: 20),

                        // YouTube Channel Username Field
                        _buildTextField(
                          controller: _youtubeController,
                          label: 'YouTube Channel',
                          hint: 'Channel username',
                          icon: Icons.play_circle_filled_rounded,
                          validator: Validators.validateYoutube,
                        ),
                        const SizedBox(height: 32),

                        // Swipe to Sign Up Button
                        SwipeButton(
                          text: 'Swipe to Sign Up →',
                          enabled: _isFormValid,
                          onSwipeComplete: _handleSignup,
                          backgroundColor: AppColors.lightCyan,
                          buttonColor: AppColors.primaryColor,
                          disabledColor: Colors.grey.shade200,
                        ),

                        // Form validation hint
                        if (!_isFormValid)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.veryLightCyan,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.mediumCyan),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: AppColors.primaryColor, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Please fill all fields correctly to enable sign up',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.mediumCyan.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.veryLightCyan,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.lightCyan, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.lightCyan, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
          ),
          filled: true,
          fillColor: AppColors.white,
        ),
      ),
    );
  }
}
