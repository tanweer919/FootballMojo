import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final String? label;
  final bool inProgress;
  final VoidCallback? onPressed;
  final double? height;
  final double? minWidth;

  const CustomRaisedButton({
    Key? key,
    this.label,
    this.inProgress = false,
    this.height,
    this.minWidth,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        minimumSize: (height != null || minWidth != null)
            ? Size(minWidth ?? 0, height ?? 0)
            : null,
        padding: EdgeInsets.symmetric(
            horizontal: 16, vertical: 8), // Default padding, can be adjusted
      ),
      child: inProgress
          ? SizedBox(
              height: 20, // Adjust size of indicator as needed
              width: 20, // Adjust size of indicator as needed
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5f5f5)),
                strokeWidth: 2.0, // Adjust strokeWidth as needed
              ),
            )
          : Text(
              label ?? '',
              style: TextStyle(color: Colors.white),
            ),
      onPressed: onPressed,
    );
  }
}
