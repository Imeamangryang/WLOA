import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:loapetition/constants/lostarkdata.dart';
import 'package:loapetition/widgets/layout.dart';

class StatisticsmainPage extends StatefulWidget {
  const StatisticsmainPage({super.key});

  @override
  State<StatisticsmainPage> createState() => _StatisticsmainPageState();
}

class _StatisticsmainPageState extends State<StatisticsmainPage> {
  // 직업 데이터를 2차원 리스트로 구성
  final List<List<String>> _jobData = [
    ['디스트로이어', '버서커', '슬레이어', '워로드', '홀리나이트'],
    ['기공사', '배틀마스터', '브레이커', '스트라이커', '인파이터', '창술사'],
    ['건슬링어', '데빌헌터', '블래스터', '스카우터', '호크아이'],
    ['바드', '서머너', '소서리스', '아르카나'],
    ['데모닉', '리퍼', '블레이드', '소울이터'],
    ['기상술사', '도화가', '환수사'],
  ];

  // 각 직업 그룹의 이름을 리스트로 관리
  final List<String> _jobGroups = ['전사', '무도가', '헌터', '마법사', '암살자', '스페셜리스트'];

  // 선택된 직업을 관리하는 ValueNotifier
  final ValueNotifier<String?> _selectedJobNotifier = ValueNotifier<String?>(null);

  // subclass별 평균 점수 및 참여자 수를 저장할 Map
  final ValueNotifier<Map<String, Map<String, dynamic>>> _subclassStatsNotifier =
      ValueNotifier<Map<String, Map<String, dynamic>>>({});

  Future<void> _loadAverageScore(String className) async {
    try {
      // Firestore에서 average_scores 컬렉션의 className 문서 가져오기
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('average_scores').doc(className).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data();
        if (data != null && data.containsKey('subclassAverages')) {
          // Subclass와 average 값을 stats 맵에 저장
          Map<String, Map<String, dynamic>> stats = {};
          Map<String, dynamic> subclassAverages = data['subclassAverages'];
          subclassAverages.forEach((subclass, value) {
            if (value is Map<String, dynamic> && value.containsKey('average')) {
              stats[subclass] = {
                'average': value['average'] as num,
                'count': value['count'] ?? 0,
              };
            }
          });
          _subclassStatsNotifier.value = stats;
        } else {
          print("알림: subclassAverages 데이터가 존재하지 않습니다.");
          _subclassStatsNotifier.value = {};
        }
      } else {
        print("알림: $className 문서가 average_scores 컬렉션에 존재하지 않습니다.");
        _subclassStatsNotifier.value = {};
      }
    } catch (e) {
      print("오류 발생: $e");
      _subclassStatsNotifier.value = {};
    }
  }

  List<Map<String, dynamic>> _reviews = [];
  String _error = '';

  Future<void> _fetchRandomReviews() async {
    setState(() {
      _reviews = [];
      _error = '';
    });

    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getRandomReviewsV2');
      final result = await callable.call(<String, dynamic>{
        'collectionName': 'hawkeye', // 실제 컬렉션 이름으로 변경하세요.
        'count': 3, // 가져올 리뷰 개수를 원하는 대로 설정하세요.
      });

      final List<dynamic> data = result.data as List<dynamic>;
      print('Cloud Function 호출 결과: $data');
      setState(() {
        _reviews = data.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      setState(() {
        _error = '리뷰를 가져오는 데 실패했습니다: $e';
      });
      print('Cloud Function 호출 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // 스크롤 가능하도록 추가
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // '전사', '무도가', '헌터', '마법사', '암살자', '스페셜리스트' 그룹을 표시
                for (int groupIndex = 0; groupIndex < _jobGroups.length; groupIndex++) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Text(
                      _jobGroups[groupIndex], // 직업 그룹 이름 표시
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'NotoSansKR', // 폰트 적용
                      ),
                    ),
                  ),
                  // 각 직업 그룹에 해당하는 직업들을 GridView로 표시
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // GridView 내부 스크롤 비활성화
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10, // 각 행에 10개의 직업 버튼 배치
                      childAspectRatio: 4, // 버튼 가로 세로 비율 조정
                      crossAxisSpacing: 10, // 수평 간격
                      mainAxisSpacing: 1, // 수직 간격
                    ),
                    itemCount: _jobData[groupIndex].length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          // 직업 선택 처리 (선택된 직업명을 ValueNotifier에 업데이트)
                          _selectedJobNotifier.value = _jobData[groupIndex][index];
                          _loadAverageScore(jobCollections.entries
                              .firstWhere((entry) => entry.value == _jobData[groupIndex][index])
                              .key); // subclass별 평균 점수 계산 및 리뷰 로드

                          _fetchRandomReviews(); // 리뷰 가져오기
                          // 선택된 직업에 대한 추가 동작 구현 (예: 다음 화면으로 이동)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF303030), // 버튼 배경색
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // 버튼 모서리 둥글게
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4.0), // 버튼 내부 패딩 조정
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown, // 글씨가 버튼 크기를 초과하지 않도록 조정
                          child: Text(
                            _jobData[groupIndex][index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'NotoSansKR', // 폰트 적용
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                // 선택된 직업명 및 subclass별 평균 점수를 표시하는 Container
                ValueListenableBuilder<String?>(
                  valueListenable: _selectedJobNotifier,
                  builder: (context, selectedJob, child) {
                    if (selectedJob == null) {
                      return const SizedBox.shrink(); // 선택된 직업이 없으면 아무것도 표시하지 않음
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '선택된 직업: $selectedJob',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NotoSansKR',
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                '각인별 아크패시브 평가 점수:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NotoSansKR',
                                ),
                              ),
                              ValueListenableBuilder<Map<String, Map<String, dynamic>>>(
                                valueListenable: _subclassStatsNotifier,
                                builder: (context, subclassStats, child) {
                                  if (subclassStats.isEmpty) {
                                    return const Text('해당 직업의 점수 데이터가 없습니다.');
                                  }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: subclassStats.entries.map((entry) {
                                      return Row(
                                        children: [
                                          Text(
                                            '- ${entry.key}: ${entry.value['average']?.toStringAsFixed(1)} ',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'NotoSansKR',
                                            ),
                                          ),
                                          Text(
                                            '(${entry.value['count']}명 참여)',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Row(
                                            children: List.generate(5, (index) {
                                              double starValue =
                                                  (entry.value['average'] as num? ?? 0) /
                                                      20; // 20점 구간마다 별 계산
                                              return Icon(
                                                index < starValue.floor()
                                                    ? Icons.star
                                                    : (index < starValue
                                                        ? Icons.star_half
                                                        : Icons.star_border),
                                                color: Colors.amber,
                                                size: 16,
                                              );
                                            }),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 16.0),
                              const Text(
                                '리뷰:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NotoSansKR',
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _reviews.map((review) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      '- $review',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'NotoSansKR',
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<Map<String, Map<String, dynamic>>> calculateAverageScore(String className) async {
  try {
    // 선택된 직업(className)에 해당하는 컬렉션의 모든 문서 스냅샷 가져오기
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection(className).get();

    // subclass 별로 score 값과 참여자 수를 저장할 맵
    Map<String, List<int>> subclassScores = {};

    // 각 문서에서 subclass와 score 값을 추출하여 맵에 추가
    for (QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data();
      if (data.containsKey('subclass') && data.containsKey('score') && data['score'] is num) {
        String subclass = data['subclass'];
        int score = (data['score'] as num).toInt();

        // 해당 subclass의 리스트에 score 추가
        if (!subclassScores.containsKey(subclass)) {
          subclassScores[subclass] = [];
        }
        subclassScores[subclass]!.add(score);
      } else {
        print("경고: 문서 ID ${document.id}에 'subclass' 또는 'score' 필드가 없거나 유효하지 않습니다.");
      }
    }

    // subclass 별 평균 점수와 참여자 수를 계산
    Map<String, Map<String, dynamic>> subclassStats = {};
    subclassScores.forEach((subclass, scores) {
      if (scores.isNotEmpty) {
        double average = scores.reduce((a, b) => a + b) / scores.length;
        subclassStats[subclass] = {'average': average, 'count': scores.length};
      } else {
        subclassStats[subclass] = {'average': 0.0, 'count': 0};
      }
    });

    return subclassStats;
  } catch (e) {
    print("오류 발생: $e");
    return {}; // 오류 발생 시 빈 맵 반환
  }
}
