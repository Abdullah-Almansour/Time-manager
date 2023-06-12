
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {

  var user_id;
  var email;
  var password;
  var name;
  var phone;
  var timestamp;

  Users.empty([this.name="",this.phone="",this.email="",this.password="",this.user_id=""]);
  Users(this.user_id,this.email,this.password,this.name,this.phone);

  Users.fromMap(Map<String, dynamic> data){
    user_id = data['user_id'];
    name= data['name'];
    email = data['email'];
    password = data['password'];
    phone = data['phone'];
    timestamp = data['timestamp'];
  }
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'name':name,
      'email' :email,
      'password' :password,
      'phone' :phone,
      'timestamp' :Timestamp.now(),
    };
  }

  Users.fromDocument(DocumentSnapshot doc){
    user_id = doc.get('user_id');
    name= doc.get('name');
    email = doc.get('email');
    password = doc.get('password');
    phone = doc.get('phone');
    timestamp= doc.get(timestamp);
  }

}
