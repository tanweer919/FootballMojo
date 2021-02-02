import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter/material.dart';

class Tutorial {
  List<TargetFocus> targets = List();
  void initTargets(List<GlobalKey> keys) {
    List<dynamic> targetContent = [
      [
        "This carousel will show top news related to your favourite team.",
        AlignContent.bottom,
      ],
      [
        "Relevant matches related to your favourite team will be shown here",
        AlignContent.bottom,
      ],
      [
        "This section will show general footballing news.",
        AlignContent.top,
      ],
    ];
    for (int i = 0; i < targetContent.length; i++) {
      targets.add(TargetFocus(
        identify: "Target ${i}",
        keyTarget: keys[i],
        contents: [
          ContentTarget(
              align: targetContent[i][1],
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      targetContent[i][0],
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect,
      ));
    }
  }

  void showAfterLayout(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100), () {
      TutorialCoachMark(context,
          targets: targets,
          colorShadow: Color(0xff0A4B7D),
          textSkip: "SKIP",
          paddingFocus: 10,
          opacityShadow: 0.8,
          finish: () {},
          clickTarget: (target) {},
          clickSkip: () {})
        ..show();
    });
  }
}