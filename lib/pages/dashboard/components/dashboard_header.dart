import 'dart:io';

import 'package:eatery/pages/auth/logout_page.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String companyName;
  final String? logoPath;
  final double? width;
  final EdgeInsets? margin;
  final List<Widget>? suffix;
  const DashboardHeader({Key? key, required this.companyName, this.logoPath, this.width, this.margin, this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(logoPath != null && File(logoPath!).existsSync())
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.file(
                  File(logoPath!),
                ).image,
              ),
            ),
          ),
          if(logoPath != null && File(logoPath!).existsSync())
            const SizedBox(width: 12,),
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
          const SizedBox(width: 8,),
        ],
      ),
    );
  }
}
