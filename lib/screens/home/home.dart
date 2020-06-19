
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp1/shared/loading.dart';
import 'package:flutterapp1/shared/progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'Quiz.dart';
import 'package:flutterapp1/services/services.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class TopicsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    return FutureBuilder(
      future: Global.topicsRef.getData(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          List<Topic> topics = snap.data;
          return Scaffold(
            drawer: TopicDrawer(),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Topics' , style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black), ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.userCircle,
                        color:Colors.black),
                    iconSize: 30,
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                  )
                  /*Column(
                    children: [
                      Text('Quiz Score', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black26),),
                      Text(report.total.toString() , style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),  ),
                    ],
                  ),*/
                ],
              ),
             /* actions: [

              ],*/
            ),
            body: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20.0),
                  crossAxisSpacing: 10.0,
                  crossAxisCount: 2,
                  children: topics.map((topic) => TopicItem(topic: topic)).toList(),
                ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}

class TopicItem extends StatelessWidget {
  final Topic topic;
  const TopicItem({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: topic.img,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => TopicScreen(topic: topic),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Image.asset(
                    'assets/${topic.img}',
                    fit: BoxFit.contain,

                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          topic.title,
                          style: TextStyle(
                              height: 1.5, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ),
                    Icon(Icons.navigate_next, color: Colors.black38),// Text(topic.description)
                  ],
                ),
                // )
                TopicProgress(topic: topic),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopicScreen extends StatelessWidget {
  final Topic topic;

  TopicScreen({this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffBFD9D7),
      ),
      body: ListView(children: [
        Hero(
          tag: topic.img,
            child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 20.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Center(child: Image.asset('assets/${topic.img}',)),
                ))

        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            topic.title,
            style:
            TextStyle(height: 2, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        QuizList(topic: topic)
      ]),
    );
  }
}

class QuizList extends StatelessWidget {
  final Topic topic;
  QuizList({Key key, this.topic});

  @override
  Widget build(BuildContext context) {

    return Column(
        children: topic.quizzes.map((quiz) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => QuizScreen(quizId: quiz.id),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    quiz.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    quiz.description,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  leading: QuizBadge(topic: topic, quizId: quiz.id),
                ),
              ),
            ),
          );
        }).toList());
  }
}

class TopicDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xffBFD9D7)),
            child: Image(
                image: ExactAssetImage("assets/logo.jpg"),
                height: 200,
                width: 200),
          ),
              CostumListTile(Icons.person,'Profile',()=>{Navigator.pushNamed(context, '/profile'),}),
              CostumListTile(Icons.lightbulb_outline,'About',()=>{Navigator.pushNamed(context, '/about')}),
              CostumListTile(Icons.lock,'Log Out', () async {
                await _auth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }),
        ],
      ),
    );
  }
}

class CostumListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CostumListTile(this.icon,this.text,this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                        child: Text(text, style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),)),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),


        ),
      ),
    );
  }
}

