import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:robo_friends/classes/assignmentClass.dart';
import 'package:robo_friends/classes/draftClass.dart';
import 'package:uuid/uuid.dart';
import '../../../classes/authentication.dart';
import '../../../classes/profileClass.dart';
import '../../../classes/timeString.dart';
import '../../../classes/neonButton.dart';
import '../../../main.dart';
import '../navigator/draftPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final Uint8List imageBytes = await image.readAsBytes();
      Profile profile = AuthExternal.profileStream.value!;
      String newFile = '${const Uuid().v4()}.${image.name.split('.').last}';
      Reference folder = storage.ref('profile');
      await folder.child(newFile).putData(imageBytes);
      FirebaseFirestore.instance
          .collection('users')
          .doc(profile.fullNode['uid'])
          .update({
        'image': newFile,
      });
      folder
          .child(AuthExternal.profileStream.value!.fullNode['image'])
          .delete();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

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
              StreamBuilder<Profile?>(
                stream: AuthExternal.profileStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
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
                          child: GestureDetector(
                            onTap: pickImage,
                            child: ClipOval(
                              child: Image.memory(
                                snapshot.data!.image!,
                                width: kToolbarHeight * 2.5,
                                height: kToolbarHeight * 2.5,
                                fit: BoxFit.cover,
                              ),
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
                                      text: '${snapshot.data!.fullName}\n',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                  TextSpan(
                                      text: snapshot.data!.mail,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      )),
                                ],
                              )),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: NeonButtonWidget(
                  onPressed: () => AuthExternal.logout(context),
                  text: 'Logout',
                  gradientStart: const Color(0xffC04848),
                  gradientEnd: const Color(0xff480048),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
