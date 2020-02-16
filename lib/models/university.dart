class UniversityModel {
  final String name;
  final int index;
  final String descriptionShort;
  final String imagePath;

  UniversityModel(
    this.index,
    this.name,
    this.descriptionShort,
    this.imagePath,
  );
}

final mockUniversities = [
  UniversityModel(
    0,
    'Sapienza Università di Roma',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut '
        'labore et dolore magna aliqua.',
    'assets/images/sapienza_logo.jpg',
  ),
  UniversityModel(
    1,
    'Università di Pisa',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut '
        'labore et dolore magna aliqua.',
    'assets/images/unipi_logo.jpg',
  ),
];
