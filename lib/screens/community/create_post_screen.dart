import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/services/community_service.dart';
import 'package:uas_project/widgets/unstyle_button.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  final CommunityService _communityService = CommunityService();
  String _tagController = "";

  final List<String> _tag = [
    "Emotional",
    "Sharing",
    "Support",
    "SelfCare",
    "Healing",
    "Counseling",
    "TriggerWarning",
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.userData;

    return Scaffold(
      backgroundColor: Color(0xFFEBF4DD),
      appBar: AppBar(
        backgroundColor: Color(0xFF73a664),
        leading: SizedBox(),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        actions: [
          Container(
            decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(2, 0),
                  inset: true,
                ),
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(-2, 0),
                  inset: true,
                ),
              ],
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.reply, color: Color(0xFF73a664)),
                  onPressed: () => Navigator.pop(context),
                  tooltip: "Back",
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              color: Color(0xFF73a664),
              boxShadow: [
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(2, 0),
                  inset: false,
                ),
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(-2, 0),
                  inset: false,
                ),
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(0, -2),
                  inset: true,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.create_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(width: 8),
                Text(
                  "Create New Post",
                  style: GoogleFonts.modernAntiqua(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                decoration: inset.BoxDecoration(
                  color: const Color(0xFF252A34),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    inset.BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 3,
                      offset: Offset(3, 2),
                      inset: true,
                    ),
                    inset.BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 3,
                      offset: Offset(-3, 2),
                      inset: true,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            backgroundImage: (user!.photo.toString().isNotEmpty)
                                ? user.photo.toImageProvider()
                                : AssetImage('assets/images/default-ava.png')
                                      as ImageProvider,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "@${user.username}",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      thickness: 2,
                      color: Colors.white,
                      radius: BorderRadius.circular(20),
                    ),
                    TextField(
                      controller: _postController,
                      maxLength: 300,
                      maxLines: 15,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        counterStyle: GoogleFonts.bricolageGrotesque(
                          color: Colors.white,
                        ),
                        hint: Text(
                          "What's happening?",
                          style: GoogleFonts.bricolageGrotesque(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: GoogleFonts.bricolageGrotesque(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              color: Color(0xFF73a664),
              boxShadow: [
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                  inset: true,
                ),
              ],
            ),

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Tag: ",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _tagController.isEmpty
                                ? "#General"
                                : _tagController,
                            style: GoogleFonts.bricolageGrotesque(
                              color: Color(0xFF4ece5d),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 5),
                          if (_tagController.isNotEmpty)
                            UnstyleButton(
                              onPressed: () {
                                setState(() {
                                  _tagController = "";
                                });
                              },
                              content: Icon(
                                Icons.close,
                                size: 15,
                                color: Color(0xFF73a664),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 15,
                    children: _tag.map((e) {
                      return UnstyleButton(
                        onPressed: () {
                          setState(() {
                            _tagController = "#$e";
                          });
                        },
                        content: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "#$e",
                            style: GoogleFonts.bricolageGrotesque(
                              color: Color(0xFF4ece5d),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                if (_postController.text.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: inset.BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        inset.BoxShadow(
                          color: Colors.black45.withOpacity(0.5),
                          blurRadius: 2,
                          offset: Offset(2, 0),
                          inset: true,
                        ),
                        inset.BoxShadow(
                          color: Colors.black45.withOpacity(0.5),
                          blurRadius: 2,
                          offset: Offset(-2, 0),
                          inset: true,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: UnstyleButton(
                      onPressed: () async {
                        if (_postController.text.isEmpty) return;

                        try {
                          await _communityService.addPost(
                            user.docId!,
                            user.role,
                            _postController.text.trim(),
                            _tagController.isEmpty
                                ? "#General"
                                : _tagController,
                          );
                          Navigator.pushNamed(context, "/community");
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      },
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Post",
                            style: GoogleFonts.roboto(
                              color: Color(0xFF73a664),
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.send_rounded,
                            color: Color(0xFF73a664),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
