import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showNotImplementedDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: AlertDialog(
            title: const Center(child: Text('Not Implemented!')),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: const Text('Ok'),
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
          ),
        );
      });
}
