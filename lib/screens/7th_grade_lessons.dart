import 'package:flutter/material.dart';

class FirstCoursesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دروس السّنة السّابعة أساسي',
      debugShowCheckedModeBanner: false,
      home: FirstCoursesPage(),
    );
  }
}

class FirstCoursesPage extends StatelessWidget {
  final List<Course> courses = [
    Course(" الدّرس 1:                            الأعداد الصحيحة الطبيعية", "أنقر هنا"),
    Course("الدّرس 2:                    الأعداد العشريّة ـ الأعداد الكسريّة", "أنقر هنا"),
    Course("الدّرس 3:                                     الإحصاء و الإحتمالات", "أنقر هنا"),
    Course(" الدّرس 4:                                         التّعامد و التّوازي", "أنقر هنا"),
    Course("الدّرس 5:                                                         الزّوايا", "أنقر هنا"),
    Course("الدّرس 6:                                            التّناظر المحوري", "أنقر هنا"),
    Course("      الدّرس7:                                                  المثلّثات", "أنقر هنا"),
    Course(" الدّرس8:                                            رباعيّات الأضلاع", "أنقر هنا"),
    Course(" الدّرس9:                                           أنشطة في الجبر", "أنقر هنا"),
    Course(" الدّرس10:                                           مسائل إدماجيّة", "أنقر هنا"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
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
                  ' دروس السّنة السّابعة أساسي',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
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
                        color: Colors.yellow[100]?.withOpacity(0.8),

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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_image.jpg"),
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




