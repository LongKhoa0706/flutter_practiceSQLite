
class Person{
  int id;
  String name;
  String password;

  Person({this.id, this.name, this.password});

  factory Person.fromMap(Map<String, dynamic> json) => Person(
    id: json["id"],
    name: json["name"],
    password: json["password"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "password": password,
  };

}