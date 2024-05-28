import 'package:flutter/material.dart';

class DraggableBottomSheet extends StatelessWidget {
  const DraggableBottomSheet({super.key});

  final String imageUrl =
      "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190421_289%2F1555840071821yDMm7_JPEG%2FISnWF6tTVNqTWRs9S9OiI4Rc.jpg";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DraggableScrollableSheet(
      initialChildSize: 0.25, // 시작 크기 (화면 비율)
      minChildSize: 0.25, // 최소 크기 (화면 비율)
      maxChildSize: 1.0, // 최대 크기 (전체 화면)
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 30,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: screenHeight / 20), // Adjust space for image
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
