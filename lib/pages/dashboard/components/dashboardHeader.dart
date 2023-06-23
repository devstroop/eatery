import 'dart:io';
import 'package:eatery/services/utility/library_image.dart';
import 'package:flutter/material.dart';

import '../../../services/utility/file.utility.service.dart';

class DashboardHeader extends StatelessWidget {
  final String companyName;
  final ImageProvider? image;
  final double? width;
  final EdgeInsets? margin;
  final List<Widget>? suffix;
  const DashboardHeader(
      {Key? key,
      required this.companyName,
      this.image,
      this.width,
      this.margin,
      this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (image != null)
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: image!,
                ),
              ),
            ),
          if (image != null)
            const SizedBox(
              width: 12,
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    companyName,
                    style: const TextStyle(
                      color: Color(0xFF8B97A2),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Color(0xFF090F13),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          ...suffix ?? [],
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
