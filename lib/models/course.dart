class CourseModel {
  final String name;
  final int index;
  final String descriptionShort;
  // TODO(@amerlo): Change with proper description
  final String descriptionLong = '';
  final String university;
  final String universityLogoPath;
  final bool isBookmarked;
  final int students;
  final int salary;
  final double satisfaction;
  final Map<String, double> info;
  final Map<String, double> facilities;

  CourseModel(
    this.index,
    this.name,
    this.university,
    this.descriptionShort,
    this.universityLogoPath,
    this.isBookmarked,
    this.students,
    this.salary,
    this.satisfaction,
    this.info,
    this.facilities,
  );
}

final mockCourses = [
  CourseModel(
    0,
    'Ingegneria delle Merendine',
    'Sapienza Università di Roma',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut '
        'labore et dolore magna aliqua.',
    'assets/images/sapienza_logo.jpg',
    false,
    1245,
    2200,
    87.2,
    {
      'Studenti': 19.0,
      'Aule': 28.0,
    },
    {
      'Stipendio': 19.0,
      'Biblioteche': 28.0,
      'Computer': 89.0,
    },
  ),
  CourseModel(
    0,
    'Ingegneria delle Periferie',
    'Università di Pisa',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut '
        'labore et dolore magna aliqua.',
    'assets/images/unipi_logo.jpg',
    true,
    87,
    945,
    92.1,
    {
      'studenti': 879.0,
      'aule': 48.0,
    },
    {
      'Stipendio': 9.0,
      'Biblioteche': 99.0,
      'Computer': 89.0,
    },
  ),
];
