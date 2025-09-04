import 'package:filegallery/viewer/Register.dart';
import 'package:filegallery/viewer/homeScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool changer = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  var isNotValid = false;

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
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    const CircleAvatar(
                      radius: 120,
                      backgroundImage: AssetImage('assets/login.jpg'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                     Text(
                      'Welcome back to your file gallery !',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 27, 138, 194)),
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w400, fontSize: 18),
                      enableSuggestions: false,
                      controller: _email,
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
                      style: const TextStyle( color: Colors.black,
                          fontWeight: FontWeight.w400, fontSize: 18),
                      controller: _password,
                      obscureText: changer,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              changer = !changer;
                            });
                          },
                          icon:
                              Icon(changer ? Icons.visibility_off : Icons.visibility, color: changer?Colors.red:Colors.green,),
                        ),
                        hintText: "enter the password",
                        labelStyle: const TextStyle(fontSize: 20),
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                     Row( mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         TextButton(
                                           onPressed: () {},
                                           child: const Text("Forgot password",style: TextStyle(fontSize: 15,),),
                                         ),
                       ],
                     ),
                    const SizedBox(
                      height: 80,
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
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)))),
                    onPressed: () async {
                      final email = _email.text.trim();
                      final password = _password.text.trim();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  HomeScreen(username: "Thiru",)),
                        (route) => false);
                      if (email.isNotEmpty && password.isNotEmpty) {
                      } else {
                        setState(() {
                          isNotValid = true;
                        });
                      }

                      //we need to read the emit state frm the bloc
                    },
                    child: const Text(
                      "login",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                )),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                        (route) => false);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.arrow_back,size: 28,),

                      const Text(
                          "Not registered yet ? then please register here",style: TextStyle(fontSize: 15,)),
                    ],
                  ),
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}