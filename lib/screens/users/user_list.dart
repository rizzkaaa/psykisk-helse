import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/screens/users/user_card.dart';
import 'package:uas_project/widgets/search_field.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final AuthController _userController = AuthController();
  late Future<List<UserModel>> _usersData;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _usersData = _userController.fetchAllUser();
      } else {
        _usersData = _userController.searchUser(_searchQuery);
      }
    });
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    setState(() {
      _searchQuery = query;
    });
    _loadUser();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
    _loadUser();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reloadData() {
    setState(() {
      _usersData = _userController.fetchAllUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFEBF4DD),
      appBar: AppBar(
        backgroundColor: Color(0xFF73a664),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.group, color: Colors.white, size: 40),
            const SizedBox(width: 8),
            Text(
              "User List",
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
                  onPressed: () => Navigator.pushNamed(context, "/homeScreen"),
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
      body: auth.userData == null
          ? Center(child: CircularProgressIndicator(color: Color(0xFF73a664)))
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: inset.BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
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

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: FutureBuilder(
                      future: _usersData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error Fetch Data: ${snapshot.error}"),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "No user yet",
                              style: TextStyle(color: Color(0xFF73a664)),
                            ),
                          );
                        } else {
                          final users = snapshot.data!;
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return UserCard(
                                user: user,
                                currentUser: auth.userData!,
                                onConfirmAction: () async {
                                  Navigator.pop(context);
                                  await _userController.setAdmin(
                                    user.role == 'user',
                                    user.docId!,
                                  );
                                  _loadUser();
                                },
                                onConfirmDelete: () async {
                                  Navigator.pop(context);
                                  await _userController.deleteAcc(user.docId!);
                                  _loadUser();
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
