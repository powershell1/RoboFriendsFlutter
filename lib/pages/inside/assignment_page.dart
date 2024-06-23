import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignmentPage extends StatefulWidget {
  final String? title;

  const AssignmentPage({super.key, this.title});

  @override
  State<StatefulWidget> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildHeader('Due', 'within 2 days'),
            const SizedBox(height: 4),
            buildHeader('Instruction', 'make ROBOFriend blink for 3 times.',
                color: const Color(0xff967650)),
            const SizedBox(height: 8),
            const Text('Attach'),
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
            overflow: TextOverflow.fade,
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
