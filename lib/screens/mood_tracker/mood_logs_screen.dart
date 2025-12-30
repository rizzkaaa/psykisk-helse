import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:lottie/lottie.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/mood_model.dart';
import 'package:uas_project/services/mood_tracker_service.dart';

class MoodLogsScreen extends StatefulWidget {
  final String idUser;
  const MoodLogsScreen({super.key, required this.idUser});

  @override
  State<MoodLogsScreen> createState() => _MoodLogsScreenState();
}

class _MoodLogsScreenState extends State<MoodLogsScreen> {
  final MoodTrackerService _moodTrackerService = MoodTrackerService();
  late Future<List<MoodModel>> logsData;

  @override
  void initState() {
    super.initState();
    logsData = _moodTrackerService.fetchMoodByUser(widget.idUser);
  }

  void _showLogDetail(MoodModel log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFEBF4DD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Lottie.asset(
                "assets/animation/${log.indicatorLottie}",
                height: 80,
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    log.indicatorLabel,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "- ${log.createdAt.toFormattedDate()}",
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                 child:  Text(
                    log.note != null && log.note!.isNotEmpty
                        ? log.note!
                        : _moodTrackerService.moodData[log
                              .indicatorScore]['text']!,
                    style: GoogleFonts.modernAntiqua(
                      color: Color(0xFF5C8374),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  children: log.answer.entries.map((entry) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.modernAntiqua(
                            color: Color(0xFF5C8374),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          entry.value,
                          style: GoogleFonts.bricolageGrotesque(
                            color: Color(0xFF5C8374),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: logsData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "There's no mood log",
              style: TextStyle(color: Colors.black),
            ),
          );
        } else {
          final logs = snapshot.data!;
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return GestureDetector(
                onTap: () => _showLogDetail(log),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),

                  child: ListTile(
                    leading: Lottie.asset(
                      "assets/animation/${log.indicatorLottie}",
                      height: 40,
                    ),

                    title: Text(
                      log.indicatorLabel,
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5C8374),
                      ),
                    ),
                    subtitle: Text(
                      log.createdAt!.toFormattedDate(),
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
