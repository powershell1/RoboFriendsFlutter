import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_friends/classes/draftClass.dart';
import 'package:robo_friends/main.dart';
import 'package:robo_friends/pages/inside/scaffoldTemplate.dart';
import 'package:badges/badges.dart' as badges;

import '../../../classes/assignmentClass.dart';
import '../../../classes/timeString.dart';

class DraftPage extends StatefulWidget {
  const DraftPage({super.key});

  @override
  State<StatefulWidget> createState() => _DraftPageState();
}

class DraftListsBuilder extends StatelessWidget {
  final void Function(Draft draft)? onDraft;
  final Assignment? linkedAssignment;

  const DraftListsBuilder(this.onDraft, {super.key, this.linkedAssignment});

  Widget buildChild(Draft draft) {
    String title = draft.title;
    Assignment? assignment = draft.assignment;
    return badges.Badge(
      showBadge: assignment == linkedAssignment && assignment != null,
      badgeAnimation: const badges.BadgeAnimation.slide(toAnimate: false),
      badgeContent: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.assignment,
          color: Colors.white,
          size: 15,
        ),
      ),
      badgeStyle: badges.BadgeStyle(
        shape: badges.BadgeShape.instagram,
        badgeColor: Colors.orange,
        padding: const EdgeInsets.all(5.5),
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xffEFEFEF),
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: InkWell(
            onTap: onDraft != null ? () => onDraft!(draft) : null,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        color: const Color(0xff131313),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (assignment != null)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '${dateToString(assignment.due)} left',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xff131313).withAlpha(200),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Draft>>(
      stream: DraftList.draftList.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (Draft draft in snapshot.data!) ...[
                  const SizedBox(height: 12),
                  buildChild(draft),
                ],
                const SizedBox(height: kToolbarHeight * 1.5),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _DraftPageState extends State<DraftPage> {
  Future openDialog() {
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xffd7d7d7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: Text(
            'New Draft',
            /*
            style: GoogleFonts.inter(
              color: const Color(0xff131313),
              fontWeight: FontWeight.bold,
            ),
             */
          ),
          contentPadding: const EdgeInsets.only(left: 24, right: 24),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'draft title',
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.blueAccent[100]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Draft? fidDraft(String title) =>
                    DraftList.draftList.stream.valueOrNull!
                        .safeFirstWhere((draft) => draft.title == title);
                if (controller.text.isNotEmpty &&
                    fidDraft(controller.text) == null) {
                  DraftList.addDraft(
                      Draft(title: controller.text, content: '{}'));
                }
              },
              child: const Text('Add'),
                  // style: TextStyle(
                  //     color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.red[100]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                /*
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                 */
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InsideTemplate(
      title: 'Draft',
      body: Container(
        color: const Color(0xffEFEFEF),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 32, top: 8, right: 32),
          child: DraftListsBuilder(
            (Draft draft) {
              Navigator.pushNamed(
                context,
                '/context/code_ide',
                arguments: {
                  'title': draft.title,
                  'content': draft.content,
                },
              );
            },
          ),
        ),
      ),
      navigationBar: ENavigationBar.draft,
      actions: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(right: kToolbarHeight / 1.75),
          child: IconButton(
              onPressed: openDialog,
              icon: const Icon(
                size: 30,
                Icons.add,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
