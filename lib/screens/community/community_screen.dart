import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/models/post_model.dart';
import 'package:uas_project/screens/community/card_post.dart';
import 'package:uas_project/services/community_service.dart';
import 'package:uas_project/widgets/search_field.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final CommunityService _communityService = CommunityService();
  late Stream<List<PostModel>> postsData;

  @override
  void initState() {
    super.initState();
    postsData = _communityService.getPostsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4DD),
      appBar: AppBar(
        backgroundColor: Color(0xFF73a664),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.groups, color: Colors.white, size: 40),
            const SizedBox(width: 8),
            Text(
              "Community",
              style: GoogleFonts.modernAntiqua(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: false,
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

                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF73a664)),
                  onPressed: () {},
                  tooltip: "Refresh",
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: inset.BoxDecoration(
                borderRadius: BorderRadius.circular(30),
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
              child: SearchField(onPressed: () {}),
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: postsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("There's no post", style: TextStyle(color: Colors.black),));
                } else {
                  final posts = snapshot.data!;

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return CardPost(post: post,);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/createCommunity"),
        backgroundColor: Color(0xFF73a664),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
