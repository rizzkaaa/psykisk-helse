import 'package:flutter/material.dart';
import 'package:uas_project/models/post_model.dart';
import 'package:uas_project/screens/community/card_post.dart';
import 'package:uas_project/services/community_service.dart';

class FavoritePostContent extends StatefulWidget {
  final bool isFavorite;
  final String idUser;
  const FavoritePostContent({
    super.key,
    required this.isFavorite,
    required this.idUser,
  });

  @override
  State<FavoritePostContent> createState() => _FavoritePostContentState();
}

class _FavoritePostContentState extends State<FavoritePostContent> {
  final CommunityService _communityService = CommunityService();
  late Stream<List<PostModel>> postsData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    if (widget.isFavorite) {
      postsData = _communityService.getLikedPosts(widget.idUser);
    } else {
      postsData = _communityService.getPostsStreamByIDuser(widget.idUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            return const Center(
              child: Text(
                "There's no post",
                style: TextStyle(color: Colors.black),
              ),
            );
          } else {
            final posts = snapshot.data!;

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return CardPost(post: post);
              },
            );
          }
        },
      ),
    );
  }
}
