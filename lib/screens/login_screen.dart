import 'package:flutter/material.dart';
import 'package:project/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    bool success = await AuthService.login(
      emailController.text,
      passwordController.text,
    );
    if (success) {
      Navigator.pushReplacementNamed(
        context,
        AuthService.userRole == 'admin' ? '/adminHome' : '/userHome',
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'L O G I N',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 25),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 25),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 60),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                        0xFFE6BFFF,
                      ), // Change this to your preferred color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // Smaller radius
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ), // Adjust padding
                    ),
                    child: Text(
                      "L O G I N",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ), // Adjust text color
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
