import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendResetEmail() async {
    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final response = await ParseUser(null, null, email).requestPasswordReset();

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.success
              ? "Password reset email sent!"
              : "Error: ${response.error?.message}",
        ),
      ),
    );

    if (response.success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_reset_rounded, size: 80, color: Colors.orange),
              SizedBox(height: 20),
              Text(
                "Reset Password",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: isLoading ? null : sendResetEmail,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Send Reset Email"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 20),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Back to Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
