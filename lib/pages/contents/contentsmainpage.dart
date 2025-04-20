import 'package:flutter/material.dart';
import 'package:loapetition/constants/nav_items.dart';
import 'package:loapetition/widgets/layout.dart';

class ContentsmainPage extends StatefulWidget {
  const ContentsmainPage({super.key});

  @override
  State<ContentsmainPage> createState() => _ContentsmainPageState();
}

class _ContentsmainPageState extends State<ContentsmainPage> {
  int _hoveredIndex = -1; // Track the hovered index
  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      child: SingleChildScrollView(
          child: Center(
        child: Column(
          children: List.generate(3, (index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // Remove default padding
                backgroundColor: Colors.transparent, // Make the button transparent
                shadowColor: Colors.transparent, // Remove button shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Match the container's border radius
                ),
              ),
              onPressed: () {
                // Navigate to the survey page
                Navigator.pushNamed(context, '/${navItems[0]}');
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
                            height: MediaQuery.of(context).size.width * 0.3,
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.7, // Adjust width to fit image
                      transform: _hoveredIndex == index
                          ? Matrix4.translationValues(-100, 0, 0) // Shift left on hover
                          : Matrix4.identity(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/raid$index.jpg'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter, // Align the image to the top
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
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      )),
    );
  }
}
