import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:uas_project/screens/psychology_test/card_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class PsychologyTestList extends StatelessWidget {
  const PsychologyTestList({super.key});

  Future<List<dynamic>> _loadData() async {
    final String response = await rootBundle.loadString(
      'assets/data/psychology_test.json',
    );
    return json.decode(response)['tests'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4DD),
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
            child: IconButton(
              icon: const Icon(Icons.reply, color: Color(0xFF73a664)),
              onPressed: () => Navigator.pop(context),
              tooltip: "Back",
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
                    const Icon(Icons.psychology, color: Colors.white, size: 40),
                    const SizedBox(width: 8),
                    Text(
                      "Psychology Test",
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
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF73a664)),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Failed: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("There's no data"));
                } else {
                  final tests = snapshot.data!;
                  return ListView.builder(
                    itemCount: tests.length,
                    itemBuilder: (context, index) {
                      final test = tests[index];
                      return CardList(test: test);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
