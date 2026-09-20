import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/core/widget/submit_button.dart';

import '../../core/theme/app_input_style.dart';
import '../../main.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  final camera = CameraController(
    cameras.firstWhere((element) => element.lensDirection == .back),
    .high,
    enableAudio: false,
  );

  final ba = TextEditingController();

  bool running = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await camera.initialize();
        setState(() {});

        camera.startImageStream((image) async {
          if (running) return;

          running = true;

          final bytes = image.planes[0].bytes;
          final width = image.width;
          final height = image.height;

          int index = 0;
          final rotates = Uint8List(width * height);

          for (int x = 0; x < width; x++) {
            for (int y = height - 1; y >= 0; y--) {
              rotates[index++] = bytes[y * width + x];
            }
          }

          final res = await channelM.invokeMethod('scan', {
            'bytes': rotates,
            'width': height,
            'height': width,
          });

          if (res != null) {
            camera.stopImageStream();
            context.back(res);
          }
          await Future.delayed(Duration(milliseconds: 600));
          running = false;
        });
      } catch (e) {
        message('카메라 권한이 필요합니다');

        context.back();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          style: IconButton.styleFrom(),
          onPressed: () {
            context.back();
          },
          icon: Icon(Icons.close, color: Colors.white60, size: 32),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          '바코드 검색',
          style: TextStyle(
            color: Colors.white,
            fontWeight: .bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppTextStyle.bold14(color: AppColor.whiteL1)
                .text('상품의 바코드를 화면 중앙에 맞춰주세요'),
          ),

          Expanded(child: _barcode()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => inputDialog(context),
                );
              },
              child: Row(
                mainAxisSize: .min,
                spacing: 10,
                children: [
                  AppIcon.barcode.icon(color: Colors.white60, size: 24),
                  AppTextStyle.medium16(color: AppColor.whiteL1).text('직접 입력'),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),
        ],
      ),
    );
  }

  Dialog inputDialog(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.blackL2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 24,
          mainAxisSize: .min,
          children: [
            AppTextStyle.bold24().text('바코드 직접 입력'),

            TextField(
              controller: ba,
              style: TextStyle(color: Colors.white),
              decoration: AppInputStyle.base(
                hint: '바코드를 입력해주세요.',
                prefIcon: .barcode,
              ),
            ),

            Row(
              spacing: 24,
              children: [
                Expanded(
                  child: SubmitButton(
                    label: '검색',
                    onPressed: () {
                      context.back();
                      context.back(ba.text);
                    },
                  ),
                ),
                Expanded(
                  child: SubmitButton(
                    label: '취소',
                    onPressed: () {
                      context.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ClipRect _barcode() {
    return ClipRect(
      child: Stack(
        children: [
          Positioned.fill(child: CameraPreview(camera)),
          Positioned.fill(
            child: Center(
              child: ColorFiltered(
                colorFilter: .mode(Colors.black54, .srcOut),
                child: Container(
                  color: Colors.transparent,
                  alignment: .center,
                  child: Container(
                    color: Colors.black,
                    width: 280,
                    height: 160,
                  ),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Center(
              child: RepeatingAnimationBuilder(
                animatable: Tween<double>(begin: 0.0, end: 1.0),
                repeatMode: .reverse,
                duration: Duration(milliseconds: 1200),
                builder: (context, value, child) {
                  print(value);
                  return SizedBox(
                    width: 280,
                    height: 160,
                    child: AnimatedAlign(
                      duration: Duration(milliseconds: 1200),
                      alignment: value <= .5 ? .topCenter : .bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          color: AppColor.yellow.withAlpha(100),
                          thickness: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned.fill(
            child: Center(
              child: RepeatingAnimationBuilder(
                duration: Duration(milliseconds: 1200),
                animatable: Tween<double>(begin: .0, end: 1.0),
                repeatMode: .reverse,
                builder: (context, value, child) {
                  double w = 20;
                  double h = 3;




                  return AnimatedScale(
                    duration: Duration(milliseconds: 1200),
                    scale: (value * .3) + .9,
                    child: ClipRRect(
                      borderRadius: .circular(4),
                      child: SizedBox(
                        width: 280,
                        height: 160,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                color: AppColor.yellow,
                                width: w,
                                height: h,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                color: AppColor.yellow,
                                width: h,
                                height: w,
                              ),
                            ),

                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                color: AppColor.yellow,
                                width: w,
                                height: h,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                color: AppColor.yellow,
                                width: h,
                                height: w,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                color: AppColor.yellow,
                                width: w,
                                height: h,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                color: AppColor.yellow,
                                width: h,
                                height: w,
                              ),
                            ),

                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                color: AppColor.yellow,
                                width: w,
                                height: h,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                color: AppColor.yellow,
                                width: h,
                                height: w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
