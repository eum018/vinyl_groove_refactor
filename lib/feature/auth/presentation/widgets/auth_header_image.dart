import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';

class AuthHeaderImage extends StatelessWidget {
  const AuthHeaderImage({
    super.key,
    this.height = 300,
    this.imageWidth = 180,
    this.showImage = true,
  });

  final double height;
  final double imageWidth;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: .cover,
        ),
      ),
      child: Container(
        color: Colors.black54,
        alignment: Alignment(0, .6),
        child: BackdropFilter(
          filter: .blur(sigmaX: 3, sigmaY: 3),
          child: Column(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              Image.asset('assets/logo_horizontal.png', width: imageWidth),

              AppTextStyle.regular12(color: AppColor.whiteL1)
                  .text('Vinyl Record Secondhand Marketplace'),
            ],
          ),
        ),
      ),
    );
  }
}
