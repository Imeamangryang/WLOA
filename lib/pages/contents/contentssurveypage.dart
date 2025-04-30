// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:loapetition/firestore/database.dart';
import 'package:loapetition/pages/contents/contentssurvey.dart';
import 'package:loapetition/widgets/layout.dart';
import 'package:survey_kit/survey_kit.dart';

class ContentSurveyPage extends StatefulWidget {
  final String raidName;
  final String characterName;

  const ContentSurveyPage({super.key, required this.raidName, required this.characterName});

  @override
  _ContentSurveyPageState createState() => _ContentSurveyPageState();
}

class _ContentSurveyPageState extends State<ContentSurveyPage> {
  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      child: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.center,
          child: FutureBuilder<Task>(
            future: getContentSurveyTask(widget.raidName),
            builder: (BuildContext context, AsyncSnapshot<Task> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                final Task task = snapshot.data!;
                return SurveyKit(
                  onResult: (SurveyResult result) {
                    // FirestoreDatabase()
                    //     .setData(
                    //   collectionPath: widget.className,
                    //   documentId: widget.characterName,
                    //   jsonData: characterData.toJson(),
                    // )

                    FirestoreDatabase()
                        .setData(
                      collectionPath: widget.raidName,
                      documentId: widget.characterName,
                      jsonData: result.toJson(),
                    )
                        .then((_) {
                      // Handle successful data saving here
                      print('Survey result saved successfully!');

                      Navigator.of(context).pop();
                    }).catchError((error) {
                      // Handle error here
                      print('Error saving survey result: $error');
                      Navigator.of(context).pop();
                    });
                  },
                  task: task,
                  showProgress: true,
                  localizations: const <String, String>{
                    'cancel': '',
                    'next': '다음',
                  },
                  themeData: Theme.of(context).copyWith(
                    primaryColor: Colors.cyan,
                    appBarTheme: const AppBarTheme(
                      color: Colors.white,
                      iconTheme: IconThemeData(
                        color: Colors.cyan,
                      ),
                      titleTextStyle: TextStyle(
                        color: Colors.cyan,
                      ),
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.cyan,
                    ),
                    textSelectionTheme: const TextSelectionThemeData(
                      cursorColor: Colors.cyan,
                      selectionColor: Colors.cyan,
                      selectionHandleColor: Colors.cyan,
                    ),
                    cupertinoOverrideTheme: const CupertinoThemeData(
                      primaryColor: Colors.cyan,
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          const Size(150.0, 60.0),
                        ),
                        side: WidgetStateProperty.resolveWith(
                          (Set<WidgetState> state) {
                            if (state.contains(WidgetState.disabled)) {
                              return const BorderSide(
                                color: Colors.grey,
                              );
                            }
                            return const BorderSide(
                              color: Colors.cyan,
                            );
                          },
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        textStyle: WidgetStateProperty.resolveWith(
                          (Set<WidgetState> state) {
                            if (state.contains(WidgetState.disabled)) {
                              return Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.grey,
                                  );
                            }
                            return Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.cyan,
                                );
                          },
                        ),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                        textStyle: WidgetStateProperty.all(
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.cyan,
                              ),
                        ),
                      ),
                    ),
                    textTheme: const TextTheme(
                      displayMedium: TextStyle(
                        fontSize: 28.0,
                        color: Colors.black,
                      ),
                      headlineSmall: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                      bodyMedium: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      bodySmall: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      titleMedium: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    colorScheme: ColorScheme.fromSwatch(
                      primarySwatch: Colors.cyan,
                    )
                        .copyWith(
                          onPrimary: Colors.white,
                        )
                        .copyWith(surface: Colors.white),
                  ),
                  surveyProgressbarConfiguration: SurveyProgressConfiguration(
                    backgroundColor: Colors.white,
                  ),
                );
              }
              return const CircularProgressIndicator.adaptive();
            },
          ),
        ),
      ),
    );
  }
}
