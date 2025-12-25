import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // void _showMessage() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   Text(
  //                     "sender:",
  //                     style: GoogleFonts.bricolageGrotesque(
  //                       color: Color(0xFF4A7C7E),
  //                       fontSize: 15,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 5),
  //                   Text(
  //                     "Sistem",
  //                     style: GoogleFonts.bricolageGrotesque(
  //                       color: Color(0xFF4A7C7E),
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 15,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Divider(
  //                 thickness: 2,
  //                 indent: 5,
  //                 endIndent: 5,
  //                 color: Color(0xFF252A34),
  //                 radius: BorderRadius.circular(20),
  //               ),
  //               Text(
  //                 "Message:",
  //                 style: GoogleFonts.bricolageGrotesque(
  //                   color: Color(0xFF4A7C7E),
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 15,
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 10),
  //                 child: Text(
  //                   "KADJHDF WGFHSDBHSDYUGV CDDUIFHSYDU",
  //                   style: GoogleFonts.bricolageGrotesque(
  //                     color: Color(0xFF4A7C7E),
  //                     fontSize: 15,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  bool _isOpenMessage = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  onPressed: () {},
                  tooltip: "Clear",
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
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
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
                        Icons.notifications,
                        color: Colors.white,
                        size: 40,
                      ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isOpenMessage = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      overlayColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          decoration: inset.BoxDecoration(
                            color: const Color(0xFF252A34),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
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
                                  Text(
                                    "sender:",
                                    style: GoogleFonts.bricolageGrotesque(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Sistem",
                                    style: GoogleFonts.bricolageGrotesque(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Welcome (unread)",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 20,
                          ),
                          decoration: inset.BoxDecoration(
                            boxShadow: [
                              inset.BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 3,
                                offset: Offset(3, -2),
                                inset: true,
                              ),
                              inset.BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 3,
                                offset: Offset(-3, -2),
                                inset: true,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Color(0xFFacc990),
                          ),
                          child: Text(
                            "5 menit yang lalu",
                            style: GoogleFonts.modernAntiqua(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 600),
            bottom: _isOpenMessage ? 0 : -height * 0.60,
            curve: Curves.easeInOut,
            right: 0,
            left: 0,
            child: Container(
              height: height * 0.60,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              decoration: inset.BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                  topRight: Radius.circular(70),
                ),
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
                  inset.BoxShadow(
                    color: Colors.black38.withOpacity(0.3),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                    inset: true,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    thickness: 3,
                    color: Colors.grey,
                    indent: 130,
                    endIndent: 130,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Welcome",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xFF73a664),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF73a664),
                            fontWeight: FontWeight.bold,
                          ),
                          onPressed: () {
                            setState(() {
                              _isOpenMessage = false;
                            });
                          },
                          tooltip: "Close",
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 10),
                  Divider(
                    thickness: 3,
                    color: Color(0xFF73a664),
                    radius: BorderRadius.circular(20),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Message:",
                        style: GoogleFonts.bricolageGrotesque(
                          color: Color(0xFF73a664),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        child: Text(
                          "KADJHDF WGFHSDBHSDYUGV CDDUIFHSYDU",
                          style: GoogleFonts.bricolageGrotesque(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
