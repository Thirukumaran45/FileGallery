import 'package:flutter/material.dart';

void showLoadDialog({required BuildContext context, required Widget classNmae}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: Colors.white, // White background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 20),
             Text(
              "Just an moment ...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 70),
            CircularProgressIndicator(
              color: Colors.blue,
            ),
            
           
          ],
        ),
      ),
    ),
  );

  // Close loader after 3s and navigate
  Future.delayed(const Duration(seconds: 3), () {
    Navigator.pop(context); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => classNmae),
    );
  });
}



void showTextDialog({required BuildContext context, required String message}) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must tap close icon to dismiss
    builder: (_) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 300,  // Fixed width
        height: 150, // Fixed height
        child: Stack(
          children: [
            // Close icon at top-right
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close, color: Colors.red),
              ),
            ),
            // Centered text
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
