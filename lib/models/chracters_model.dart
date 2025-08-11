class ChractersModel {
  final String name;

  final String smiling;
  final String crying;
  final String heartedeyed;

  ChractersModel({
    required this.name,
    required this.smiling,
    required this.heartedeyed,
    required this.crying,
  });

  factory ChractersModel.fromFirestore(Map<String, dynamic> map) {
    final characterName = (map['name'] ?? "").trim();
    return ChractersModel(
      name: characterName,
      smiling: getSmiling(characterName),
      crying: getCrying(characterName),
      heartedeyed: getHeartedEyed(characterName),
    );
  }

  static String getSmiling(String name) {
    switch (name) {
      case 'توتي':
        return 'assets/images/toti.png';
      case 'بوبو':
        return 'assets/images/bobo.png';
      case 'دودو':
        return 'assets/images/dodo.png';
      case 'واكوك':
        return 'assets/images/wakwak.png';
      default:
        return '';
    }
  }

  static String getCrying(String name) {
    switch (name) {
      case 'توتي':
        return 'assets/images/totiCrying.png';
      case 'بوبو':
        return 'assets/images/boboCrying.png';
      case 'دودو':
        return 'assets/images/dodoCrying.png';
      case 'واكوك':
        return 'assets/images/wakwakCrying.png';
      default:
        return '';
    }
  }

  static String getHeartedEyed(String name) {
    switch (name) {
      case 'توتي':
        return 'assets/images/hearteyedtoti.png';
      case 'بوبو':
        return 'assets/images/boboheartEyed.png';
      case 'دودو':
        return 'assets/images/dodoHearteyed.png';
      case 'واكوك':
        return 'assets/images/wakwakHeartedEyed.png';
      default:
        return '';
    }
  }
}
