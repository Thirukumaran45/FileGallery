import 'package:filegallery/controller/registerController.dart';
import 'package:filegallery/viewer/screens/Login.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
   final TextEditingController _emailController = TextEditingController() ;
   final RegisterController controller = RegisterController();


  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return Scaffold(
      backgroundColor: Colors.white,    
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
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
                        backgroundImage: AssetImage('assets/login.jpg'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                       Text(
                        'Reset your password below',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 27, 138, 194)),
                      ),
                const SizedBox(height: 150),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.black,
                            fontWeight: FontWeight.w400, fontSize: 18),
                        enableSuggestions: false,
                        
                  decoration: const InputDecoration(
                    
                    hintText: 'enter your email',
                       labelStyle: TextStyle(fontSize: 20),
                          border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    // Simple email validation
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                 const SizedBox(
                        height: 60,
                      ),
                SizedBox(
                 width: double.infinity,
                    height: 50,
                  child: ElevatedButton(
                    style:  ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40))))
                              ,
                    onPressed: ()async{
                       if (_formKey.currentState!.validate()){
                       await controller.resetPassword(email: _emailController.text,context: context);}
                    },
                    child: const Text('Get Link' ,style: TextStyle(fontSize: 20),),
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
