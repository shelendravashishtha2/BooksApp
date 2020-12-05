import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniproject/constants.dart';

final _mes = FirebaseFirestore.instance;
User currentUser;

class ChatScreen extends StatefulWidget {
   @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void getMessages()async{
    await  for(var i in _mes.collection('message').snapshots())
      {
        for(var message in i.docs){
          print(message.data());
        }
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessages();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kprimaryColor,
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        title: Text('BookName'),
        leading:IconButton(icon:Icon(Icons.arrow_back_outlined) ,onPressed: (){},),
      ),
      body: ChatScreenBody(),
    );
  }
}

class ChatScreenBody extends StatefulWidget {

  @override
  _ChatScreenBodyState createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  String message;

  List<Text> messages=[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MessageStream(),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled:true,
                      fillColor: Color(0xFF344955),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (value) {
                      message = value;
                    },
                  ),
                ),
                IconButton(
                  onPressed: ()async{
                    try{
                      final messageSent = await _mes.collection('message').add({
                        'text': message,
                        'sender': 'shia.sharma123@gmail.com',
                      });
                    }
                    catch(e){
                      final snackbar = SnackBar(content: Text('${e.message}'));
                      Scaffold.of(context).showSnackBar(snackbar);
                    }
                  },
                  icon: Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _mes.collection('message').snapshots(),
        builder: (context,snapshots){
          if(!snapshots.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          }
          else{
            final message = snapshots.data.docs.reversed;
            List<MessageBubble> messageWidgets= [];
            for(var message in message){
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final messageWidget = MessageBubble(
                text: messageText,
                isMe: true,
                sender: messageSender,
              );
              messageWidgets.add(messageWidget);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                children: messageWidgets,
              ),
            );
          }
        }
    );
  }
}


class MessageBubble extends StatelessWidget {

  final sender;
  final text;
  bool isMe;

  MessageBubble({this.text,this.sender,this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 20.0
      ),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
              '$sender'
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            decoration: BoxDecoration(
              color:isMe ?  kprimaryColor :Colors.white ,
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.white,
                width: 1,
              )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white:Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
