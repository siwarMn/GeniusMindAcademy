import 'package:flutter/material.dart';



class ThirdCoursesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دروس السّنة التّاسعة أساسي',
      debugShowCheckedModeBanner: false,
      home: ThirdCoursesPage(),
    );
  }
}

class ThirdCoursesPage extends StatelessWidget {
  final List<Course> courses = [
    Course(" الدّرس 1:                                           التّعداد الحسابي", "أنقر هنا"),
    Course("  الدّرس 2:                    العمليّات في مجموعة الأعداد الحقيقيّة", "أنقر هنا"),
    Course("الدّرس 3:                                    القوى في مجموعة الأعداد الحقيقيّة", "أنقر هنا"),
    Course(" الدّرس 4:                                       التّرتيب و المقاربة", "أنقر هنا"),
    Course("الدّرس 5:                                                      الجذاأت المعتبرة و العبارات الجبريّة ", "أنقر هنا"),
    Course("الدّرس 6:                                                   الإحصاء و الإحتمالات", "أنقر هنا"),
    Course("      الدّرس7:                                               التّعيين في المستوي", "أنقر هنا"),
    Course(" الدّرس8:                                            مبرهنة طالس و تطبيقاتها", "أنقر هنا"),
    Course(" الدّرس9:                                        العلاقات القياسيّة في المثلّث القائم", "أنقر هنا"),
    Course(" الدّرس10:                                         أنشطة حول الرّباعيّات", "أنقر هنا"),
    Course(" الدّرس11:                                      التّعامد في الفضاء", "أنقر هنا"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80), // Ajout d'un espace au-dessus du titre
              Padding(
                padding: const EdgeInsets.only(bottom: 20), // Ajout d'un espacement en bas du titre
                child: Text(
                  'دروس السّنة التّاسعة أساسي',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CourseDetailsPage(course: courses[index])),
                        );
                      },
                      child: Card(
                        color: Color(0xFFfcdedc).withOpacity(0.8),

                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  courses[index].title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right, // Aligner le texte à droite
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            courses[index].description,
                            style: TextStyle(color: Colors.green[800]),
                          ),
                        ),
                      ),

                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Course {
  final String title;
  final String description;

  Course(this.title, this.description);
}

class CourseDetailsPage extends StatelessWidget {
  final Course course;

  CourseDetailsPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/b.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              course.description,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
