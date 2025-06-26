import 'package:airlineapp/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedCountry;
  bool _isPasswordVisible = false;

  // Mock list of countries for demonstration
  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
    'France',
    'Japan',
    'India',
    'Brazil',
    'Mexico',
    'Bangladesh',
    'Pakistan',
    'China',
    'Russia',
    'South Africa',
    'Egypt',
    'Nigeria',
    'Argentina',
    'Spain',
    'Italy',
    'Netherlands',
    'Sweden',
    'Norway',
    'Denmark',
    'Finland',
    'Switzerland',
    'Austria',
    'Belgium',
    'Portugal',
    'Greece',
    'Ireland',
    'New Zealand',
    'Singapore',
    'Malaysia',
    'Thailand',
    'Indonesia',
    'Philippines',
    'Vietnam',
    'South Korea',
    'Turkey',
    'Saudi Arabia',
    'United Arab Emirates',
    'Qatar',
    'Kuwait',
    'Israel',
  ];

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() {
    // TODO: your real signup logic here (e.g. call Firebase Auth)

    // On successful signup, show a confirmation message…
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed up successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    // …and after a short delay, navigate to '/login'
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const CustomDrawer(),
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 80,
        leading: Center(
          child: Image.asset(
            'assets/logo.png', // Assuming this is the burgundy 'B' logo
            height: 30,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Open the drawer
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 400, // Max width for the card
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: _displayNameController,
                  hintText: 'Display Name',
                ),
                const SizedBox(height: 20),
                _buildCountryDropdown(),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already user? ',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return DropdownSearch<String>(
      items: _countries,
      selectedItem: _selectedCountry,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: 'Country',
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedCountry != null)
                GestureDetector(
                  onTap: () => setState(() => _selectedCountry = null),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.clear, size: 20, color: Colors.grey),
                  ),
                ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        menuProps: MenuProps(
          borderRadius: BorderRadius.circular(6),
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        searchFieldProps: const TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Country',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
        ),
        itemBuilder: (context, country, isSelected) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Text(country),
        ),
      ),
      onChanged: (country) => setState(() => _selectedCountry = country),
    );
  }
}
