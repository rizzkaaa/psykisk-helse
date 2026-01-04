import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/models/post_model.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/screens/community/card_post.dart';
import 'package:uas_project/screens/community/card_user.dart';
import 'package:uas_project/services/community_service.dart';
import 'package:uas_project/widgets/search_field.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

enum CommunityContent { posts, users }

class _CommunityScreenState extends State<CommunityScreen> {
  final CommunityService _communityService = CommunityService();
  late Stream<List<PostModel>> postsData;
  final AuthController _userController = AuthController();
  late Future<List<UserModel>> userData;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  CommunityContent activeContent = CommunityContent.posts;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _loadContent() {
    setState(() {
      if (_searchQuery.isEmpty) {
        activeContent = CommunityContent.posts;
        postsData = _communityService.getPostsStream();
      } else {
        activeContent = CommunityContent.users;
        userData = _userController.searchUser(_searchQuery);
      }
    });
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    setState(() {
      _searchQuery = query;
    });
    print(_searchQuery);
    _loadContent();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
    _loadContent();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reloadData() {
    setState(() {
      postsData = _communityService.getPostsStream();
    });
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
                  onPressed: _reloadData,
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
              child: SearchField(
                onSubmitted: (value) => _performSearch(),
                onClear: _clearSearch,
                controller: _searchController,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/createCommunity"),
        backgroundColor: Color(0xFF73a664),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContent() {
    switch (activeContent) {
      case CommunityContent.posts:
        return StreamBuilder<List<PostModel>>(
          stream: postsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("There's no post"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CardPost(post: snapshot.data![index]);
              },
            );
          },
        );

      case CommunityContent.users:
        return FutureBuilder(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("User not found"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return Padding(padding: const EdgeInsets.symmetric(horizontal: 20),child:  CardUser(user: user));
              },
            );
          },
        );
    }
  }
}
