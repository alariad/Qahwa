
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp1/shared/loading.dart';
import 'package:flutterapp1/shared/progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutterapp1/services/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class QuizState with ChangeNotifier {
  double _progress = 0;
  Option _selected;

  final PageController controller = PageController();

  get progress => _progress;
  get selected => _selected;

  set progress(double newValue) {
    _progress = newValue;
    notifyListeners();
  }

  set selected(Option newValue) {
    _selected = newValue;
    notifyListeners();
  }

  void nextPage() async {
    await controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}

class QuizScreen extends StatelessWidget {
  QuizScreen({this.quizId});
  final String quizId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState(),
      child: FutureBuilder(
        future: Document<Quiz>(path: 'quizzes/$quizId').getData(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          var state = Provider.of<QuizState>(context);
          AudioPlayer advancedPlayer = new AudioPlayer();
          AudioCache audioCache = AudioCache(fixedPlayer: advancedPlayer);// k

          if (!snap.hasData || snap.hasError) {
            return Loading();
          } else {
            Quiz quiz = snap.data;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: AnimatedProgressbar(value: state.progress),
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.times, color: Color(0xff353745) ,),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: PageView.builder(
                //builder allows to pass function to build pages based on the index.
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                // the state is the controller
                controller: state.controller,
                onPageChanged: (int idx) =>
                state.progress = (idx / (quiz.questions.length + 1)),
                itemBuilder: (BuildContext context, int idx) {
                  if (idx == 0) {
                    return StartPage(quiz: quiz);
                  } else if (idx == quiz.questions.length + 1) {
                    return CongratsPage(quiz: quiz);
                  } else {
                    return QuestionPage(question: quiz.questions[idx - 1]);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  final Quiz quiz;
  final PageController controller;
  StartPage({this.quiz, this.controller});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(quiz.title, style: Theme.of(context).textTheme.headline),
          Divider(),
          Expanded(child: Text(quiz.description)),
          Container(
            decoration: BoxDecoration(borderRadius: new BorderRadius.circular(18.0),
                boxShadow: [BoxShadow(color: Colors.grey,offset: Offset(4.0,8.0))]),
            width: 300,
            height: 45,
            child: RaisedButton(
              onPressed: state.nextPage,
              child: Text('START', style: TextStyle(color: Colors.black54, fontSize: 25,letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),),
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0)),
            ),
          ),
          SizedBox(height: 20.0,)
        ],
      ),
    );
  }
}

class CongratsPage extends StatelessWidget {
  final Quiz quiz;
  CongratsPage({this.quiz});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30.0,),
          Text(
            '${quiz.title} complete!',
            textAlign: TextAlign.center,
          ),
          Divider(),
          Container(
            width: 300,
            height: 45,
            child: RaisedButton(
              color: Color(0xff353745),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0)),
              child: Text(' continue', style: TextStyle(color: Colors.white, fontSize: 18,),),
              onPressed: () {
                _updateUserReport(quiz);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/topics',
                      (route) => false,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Database write to update report doc when complete
  Future<void> _updateUserReport(Quiz quiz) {
    return Global.reportRef.upsert(
      ({
        'total': FieldValue.increment(1),
        'topics': {
          '${quiz.topic}': FieldValue.arrayUnion([quiz.id])
        }
      }),
    );
  }
}

class QuestionPage extends StatefulWidget {
  final Question question;
  QuestionPage({this.question});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  bool Colour = false;
  Option val;
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }


  void initPlayer() {
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);
  }


  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);


    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.topLeft,
            child: Text("Translate this sentence",style: TextStyle(letterSpacing: 1.5,
                fontWeight: FontWeight.bold ,fontSize: 28)),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Text(widget.question.text,style: TextStyle(letterSpacing: 1.5,
                  fontWeight: FontWeight.bold, fontSize: 22),),
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.question.options.map((opt) {
                return Container(
                  height: 90,
                  margin: EdgeInsets.only(bottom: 8.0),
                  color: Colors.black26,
                  child: InkWell(
                    onTap: () {
                      state.selected = opt;
                      val = opt ;
                      setState(() => Colour = true);
                    },
                    child: Container(

                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          /*Icon( state.selected == opt ? FontAwesomeIcons.checkCircle : FontAwesomeIcons.circle, size: 30),*/
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                opt.value,
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],

                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: 300,
            height: 60,
            child: RaisedButton(
                color: Colour ? Color(0xff353745) : Colors.grey,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                    new BorderRadius.circular(18.0)),
                child: Text(
                  'Check',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onPressed: () async {
                  if (val.correct) {
                    audioCache.play('Correct.mp3');
                  }
                  else {audioCache.play('False.mp3');}

                  _bottomSheet(context, val, state, audioCache);

                }

                ),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }

  /// Bottom sheet shown when Question is answered
  _bottomSheet(BuildContext context, Option opt, QuizState state,AudioCache Audio) {
    bool correct = opt.correct;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(

          color: correct ? Colors.green[100] : Colors.red[100] ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(correct ? 'You are correct!' : 'Wrong answer :(',
                style: TextStyle(color: Colors.white,letterSpacing: 1.5,fontSize: 28,
                  fontWeight: FontWeight.bold),),
              SizedBox(height: 60,),
              Container(
                width: 300,
                height: 45,
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius:
                      new BorderRadius.circular(18.0)),
                  color: correct ? Colors.green : Colors.red,
                  child: Text(
                    correct ? 'Continue' : 'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    if (correct) {
                      state.nextPage();
                      Audio.play('Audio.mp3');
                    }
                    Navigator.pop(context);
                    setState(() => Colour = !Colour);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}