import 'package:flutter/material.dart';

class AssignOrderScreen extends StatelessWidget {
  final String orderId;

  const AssignOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Order'),
      ),
      body: Center(
        child: Text('Assigning details for order ID: $orderId'),
      ),
    );
  }
}
