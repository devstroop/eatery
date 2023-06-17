import 'dart:io';

import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String companyName;
  final String? logoPath;
  const DashboardHeader({Key? key, required this.companyName, this.logoPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
              child: Row(
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
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
              child: Row(
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
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 24.0, top: 16.0),
          child: logoPath != null && File(logoPath!).existsSync()
              ? Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.file(
                        File(logoPath!),
                      ).image,
                    ),
                  ),
                )
              : Container(),
        )
      ],
    );
  }
}
