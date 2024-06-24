import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../external/draft_sys.dart';
import '../outside/widget/neon_button.dart';
import 'draft_page.dart';

class AssignmentPage extends StatefulWidget {
  final String? title;

  const AssignmentPage({super.key, this.title});

  @override
  State<StatefulWidget> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  Draft? draftCache;

  void attachDraft() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          clipBehavior: Clip.hardEdge,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topLeft,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Color(0xffEFEFEF),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 32, top: 8, right: 32),
            child: DraftListsBuilder((Draft draft) {
              setState(() {
                draftCache = draftCache == draft ? null : draft;
              });
              Navigator.pop(context);
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.title ?? 'Assignment Page',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildHeader('Due', 'within 2 days'),
                const SizedBox(height: 4),
                buildHeader('Instruction', 'make ROBOFriend blink for 3 times.',
                    color: const Color(0xff967650)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Material(
                    color: Colors.grey[100],
                    child: InkWell(
                      onTap: attachDraft,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Wrap(
                          children: [
                            const Icon(Icons.attach_file),
                            const SizedBox(width: 8),
                            Text(
                              'Attach Draft',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ColorFiltered(
                  colorFilter: draftCache == null
                      ? const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        )
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: NeonButtonWidget(
                    text: "Submit Assignment",
                    neon: false,
                    onPressed: () {
                      if (draftCache == null) return;
                      print("Submit");
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(String title, String child, {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: color ?? const Color(0xff509663),
          ),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            child,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
