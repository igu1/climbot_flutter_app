import 'package:flutter/material.dart';

class CustomInfoWidget extends StatelessWidget {
  const CustomInfoWidget({
    Key? key,
    required this.title,
    required this.snippet,
  }) : super(key: key);

  final String title;
  final String snippet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,  
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            snippet,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
