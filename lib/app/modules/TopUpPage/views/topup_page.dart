import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: const Text(
            'Savings Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Get.offAllNamed('/home'), // Navigate to '/home' and clear history
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
