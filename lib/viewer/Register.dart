import 'package:filegallery/viewer/Login.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool changer = true;
  bool isNotValid = false;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      const SizedBox(
                        height: 60,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => {},
                            child: const Icon(
                              Icons.arrow_back,
                              size: 35,
                            ),
                          )),
                      const CircleAvatar(
                        radius: 120,
                        backgroundImage: AssetImage('assets/register.jpg'),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                       Text(
                        ' Register to Get Started ! ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 27, 138, 194)),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      TextField(
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                        controller: _name,
                        autocorrect: true,
                        autofocus: false,
                        enableSuggestions: true,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "enter the name",
                          labelStyle: TextStyle(fontSize: 20),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                        controller: _email,
                        autocorrect: true,
                        autofocus: false,
                        enableSuggestions: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: "enter the email",
                          labelStyle: TextStyle(fontSize: 20),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                        controller: _password,
                        obscureText: changer,
                        enableSuggestions: true,
                        autocorrect: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                changer = !changer;
                              });
                            },
                            icon:   Icon(changer ? Icons.visibility_off : Icons.visibility, color: changer?Colors.red:Colors.green,),

                          ),
                          hintText: "enter the password",
                          labelStyle: const TextStyle(fontSize: 20),
                          border: const UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
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
                                    borderRadius: BorderRadius.circular(40)))),
                        onPressed: () async {
                          final email = _email.text.trim();
                          final password = _password.text.trim();

                          if (email.isNotEmpty && password.isNotEmpty) {
                            print("registration is completed");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          } else {
                            setState(() {
                              isNotValid = true;
                            });
                          }
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(fontSize: 20),
                        )),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Already register , then login here ",style: TextStyle(fontSize: 15,)))
                ],
              ),
            ),
          ),
        ));
  }
}