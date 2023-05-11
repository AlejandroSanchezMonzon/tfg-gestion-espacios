import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/colors.dart';

class ErrorMessageDialog extends StatelessWidget {
  final String title;
  final String description;

  const ErrorMessageDialog({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: MyColors.pinkApp,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 10.0),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20.0,
              fontFamily: 'KoHo',
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: 'KoHo',
            ),
          ),
        ],
      ),
    );
  }
}
