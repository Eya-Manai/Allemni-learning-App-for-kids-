import 'package:allemni/constants/colors.dart';
import 'package:allemni/constants/toast.dart';
import 'package:allemni/interfaces/play_video_page.dart';
import 'package:allemni/models/lesson_model.dart';
import 'package:allemni/services/file_downloaded_service.dart';
import 'package:allemni/widgets/childnavbar.dart';
import 'package:allemni/widgets/draw_yellow_button.dart';
import 'package:flutter/material.dart';

class Lesson extends StatelessWidget {
  final LessonModel lesson;

  const Lesson({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildNavbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                lesson.name,
                style: TextStyle(fontSize: 24, fontFamily: 'childFont'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 200,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: lesson.vdImage.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(lesson.vdImage),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        debugPrint("can't load the image  ${lesson.vdImage}");
                      },
                    )
                  : null,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayVideoPage(vedioPath: lesson.vdUrl),
                  ),
                );
              },
              child: Center(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 80,
                  color: AppColors.primaryYellow,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 0),
              padding: EdgeInsets.symmetric(horizontal: 0),
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/images/lessonbackground.jpg"),
                  fit: BoxFit.cover,
                ),
                color: AppColors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: SingleChildScrollView(
                child: Column(
                  //te5o lfully width
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(right: 25, top: 30),

                        child: Text(
                          "ملخص الدرس",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 20,
                            fontFamily: 'childFont',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        lesson.resumeImagePath,
                        height: 400,
                        width: 400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: YellowButton(
                        text: "تحميل الملف ",
                        onPressed: () async {
                          final pdfUrl = lesson.fileUrl;
                          final pdfName = "${lesson.name}.pdf";
                          try {
                            await FileDownloadedService.saveFile(
                              pdfUrl,
                              pdfName,
                            );
                            showToast(
                              message: "تم تنزيل الملف بنجاح!",
                              color: AppColors.green,
                            );
                          } catch (_) {
                            showToast(
                              message: "فشل تنزيل الملف",
                              color: AppColors.orange,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
