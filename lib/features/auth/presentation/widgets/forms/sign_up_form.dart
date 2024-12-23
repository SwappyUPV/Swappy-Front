import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:pin/core/services/create_user_service.dart';
import 'package:pin/features/profile/presentation/services/user_update_service.dart';
import 'package:pin/features/profile/presentation/widgets/edit_birthday_dialog.dart';
import '../../screens/login_screen.dart';
import 'package:pin/features/auth/presentation/widgets/components/image_picker_widget.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final CreateUserService _createUserService = CreateUserService();
  final _formKey = GlobalKey<FormState>();

  final List<String> allSizes = ['XS', 'S', 'M', 'L', 'XL'];
  final MultiSelectController<String> _multiSelectController = MultiSelectController();

  DateTime? _selectedBirthday;
  String? _selectedGender = 'Hombre';
  List<String> preferredSizes = [];
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  dynamic _pickedImage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                ImagePickerWidget(
                  pickedImage: _pickedImage,
                  onImagePicked: (image) {
                    setState(() {
                      _pickedImage = image;
                    });
                  },
                ),
              ],
            ),
            const Divider(height: 30, thickness: 2),
            const Text(
              'Información Personal',
              style: TextStyle(
                fontFamily: 'UrbaneMedium',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Nombre de usuario",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Correo electrónico",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Divider(height: 30, thickness: 2),
            const Text(
              'Contraseña',
              style: TextStyle(
                fontFamily: 'UrbaneMedium',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: !_showPassword,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Introducir contraseña",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_showConfirmPassword,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Confirmar contraseña",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Divider(height: 30, thickness: 2),
            const Text(
              'Detalles Adicionales',
              style: TextStyle(
                fontFamily: 'UrbaneMedium',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _addressController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Localidad",
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(fontSize: 14, fontFamily: 'UrbaneMedium', color: Colors.black87),
              items: ['Hombre', 'Mujer', 'Otro']
                  .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Fecha de Nacimiento',
                  style: TextStyle(
                    fontFamily: 'UrbaneMedium',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: _pickBirthday,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.black),
                          const SizedBox(width: 8),
                          Text(
                            _selectedBirthday == null
                                ? "Seleccionar"
                                : "${_selectedBirthday!.toLocal()}".split(' ')[0],
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            MultiDropdown<String>(
              items: allSizes.map((size) => DropdownItem<String>(label: size, value: size)).toList(),
              controller: _multiSelectController,
              enabled: true,
              searchEnabled: false, // Disable the search bar
              chipDecoration: const ChipDecoration(
                backgroundColor: Colors.black,
                labelStyle: TextStyle(color: Colors.white),
                wrap: false,
                runSpacing: 0,
                spacing: 5, // Reduce spacing
              ),
              fieldDecoration: const FieldDecoration(
                hintText: 'Selecciona tallas',
                hintStyle: TextStyle(color: Colors.black87),
                showClearIcon: false,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              dropdownDecoration: const DropdownDecoration(
                marginTop: 10, // Display content underneath
                maxHeight: 500,
                borderRadius: BorderRadius.all(Radius.circular(10)), // Rounded borders
              ),
              dropdownItemDecoration: DropdownItemDecoration(
                selectedIcon: const Icon(Icons.check_box, color: Colors.black),
                disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecciona tallas';
                }
                return null;
              },
              onSelectionChange: (selectedItems) {
                setState(() {
                  preferredSizes = selectedItems.map((item) => item).toList();
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => signUpUser(context),
              child: const Text(
                "Registrarse",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _pickBirthday() async {

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate:  DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        _selectedBirthday = selectedDate;
      });
    }
  }

  void signUpUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Passwords do not match"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        return;
      }

      // Use default image URL if no image is picked
      if (_pickedImage == null) {
        _pickedImage =
        "https://firebasestorage.googleapis.com/v0/b/swappy-pin.appspot.com/o/profile_images%2Fdefault_user.png?alt=media&token=92bbfc56-8927-41a0-b81c-2394b90bf38c";
      }

      String res = await _createUserService.createUser(
        email: _emailController.text,
        password: _passwordController.text,
        additionalData: {
          'name': _nameController.text,
          'address': _addressController.text,
          'birthday': _selectedBirthday,
          'gender': _selectedGender,
          'points': 0,
          'preferredSizes': preferredSizes,
        },
        profileImage: _pickedImage,
      );

      if (res == "success") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Éxito"),
              content: const Text("Registrado con éxito!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(res),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }
}