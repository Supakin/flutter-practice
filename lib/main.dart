import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matcing Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Vocabulary Matching Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int warningScore = 0;
  bool isGameOver = false;
  List<Item> questions = [];
  List<Item> answers = [];
  Item? selectingQuestion;
  Item? selectingAnswer;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame() {
    warningScore = 0;
    isGameOver = false;
    selectingQuestion = null;
    selectingAnswer = null;
    questions = [
      Item(
        engValue: "ํYellow",
        value: "สีเหลือง",
      ),
      Item(
        engValue: "Mango",
        value: "มะม่วง",
      ),
      Item(
        engValue: "Eto",
        value: "มีด",
      ),
    ];
    answers = [
      Item(
        engValue: "ํYellow",
        value: "สีเหลือง",
      ),
      Item(
        engValue: "Mango",
        value: "มะม่วง",
      ),
      Item(
        engValue: "Eto",
        value: "มีด",
      ),
    ];

    // สลับตำแหน่งของใน List
    questions.shuffle();
    answers.shuffle();
  }

  selectQuestion(Item item) {
    setState(() {
      selectingQuestion = item;
      questions.forEach((question) {
        if (question.engValue == item.engValue)
          question.selecting = true;
        else
          question.selecting = false;
      });
    });
  }

  selectAnswer(Item item) {
    setState(() {
      selectingAnswer = item;
      answers.forEach((answer) {
        if (answer.engValue == item.engValue)
          answer.selecting = true;
        else
          answer.selecting = false;
      });
    });
  }

  confirm() {
    setState(() {
      if (selectingQuestion?.value == selectingAnswer?.value) {
        questions.removeWhere(
            (element) => (element.value == selectingQuestion?.value));
        answers.removeWhere(
            (element) => (element.value == selectingAnswer?.value));
      } else {
        warningScore++;
        questions.forEach((question) {
          question.selecting = false;
        });
        answers.forEach((answer) {
          answer.selecting = false;
        });
      }
      selectingQuestion = null;
      selectingAnswer = null;

      // over game
      if (questions.length == 0 && answers.length == 0) isGameOver = true;
    });
  }

  newGame() {
    setState(() {
      initGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            // Text.rich(TextSpan(children: [
            //   TextSpan(text: "Warning Score: "),
            //   TextSpan(
            //       text: "$warningScore",
            //       style: TextStyle(
            //         color: Colors.red,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 30.0,
            //       ))
            // ])),
            if (!isGameOver)
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: Column(
                          children: questions.map((question) {
                        return Container(
                            child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: (question.selecting)
                                      ? MaterialStateProperty.all<Color>(
                                          Colors.blue)
                                      : MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  foregroundColor: (question.selecting)
                                      ? MaterialStateProperty.all<Color>(
                                          Colors.white)
                                      : MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                child: Text(question.engValue.toString()),
                                onPressed: () => {selectQuestion(question)}));
                      }).toList())),
                  Spacer(),
                  Expanded(
                      flex: 4,
                      child: Column(
                          children: answers.map((answer) {
                        return Container(
                            child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: (answer.selecting)
                                      ? MaterialStateProperty.all<Color>(
                                          Colors.green)
                                      : MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  foregroundColor: (answer.selecting)
                                      ? MaterialStateProperty.all<Color>(
                                          Colors.white)
                                      : MaterialStateProperty.all<Color>(
                                          Colors.green),
                                ),
                                child: Text(answer.value.toString()),
                                onPressed: () => {selectAnswer(answer)}));
                      }).toList())),
                ],
              ),
            if (selectingQuestion != null && selectingAnswer != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text("Confirm Matching"),
                        onPressed: () => {confirm()}),
                  )
                ],
              ),
            if (isGameOver)
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text.rich(TextSpan(
                              text: "Wowwwww !",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 40.0,
                              ))),
                          Container(child: Text("You are successed.")),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orange),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              child: Text("New Game"),
                              onPressed: () => {newGame()}),
                        ])
                  ]),
          ]),
        ));
  }
}

class Item {
  String? engValue;
  String? value;
  bool selecting;

  Item({this.engValue, this.value, this.selecting = false});
}
