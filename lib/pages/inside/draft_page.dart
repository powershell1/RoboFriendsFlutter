import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_friends/external/draft_sys.dart';
import 'package:robo_friends/main.dart';
import 'package:robo_friends/pages/inside/inside_template.dart';
import 'package:badges/badges.dart' as badges;

class DraftPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DraftPageState();
}

class DraftListsBuilder extends StatelessWidget {
  final void Function(Draft draft)? onDraft;

  const DraftListsBuilder(this.onDraft, {super.key});

  String dateToString(DateTime date) {
    if (date.year > 1970) {
      return '${date.year - 1970} year(s) left';
    } else if (date.month > 1) {
      return '${date.month - 1} month(s) left';
    } else if (date.day > 1) {
      return '${date.day - 1} day(s) left';
    } else if (date.hour > 7) {
      return '${date.hour - 7} hour(s) left';
    } else if (date.minute > 0) {
      return '${date.minute} minute(s) left';
    } else if (date.second > 0) {
      return '${date.second} second(s) left';
    }
    return 'Due date passed';
  }

  Widget buildChild(Draft draft) {
    String title = draft.title;
    DateTime? date = draft.date;
    DateTime now = DateTime.now();
    DateTime left = DateTime.fromMillisecondsSinceEpoch(
        ((date?.millisecondsSinceEpoch ?? 0) - now.millisecondsSinceEpoch) *
            1000);
    return ClipRRect(
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
                if (date != null)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      dateToString(left),
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
        return Container();
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
            style: GoogleFonts.inter(
              color: const Color(0xff131313),
              fontWeight: FontWeight.bold,
            ),
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
              child: const Text('Add',
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
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
        Transform(
          // you can forcefully translate values left side using Transform
          transform: Matrix4.translationValues(
              -kToolbarHeight / 4, kToolbarHeight / 2, 0),
          child: IconButton(
              onPressed: openDialog,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
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
