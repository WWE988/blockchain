// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottery Ticket',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//   int totalNumber = Colors.primaries.length - 1;
  int totalNumber = 2;
  int pickedNumber = 0;
  int prizeNumber = -1;

  StreamController<int> prizeController = StreamController<int>();
  ConfettiController confettiController =
      ConfettiController(duration: Duration(seconds: 10));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "HK Lottery Ticket",
                style: TextStyle(
                  fontSize: 42,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(1.5, 1.5),
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              numberPicker(),
              SizedBox(height: 24),

              /// Expanded widget will occupy all the available space in Column/Row
              Expanded(
                child: FortuneWheel(
                  items: buildFortuneItems(pickedNumber, totalNumber),
                  onFling: () {
                    prizeNumber = Random().nextInt(totalNumber);
                    prizeController.add(prizeNumber);
                  },
                  indicators: [
                    FortuneIndicator(
                      alignment: Alignment.topCenter,
                      child: TriangleIndicator(color: Colors.white),
                    ),
                  ],
                  selected: prizeController.stream,
                  onAnimationEnd: () {
                    /// Make sure the wheel is spinned by user interaction before comparing the prize number
                    if (prizeNumber < 0) return;

                    /// Compare the prize number with the picked number
                    if ((prizeNumber + 1) == pickedNumber) {
                      /// Congrats! You won!
                      //  Text("Congratulations, you won!");
                      confettiController.play();

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Column(
                            children: [
                              Text("Congratulations, you win!"),
                            ],
                          ),
                        ),
                      );
                    } else {
                      /// Sorry, you lost!
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Column(
                            children: [
                              Text("You lose. Better luck next time!"),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.1,
              shouldLoop: false,
              colors: Colors.primaries,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.1,
              shouldLoop: false,
              colors: Colors.primaries,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.1,
              shouldLoop: false,
              colors: Colors.primaries,
            ),
          ),
        ],
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Container numberPicker() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
                offset: Offset(2, 2), blurRadius: 6, color: Colors.black54)
          ]),
      padding: EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text('Pick a number between 1 and $totalNumber:',
              style: TextStyle(fontSize: 18, color: Colors.black)),
          SizedBox(height: 16),
          numberGrids(),
        ],
      ),
    );
  }

  Widget numberGrids() {
    return GridView.builder(
      padding: EdgeInsets.all(2),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: totalNumber,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue, width: 2),
            shape: BoxShape.circle,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(90),
            color: pickedNumber - 1 == index
                ? Colors.grey[300]
                : Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => pickedNumber = index + 1),
              borderRadius: BorderRadius.circular(90),
              onHover: (hovered) {},
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<FortuneItem> buildFortuneItems(int userNumber, int total) {
    /// First, we create an empty list which should contains FortuneItem.
    List<FortuneItem> fortuneItems = [];

    /// Create a FortuneItem in each loop and adds it to the list:
    for (int i = 1; i <= total; i++) {
      /// If the selected number is equal to the current loop number,
      if (i == userNumber) {
        /// Set the style of user picked item:
        fortuneItems.add(
          FortuneItem(
            child: Text('$userNumber'),
            style: FortuneItemStyle(
              color: Colors.primaries[i % Colors.primaries.length],
              borderColor: Colors.white54,
              borderWidth: 2,
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
        );
      } else {
        /// Set the style of other items:
        fortuneItems.add(
          FortuneItem(
            child: Text('$i'),
            style: FortuneItemStyle(
              color: Colors.primaries[i % Colors.primaries.length].shade300,
              textStyle: TextStyle(color: Colors.white),
              borderColor: Colors.transparent,
            ),
          ),
        );
      }
    }
    return fortuneItems;
  }
}
