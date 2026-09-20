import 'package:flutter/material.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_appbar.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/main.dart';

class BasePinPage extends StatefulWidget {
  const BasePinPage({
    super.key,
    required this.check,
    required this.title,
    required this.content,
    required this.err,
  });

  final Function(List<int?> pins) check;
  final String? title;
  final String content;
  final bool err;

  @override
  State<BasePinPage> createState() => _BasePinPageState();
}

class _BasePinPageState extends State<BasePinPage> {
  int count = 0;

  List<int?> pins = .filled(4, null);
  List<int> keys = .generate(10, (index) => index);

  @override
  void initState() {
    pins = .filled(4, null);
    count = 0;
    keys.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.title != null
        ? BaseScaffold(
            appBar: AppAppbar(
              title: widget.title!,
              center: true,
              showBack: true,
            ),
            body: Padding(padding: const EdgeInsets.all(32.0), child: _body()),
          )
        : _body();
  }

  Column _body() {
    return Column(
      mainAxisAlignment: .center,
      spacing: 16,
      children: [
        Row(
          mainAxisAlignment: .spaceAround,
          children: .generate(4, (index) {
            final fill = pins[index] != null;

            return Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                border: BoxBorder.fromLTRB(
                  bottom: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              alignment: .center,
              child: !fill
                  ? null
                  : Text(
                      count == index + 1 ? pins[index].toString() : '*',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: .bold,
                      ),
                    ),
            );
          }),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: AppTextStyle.bold14(
            color: widget.err ? Colors.red : Colors.white,
          ).text(widget.content),
        ),

        SizedBox(height: 24),
        Builder(
          builder: (context) {
            return _pinGrid();
          },
        ),
      ],
    );
  }

  GridView _pinGrid() {
    Widget pinChip({required VoidCallback act, String? key, Widget? child}) =>
        Card(
          color: AppColor.blackL2,
          child: InkWell(
            onTap: () {
              act.call();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child:
                    child ??
                    (key != null
                        ? Text(
                            key,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .bold,
                              fontSize: 24,
                            ),
                          )
                        : null),
              ),
            ),
          ),
        );

    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        mainAxisExtent: 68,
      ),
      shrinkWrap: true,
      children: [
        ...keys.map((e) {
          if (keys.last != e) {
            return pinChip(
              key: e.toString(),
              act: () {
                if (count < 4) {
                  setState(() {
                    pins[count] = e;
                    count++;
                  });

                  widget.check(pins);
                }
              },
            );
          }

          return pinChip(
            act: () {
              setState(() {
                keys.shuffle();
              });
            },
            key: '재배열',
          );
        }),

        pinChip(
          act: () {
            if (count < 4) {
              setState(() {
                pins[count] = keys.last;
                count++;
              });
            }
            widget.check(pins);
          },
          key: keys.last.toString(),
        ),

        pinChip(
          act: () {
            setState(() {
              if (count > 0) {
                pins[count - 1] = null;
                count--;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back, color: AppColor.white),
          ),
        ),
      ],
    );
  }
}
