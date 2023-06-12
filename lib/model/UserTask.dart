
import 'package:cloud_firestore/cloud_firestore.dart';

class UserTask {

  var task_id;
  var user_id;
  var date;
  var time;
  var notify;
  var name;
  var completed;
  var timestamp;

  UserTask.empty([this.name="",this.completed="",this.date="",this.time="",this.notify="",this.task_id=""]);
  UserTask(this.task_id,this.user_id,this.name,this.date,this.time,this.notify,[this.completed=false]);

  UserTask.fromMap(Map<String, dynamic> data){
    task_id = data['task_id'];
    user_id = data['user_id'];
    name= data['name'];
    date = data['date'];
    time = data['time'];
    notify = data['notify'];
    completed = data['completed'];
    timestamp = data['timestamp'];
  }
  Map<String, dynamic> toMap() {
    return {
      'task_id': task_id,
      'user_id': user_id,
      'name':name,
      'date' :date,
      'time' :time,
      'notify' :notify,
      'completed' :completed,
      'timestamp' :Timestamp.now(),
    };
  }

  UserTask.fromDocument(DocumentSnapshot doc){
    task_id = doc.get('task_id');
    user_id = doc.get('user_id');
    name= doc.get('name');
    date = doc.get('date');
    time = doc.get('time');
    notify = doc.get('notify');
    completed = doc.get('completed');
    timestamp= doc.get('timestamp');
  }

}
