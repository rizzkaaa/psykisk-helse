import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/notification_controller.dart';
import 'package:uas_project/widgets/card_notification.dart';
import 'package:uas_project/widgets/confirm_dialog.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _markAsRead();
  }

  void _markAsRead() {
    final controller = context.read<NotificationController>();
    controller.markAllAsRead();
  }

  void showMessage(Map<String, dynamic> notification) {
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

              Text(
                notification['title'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: 2,
                color: Colors.grey,
                radius: BorderRadius.circular(20),
              ),

              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  notification['message'],
                  style: GoogleFonts.modernAntiqua(
                    color: Color(0xFF5C8374),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NotificationController>();
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
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.reply, color: Color(0xFF73a664)),
                  onPressed: () => Navigator.pop(context),
                  tooltip: "Back",
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Color(0xFF73a664),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return ConfirmDialog(
                          title:
                              "Are you sure you want to delete all message?",
                          onConfirm: () async {
                            await controller.deleteAllNotification();
                          },
                        );
                      },
                    );
                  },

                  tooltip: "Clear",
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
                const Icon(Icons.notifications, color: Colors.white, size: 40),
                const SizedBox(width: 8),
                Text(
                  "Notifications",
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: controller.notifications,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "There's no notification yet",
                        style: GoogleFonts.bricolageGrotesque(
                          color: Color(0xFF73a664),
                        ),
                      ),
                    );
                  }

                  final notifications = snapshot.data!;

                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];

                      return CardNotification(
                        notification: notification,
                        onTap: () => showMessage(notification),
                        onDelete: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ConfirmDialog(
                                title:
                                    "Are you sure you want to delete this message?",
                                onConfirm: () async {
                                  Navigator.pop(context);
                                  await controller.deleteNotification(
                                    notification['id'],
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
