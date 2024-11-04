import 'dart:io';

import 'package:aookamao/app/data/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../../../app/data/constants/app_typography.dart';

class ImagePickerDashed extends StatelessWidget {
  final VoidCallback onaddpressed;
  final VoidCallback onremovepressed;
  final String title;
  final File imagefile;

  const ImagePickerDashed(
      {super.key,
        required this.onaddpressed,
        required this.title,
        required this.imagefile,
        required this.onremovepressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              imagefile.path != ""
                  ? Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(imagefile.path),
                    height: 80,
                    width: 80,
                  ),
                ),
              ])
                  : Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: DashedBorder.fromBorderSide(
                      dashLength: 10,
                      side: BorderSide(color: AppColors.kPrimary, width: 2),
                    )),
                child: Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => onaddpressed(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: AppColors.kPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.kMedium14.copyWith(
                  color: AppColors.kGrey70,
                ),
              )
            ],
          ),
        ),
        imagefile.path != ""
            ? Positioned(
          right: 0,
          top: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onremovepressed(),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Icon(
                Icons.remove_circle,
                size: 20,
                color: Colors.red,
              ),
            ),
          ),
        )
            : Container()
      ],
    );
  }
}
