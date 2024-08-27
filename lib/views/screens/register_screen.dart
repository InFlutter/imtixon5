import 'package:flutter/material.dart';
import 'package:dars67/services/firebase_auth_service.dart';
import 'package:dars67/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final nameController = TextEditingController();

  final firebaseAuthService = FirebaseAuthService();

  void submit() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordController.text == passwordConfirmationController.text) {
      try {
        await firebaseAuthService.register(
          emailController.text,
          passwordController.text,
          nameController.text,
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (error) {
        Helpers.showErrorDialog(context, error.message ?? "Xatolik");
      } catch (e) {
        Helpers.showErrorDialog(context, "Tizimda xatolik");
      }
    } else {
      Helpers.showErrorDialog(context, "Parol mos kelmadi yoki bo'sh maydonlar mavjud.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "REGISTER",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ism",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Parol",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordConfirmationController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Parolni tasdiqlang",
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: submit,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("REGISTER"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
