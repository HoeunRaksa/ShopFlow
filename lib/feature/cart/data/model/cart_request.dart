class CartRequest {
    int proId;
    int quantity;
    CartRequest({required this.proId, required this.quantity});
    Map<String, dynamic> toJson(){
         return{
           'productID' : proId,
           'quantity' : quantity
         };
    }
}