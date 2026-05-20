class LocationResponse {
  final int id;
  final String receiverName;
  final String phoneNumber;
  final String deliveryAddress;
  final String deliveryNote;

  final int userId;
  final String userName;
  final String userEmail;

  LocationResponse({
    required this.id,
    required this.receiverName,
    required this.phoneNumber,
    required this.deliveryAddress,
    required this.deliveryNote,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory LocationResponse.fromJson(
      Map<String,dynamic> json){

    return LocationResponse(
      id: json['id'],

      receiverName:
      json['receiverName'],

      phoneNumber:
      json['phoneNumber'],

      deliveryAddress:
      json['deliveryAddress'],

      deliveryNote:
      json['deliveryNote'],

      userId:
      json['userId'],

      userName:
      json['userName'],

      userEmail:
      json['userEmail'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'receiverName':receiverName,
      'phoneNumber':phoneNumber,
      'deliveryAddress':deliveryAddress,
      'deliveryNote':deliveryNote,
      'userId':userId,
      'userName':userName,
      'userEmail':userEmail,
    };
  }
}