import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loapetition/constants/lostarkdata.dart';
import 'package:loapetition/pages/class/classsurveypage.dart';
import 'package:loapetition/widgets/layout.dart';

var accessToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyIsImtpZCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyJ9.eyJpc3MiOiJodHRwczovL2x1ZHkuZ2FtZS5vbnN0b3ZlLmNvbSIsImF1ZCI6Imh0dHBzOi8vbHVkeS5nYW1lLm9uc3RvdmUuY29tL3Jlc291cmNlcyIsImNsaWVudF9pZCI6IjEwMDAwMDAwMDA1Njc2OTUifQ.HOzFbR2gG8RhNvobi3fds5hYBaEi1k55riqT_I609ZRjXAEKLwMK6VkinDXKxRtp4ZouDX54-viGDh32DVquQ6cC-kVPoB6IZstJ6dH5CqMbaJ8cv0TDBY4MR6lf__bN0xBRTyRodF5Ra07_9a_n0cMssEvpJSJ7ofMwAo_313dEHHXyyFw0xM8feYDKNcI574BDmLn_qvSs8pb6bddRSituFAFL-3onHWB5-BQSSezsH8eHOsHzcj5moHic6RgYanfn13FdpzIcdIkA-dn0cdYxK6iXVh5HJkVgowZDWGW8vFb3xiMWJGyl5_FUJCMwYKFjzUPVo9h750NEP9tz8Q';

// ignore: camel_case_types
class classmainPage extends StatefulWidget {
  const classmainPage({super.key});

  @override
  State<classmainPage> createState() => _classmainPageState();
}

// ignore: camel_case_types
class _classmainPageState extends State<classmainPage> {
  String _characterName = '';
  dynamic _data = '';
  List<Map<String, dynamic>> _characters = [];
  int _hoveredIndex = -1; // Track the hovered index

  Future<void> fetchCharacterInfo() async {
    final apiUrl = 'https://developer-lostark.game.onstove.com/characters/$_characterName/siblings';
    final headers = {
      "Content-Type": "application/json;charset-UTF-8",
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>; // Cast to List<dynamic>
        setState(() {
          _characters = data.cast<Map<String, dynamic>>(); // Convert to List<Map<String, dynamic>>
          _characters.sort((a, b) {
            final levelA = double.tryParse(a['ItemMaxLevel'].replaceAll(',', '')) ?? 0;
            final levelB = double.tryParse(b['ItemMaxLevel'].replaceAll(',', '')) ?? 0;
            return levelB.compareTo(levelA); // Sort in descending order
          });
          _data = '존재하지 않는 닉네임입니다.';
        });
      } else {
        setState(() {
          _data = 'Request failed with status: ${response.statusCode}.';
        });
      }
    } catch (e) {
      setState(() {
        _data = '존재하지 않는 닉네임입니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return CustomLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              child: Stack(
                children: [
                  ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                          stops: [0.3, 0.8],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'assets/images/LOSTARK_wallpaper_3440x1440_Limlake.jpg',
                        filterQuality: FilterQuality.high,
                      )),
                  Center(
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: (width > 768 ? width / 2 : width),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 75, horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '클래스 만족도 조사',
                                    style: GoogleFonts.andika(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 209, 209, 209)
                                          .withOpacity(0.5), // Add semi-transparent grey background
                                      borderRadius: BorderRadius.circular(10), // Rounded corners
                                    ),
                                    padding:
                                        const EdgeInsets.all(8.0), // Add padding for better spacing
                                    child: Text(
                                      '1640 이상의 4T 캐릭터만 참여 가능합니다.',
                                      style: GoogleFonts.andika(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black),
                                      textAlign: TextAlign.justify,
                                      softWrap: true,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: const SizedBox(height: 20),
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: '대표캐릭터명',
                                        fillColor: Colors.white,
                                        filled: true,
                                        hoverColor: Colors.white),
                                    onChanged: (value) {
                                      _characterName = value;
                                    },
                                    onSubmitted: (value) {
                                      _characterName = value;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 130, 199, 255),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 32.0),
                                    ),
                                    onPressed: fetchCharacterInfo,
                                    child: const Text('정보 불러오기'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: _characters.isEmpty
                  ? Text(_data)
                  : ListView.builder(
                      // Use ListView.builder for scrollable list
                      shrinkWrap: true, // Wrap content to avoid unnecessary space
                      itemCount: _characters.length,
                      itemBuilder: (context, index) {
                        final character = _characters[index];
                        final itemMaxLevel =
                            double.tryParse(character['ItemMaxLevel'].replaceAll(',', '')) ?? 0;
                        if (itemMaxLevel >= 1640) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero, // Remove default padding
                              backgroundColor: Colors.transparent, // Make the button transparent
                              shadowColor: Colors.transparent, // Remove button shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Match the container's border radius
                              ),
                            ),
                            onPressed: () {
                              // Navigate to the survey page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurveyPage(
                                    className: character['CharacterClassName'].toString(),
                                    characterName: character['CharacterName'].toString(),
                                  ),
                                  settings: RouteSettings(
                                    name: '/${character['CharacterClassName']}',
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                // Background Text
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 100),
                                      opacity: _hoveredIndex == index ? 1.0 : 0.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          height: MediaQuery.of(context).size.width * 0.2,
                                          width: MediaQuery.of(context).size.width *
                                              0.6, // Adjust width to fit image
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent, // Light grey background
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            '평가하기',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Hoverable Container
                                MouseRegion(
                                  onEnter: (_) {
                                    setState(() {
                                      _hoveredIndex = index;
                                    });
                                  },
                                  onExit: (_) {
                                    setState(() {
                                      _hoveredIndex = -1;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    height: MediaQuery.of(context).size.width * 0.2,
                                    width: MediaQuery.of(context).size.width *
                                        0.6, // Adjust width to fit image
                                    transform: _hoveredIndex == index
                                        ? Matrix4.translationValues(
                                            -100, 0, 0) // Shift left on hover
                                        : Matrix4.identity(),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/class${classindex[character['CharacterClassName']]}.jpg'),
                                        fit: BoxFit.cover,
                                        alignment:
                                            Alignment.topCenter, // Align the image to the top
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                              ' 서버 : ${character['ServerName']} \n 닉네임 : ${character['CharacterName']} \n 직업 : ${character['CharacterClassName']} \n 레벨 : ${itemMaxLevel.toInt()}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox
                              .shrink(); // Return an empty widget if condition is not met
                        }
                      },
                    ),
            ),
            Container(
              color: Colors.white,
              child: const SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
