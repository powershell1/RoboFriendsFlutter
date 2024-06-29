import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_friends/classes/neonButton.dart';
import 'package:robo_friends/main.dart';

class TestContent extends StatefulWidget {
  final int testId;

  const TestContent({Key? key, required this.testId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestContent();
}

class TestData {
  final String name;
  final String code;
  final int? score;

  TestData(this.name, this.code, {this.score});
}

class FormContent extends StatefulWidget {
  final int correct;
  final List<RadioModel> choice;

  const FormContent({Key? key, required this.choice, required this.correct})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FormContent();
  }
}

class _FormContent extends State<FormContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 40,
      child: Column(
        children: <Widget>[
          Text("1. Which sensor of the following code utilize?",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 10),
          const Image(
            fit: BoxFit.contain,
            height: 250,
            image: AssetImage("assets/lessons/pre_basic/Content1.jpg"),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < widget.choice.length; i++)
            InkWell(
              splashColor: Colors.black.withAlpha(30),
              onTap: () {
                setState(() {
                  for (var element in widget.choice) {
                    element.isSelected = false;
                  }
                  widget.choice[i].isSelected = true;
                });
              },
              child: RadioItem(widget.choice[i]),
            ),
        ],
      ),
    );
  }
}

class _TestContent extends State<TestContent> {
  List<TestData> lists = [
    TestData("Pre Basic Control", "print('Hello World')"),
    TestData("Post Basic Control", "print('Hello World')", score: 10),
    TestData("End Basic Control", "print('Hello World')", score: 10),
  ];
  List<RadioModel> choice = [
    RadioModel(false, "A", "LED, Servo"),
    RadioModel(false, "B", "Ultrasonic, Buzzer"),
    RadioModel(false, "C", "Motor, Ultrasonic"),
    RadioModel(false, "D", "LED, Buzzer"),
  ];

  /*
  List<String> names = ["Pre Basic Control", "Post Basic Control", "End Basic Control"];
  Map<String, dynamic> testContent = {};
   */

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    TestData data = lists[widget.testId];
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(data.name,
            style: GoogleFonts.inter(
              fontSize: kDefaultFontSize * 1.75,
              fontWeight: FontWeight.bold,
            )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: SizedBox(
            width: width - 40,
            child: const Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FormContent(
                  correct: 0,
                  choice: choice,
                ),
                const SizedBox(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColorFiltered(
                      colorFilter: true
                          ? const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation,
                            )
                          : const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.multiply,
                            ),
                      child: NeonButtonWidget(
                        text: "Submit",
                        onPressed: () {
                          print(choice
                              .safeFirstWhere((element) => element.isSelected)
                              ?.text);
                        },
                        neon: false,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  const RadioItem(this._item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(2.0)),
            ),
            child: Center(
              child: Text(_item.buttonText,
                  style: TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Text(_item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}
