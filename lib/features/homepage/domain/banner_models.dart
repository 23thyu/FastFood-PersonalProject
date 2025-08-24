class Banner {
  final int id;
  final String name;
  final String image;
  final int status;

  Banner({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
  });
  //chuyển từ Json sang Object
  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
    );
  }
}
