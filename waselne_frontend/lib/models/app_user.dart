class AppUser {
  //same as the app user class in springboot
  int? id;
  String userName;
  String password;
  String role;

  AppUser({
    this.id,
    required this.userName,
    required this.password,
    this.role = 'Admin',
  });
//after we retrieve the information
  //we need to create an object user
  //and to create an object we need to change the attributes eli fo2
  //into json so i need to create a json(map)

  //create the map and pass this map as a json to the server
  //after we get the response
  // we actually retrieve information from the response, create a map
  //and then pass the map
  // pass the map ro the constructor to create the corresponding object
//from the information we get
  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'password': password,
      'role': role,

    };
  }
  //with the data that will be coming from our server
  //which will not be used here but typically modal classes consist of two
  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'],
    userName: json['userName'],
    password: json['password'],
    role: json['role'],
  );
}
