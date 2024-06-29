import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_friends/classes/assignmentClass.dart';
import 'package:robo_friends/classes/draftClass.dart';
import '../../../classes/timeString.dart';
import '../../../classes/neonButton.dart';
import '../navigator/draftPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          overflow: TextOverflow.fade,
          'Profile',
          style: GoogleFonts.inter(
            fontSize: kToolbarHeight * .65,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        // top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xffEFEFEF),
                      border: Border.all(
                        color: const Color(0xffA0A0A0),
                        width: 6,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/idea.png',
                        width: kToolbarHeight * 2.5,
                        height: kToolbarHeight * 2.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'John Doe\n',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                            TextSpan(
                                text: 'user@example.com',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                )),
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
