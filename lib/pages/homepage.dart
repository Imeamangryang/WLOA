import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loapetition/constants/NPC_dialog.dart';
import 'package:loapetition/constants/nav_items.dart';
import 'package:loapetition/widgets/layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int dialogindex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return CustomLayout(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/Bg_RaidMain.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0), // Adjust the top padding as needed
              child: SizedBox(
                width: (width > 768 ? width / 2 : width),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '★아말론 스타 가이드★',
                        style: GoogleFonts.nanumBrushScript(
                            fontSize: 40, fontWeight: FontWeight.w900, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '유저에, 유저에 의한, 유저를 위한 로스트아크 외부 지표',
                        style: GoogleFonts.nanumBrushScript(
                            fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black),
                        textAlign: TextAlign.justify,
                        softWrap: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/${navItems[0]}');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '클래스 평가 페이지',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/${navItems[1]}');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '콘텐츠 평가 페이지',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -MediaQuery.of(context).size.width * 0.25,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Image.asset(
              'images/NPC2.png',
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.7,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        key: ValueKey<int>(dialogindex),
                        animatedTexts: [
                          TyperAnimatedText(NPC_dialog[dialogindex]),
                        ],
                        onTap: () {
                          setState(() {
                            if (dialogindex < NPC_dialog.length - 1) {
                              dialogindex++;
                            } else {
                              dialogindex = 0; // Reset to the first dialog
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (dialogindex < NPC_dialog.length - 1) {
                        dialogindex++;
                      } else {
                        dialogindex = 0; // Reset to the first dialog
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
