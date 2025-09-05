import 'package:filegallery/controller/FirebaseCloud.dart';
import 'package:filegallery/controller/registerController.dart';
import 'package:filegallery/enum/diaog.dart';
import 'package:filegallery/viewer/screens/Login.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool changer = true;
  late final TextEditingController _name ;
  late final TextEditingController _email ;
  late final TextEditingController _password ;
  late final RegisterController  controller;
  late final FirebaseCloud cloudController;
  // Error messages
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  

bool _validateEmail(String email) {
  final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  return regex.hasMatch(email);
}

  void _register() {
    setState(() {
      _nameError = _name.text.trim().isEmpty ? "Name cannot be empty" : null;
      _emailError = _email.text.trim().isEmpty
          ? "Email cannot be empty"
          : (!_validateEmail(_email.text.trim()) ? "Enter valid email" : null);
      _passwordError =
          _password.text.trim().isEmpty ? "Password cannot be empty" : null;
    });

    // If no errors, show loader and then navigate
   
  }
@override
  void initState() {
    super.initState();
  _name = TextEditingController();
  _email = TextEditingController();
   _password = TextEditingController();
    controller = RegisterController();
    cloudController = FirebaseCloud();
  }

  @override
  void dispose() {
  _name.dispose();
  _email.dispose();
   _password.dispose();
   super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 60),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => {
                          focusNode.unfocus(),
                            Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    )
                        },
                        child: const Icon(Icons.arrow_back, size: 35),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 120,
                      backgroundImage: AssetImage('assets/register.jpg'),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      ' Register to Get Started ! ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 27, 138, 194)),
                    ),
                    const SizedBox(height: 60),

                    // 🔹 Name Field
                    TextField(
                      focusNode: focusNode,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 18),
                      controller: _name,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "enter the name",
                        errorText: _nameError,
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Email Field
                    TextField(
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 18),
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: "enter the email",
                        errorText: _emailError,
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Password Field
                    TextField(
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 18),
                      controller: _password,
                      obscureText: changer,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password_outlined),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              changer = !changer;
                            });
                          },
                          icon: Icon(
                            changer
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: changer ? Colors.red : Colors.green,
                          ),
                        ),
                        hintText: "enter the password",
                        errorText: _passwordError,
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),

                // 🔹 Register Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            WidgetStateProperty.all(Colors.white),
                        backgroundColor:
                            WidgetStateProperty.all(Colors.blue),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                      ),
                      onPressed: () async{
                        _register();
                         if (_nameError == null && _emailError == null && _passwordError == null) {
                        final uid = await controller.createEmailPassword(_email.text,_password.text,context,);
                        showLoadDialog(context: context, classNmae: const LoginScreen());
                       await cloudController.createUser(name: _name.text, email: _email.text, uid: uid);
                          if(!context.mounted)return;
                     
    }
                        },
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Already register , then login here ",
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
