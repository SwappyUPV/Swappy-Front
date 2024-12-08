import 'package:flutter/material.dart';
import 'package:pin/core/services/create_user_service.dart';
import '../../screens/login_screen.dart';
import 'package:pin/features/auth/presentation/widgets/components/image_picker_widget.dart'; // Import ImagePickerWidget
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final CreateUserService _createUserService = CreateUserService();
  final _formKey = GlobalKey<FormState>();

  final List<String> allSizes = ['XS', 'S', 'M', 'L', 'XL'];

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
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
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
                  icon: Icon(_showConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Cumpleaños',
                  style: TextStyle(
                    fontFamily: 'UrbaneMedium',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Center(
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
                                ? "Selecciona fecha"
                                : "${_selectedBirthday!.toLocal()}"
                                    .split(' ')[0],
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
            MultiSelectDialogField(
              items: allSizes
                  .map((size) => MultiSelectItem<String>(size, size))
                  .toList(),
              title: Text("Selecciona las tallas"),
              selectedColor: Colors.blue,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              buttonIcon: Icon(Icons.arrow_drop_down),
              buttonText: Text(
                preferredSizes.isEmpty
                    ? 'Selecciona tallas'
                    : 'Tallas seleccionadas',
              ),
              onConfirm: (selectedSizes) {
                setState(() {
                  preferredSizes = selectedSizes.cast<String>();
                });
              },
              initialValue: preferredSizes,
              dialogHeight: 300,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => signUpUser(context),
              child: Text("Registrarse".toUpperCase()),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeCheckbox(String size) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: preferredSizes.contains(size),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                preferredSizes.add(size);
              } else {
                preferredSizes.remove(size);
              }
            });
          },
        ),
        Text(size),
      ],
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
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedBirthday = pickedDate;
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
