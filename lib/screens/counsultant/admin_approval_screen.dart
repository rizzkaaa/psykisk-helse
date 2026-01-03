import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_project/models/counsultant_model.dart';
import 'package:uas_project/screens/counsultant/card_request.dart';
import 'package:uas_project/services/counsultant_service.dart';

class AdminApprovalScreen extends StatefulWidget {
  const AdminApprovalScreen({super.key});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  final CounsultantService _counsultantService = CounsultantService();
  late Future<List<CounsultantModel>> _requestData;

  @override
  void initState() {
    super.initState();
    _requestData = _counsultantService.getAllRequest();
  }

  void _reloadData() {
    setState(() {
      _requestData = _counsultantService.getAllRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A7863),
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
      body: Column(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.assignment_ind,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Consultant Approval",
                      style: GoogleFonts.modernAntiqua(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF90AB8B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: FutureBuilder(
                future: _requestData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error Fetch Data: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No consultant registrations yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  } else {
                    final requests = snapshot.data!;

                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        print(request.idUser);
                        return CardRequest(
                          request: request,
                          reloadData: _reloadData,
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
