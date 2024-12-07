import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pin/core/services/create_user_service.dart';
import '../../screens/login_screen.dart';
import 'package:pin/features/add_product/presentation/widgets/image_picker.dart'; // Import ImagePickerWidget

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
  final TextEditingController _pointsController = TextEditingController();
  final CreateUserService _createUserService = CreateUserService();
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedBirthday;
  String? _selectedGender;
  List<String> preferredSizes = [];
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  dynamic _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: "Nombre de usuario",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Correo electrónico",
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            obscureText: !_showPassword,
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
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_showConfirmPassword,
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
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              hintText: "Localidad",
              prefixIcon: Icon(Icons.home),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _pointsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Puntos",
              prefixIcon: Icon(Icons.score),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(
              hintText: "Gender",
              prefixIcon: Icon(Icons.person),
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
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Cumpleaños: "),
              TextButton(
                onPressed: _pickBirthday,
                child: Text(_selectedBirthday == null
                    ? "Selecciona fecha"
                    : "${_selectedBirthday!.toLocal()}".split(' ')[0]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Tallas preferidas: "),
              Checkbox(
                value: preferredSizes.contains("M"),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      preferredSizes.add("M");
                    } else {
                      preferredSizes.remove("M");
                    }
                  });
                },
              ),
              const Text("M"),
              Checkbox(
                value: preferredSizes.contains("L"),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      preferredSizes.add("L");
                    } else {
                      preferredSizes.remove("L");
                    }
                  });
                },
              ),
              const Text("L"),
            ],
          ),
          const SizedBox(height: 20),
          ImagePickerWidget(
            pickedImage: _pickedImage,
            onImagePicked: (image) {
              setState(() {
                _pickedImage = image;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => signUpUser(context),
            child: Text("Registrarse".toUpperCase()),
          ),
        ],
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
    _pointsController.dispose();
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

      if (_pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, seleccione una imagen')),
        );
        return;
      }

      String res = await _createUserService.createUser(
        email: _emailController.text,
        password: _passwordController.text,
        additionalData: {
          'name': _nameController.text,
          'address': _addressController.text,
          'birthday': _selectedBirthday,
          'gender': _selectedGender,
          'points': int.parse(_pointsController.text),
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