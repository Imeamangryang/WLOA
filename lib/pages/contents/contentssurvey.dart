import 'package:survey_kit/survey_kit.dart';

Future<Task> getContentSurveyTask(String raidName) {
  final NavigableTask task = NavigableTask(
    id: TaskIdentifier(),
    steps: <Step>[
      InstructionStep(
        // 0
        title: '레이드 만족도 설문조사',
        text: '$raidName에 대한 만족도 설문조사입니다.',
        buttonText: '시작하기',
      ),
      QuestionStep(
        // 2
        title: '$raidName의 난이도 점수를 평가해주세요.',
        answerFormat: const ScaleAnswerFormat(
          step: 1,
          minimumValue: 1,
          maximumValue: 100,
          defaultValue: 50,
          minimumValueDescription: '1',
          maximumValueDescription: '100',
        ),
      ),
      QuestionStep(
        // 3
        title: '$raidName의 보상 점수를 평가해주세요.',
        answerFormat: const ScaleAnswerFormat(
          step: 1,
          minimumValue: 1,
          maximumValue: 100,
          defaultValue: 50,
          minimumValueDescription: '1',
          maximumValueDescription: '100',
        ),
      ),
      QuestionStep(
        // 3
        title: '$raidName의 보상 점수를 평가해주세요.',
        answerFormat: const ScaleAnswerFormat(
          step: 1,
          minimumValue: 1,
          maximumValue: 100,
          defaultValue: 50,
          minimumValueDescription: '1',
          maximumValueDescription: '100',
        ),
      ),
      QuestionStep(
        // 4
        title: '모험가님의 평가',
        text: '$raidName에 대한 평가를 자유롭게 적어주세요.',
        isOptional: false,
        answerFormat:
            const TextAnswerFormat(maxLines: 5, defaultValue: "", validationRegEx: '^(?!\s*\$).+'),
      ),
      CompletionStep(
        stepIdentifier: StepIdentifier(id: '321'),
        text: '클래스 만족도 설문조사에 참여해주셔서 감사합니다.',
        title: '설문 완료!',
        buttonText: 'Submit survey',
      ),
    ],
  );

  return Future<Task>.value(task);
}
