class LocationRequest {
    String? receiverName;
    String phoneNumber;
    String deliveryAddress;
    String deliveryNote;
    LocationRequest({this.receiverName, required this.phoneNumber, required this.deliveryAddress, required this.deliveryNote});

    Map<String, dynamic> toJson(){
      return {
        'receiverName' : receiverName,
         'phoneNumber' : phoneNumber,
          'deliveryAddress' : deliveryAddress,
         'deliveryNote' : deliveryNote
      };
    }

}