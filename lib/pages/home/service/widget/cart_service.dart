import 'package:flutter/material.dart';
import '../../../../constants/app_color.dart';

class CtCartService extends StatelessWidget {
  const CtCartService({
    super.key,
    this.image,
    this.title,
    this.subtitle,
  });
  final String? image;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.white,
      elevation: 4, // Độ cao của bóng đổ
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  // Icon(Icons.album, size: 50, color: Colors.blue),
                  Image.asset(
                image ?? '',
              ),
              title: Text(title ?? ''),
              subtitle: Text(
                subtitle ?? '',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
