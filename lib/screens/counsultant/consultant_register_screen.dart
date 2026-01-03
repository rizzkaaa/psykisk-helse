import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/services/counsultant_service.dart';

class ConsultantRegisterScreen extends StatefulWidget {
  const ConsultantRegisterScreen({super.key});

  @override
  State<ConsultantRegisterScreen> createState() =>
      _ConsultantRegisterScreenState();
}

class _ConsultantRegisterScreenState extends State<ConsultantRegisterScreen> {
  final CounsultantService _counsultantService = CounsultantService();
  final _formKey = GlobalKey<FormState>();
  final _spesialisCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();

  File? _ppd;
  File? _strp;
  File? _sipp;

  bool _loading = false;
  bool _showDocs = false;

  Future<File?> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      try {
        await _counsultantService.validateFileSize(file, 300);
        return file;
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    return null;
  }

  // ================= SUBMIT =================
  Future<void> _submit({required String idUser}) async {
    if (!_formKey.currentState!.validate() ||
        _ppd == null ||
        _strp == null ||
        _sipp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields & documents')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final ppdTo64 = await _counsultantService.pdfToBase64(_ppd!);
      final sippTo64 = await _counsultantService.pdfToBase64(_sipp!);
      final strpTo64 = await _counsultantService.pdfToBase64(_strp!);

      await _counsultantService.aadRequest(
        idUser: idUser,
        spesialis: _spesialisCtrl.text,
        availableTime: _timeCtrl.text,
        ppd: ppdTo64,
        sipp: sippTo64,
        strp: strpTo64,
        whatsappNo: _whatsappCtrl.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registration submitted')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
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
              ],
            ),
          ),
        ],
      ),
      body: auth.userData == null
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
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
                            "Register as Consultant",
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
                    padding: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF90AB8B),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _input(_spesialisCtrl, 'Specialization'),
                            _input(
                              _timeCtrl,
                              'Available Time',
                              hint: '08.00 - 17.00',
                            ),
                            _input(
                              _whatsappCtrl,
                              'WhatsApp Number',
                              keyboard: TextInputType.phone,
                            ),

                            const SizedBox(height: 18),

                            // TOGGLE DOCS
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _showDocs = !_showDocs),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEFE0),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.verified_user),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        'Upload Verification Documents',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      _showDocs
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if (_showDocs) ...[
                              const SizedBox(height: 14),
                              _docItem(
                                'Professional Psychologist Degree',
                                _ppd,
                                () async {
                                  final f = await _pickPdf();
                                  if (f != null) setState(() => _ppd = f);
                                },
                              ),
                              _docItem(
                                'Psychologist Registration Certificate (STRP)',
                                _strp,
                                () async {
                                  final f = await _pickPdf();
                                  if (f != null) setState(() => _strp = f);
                                },
                              ),
                              _docItem(
                                'Psychologist Practice License (SIPP)',
                                _sipp,
                                () async {
                                  final f = await _pickPdf();
                                  if (f != null) setState(() => _sipp = f);
                                },
                              ),
                            ],

                            const SizedBox(height: 30),

                            // SUBMIT
                            GestureDetector(
                              onTap: () =>
                                  _submit(idUser: auth.userData!.docId!),
                              child: Container(
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF7FAE95),
                                      Color(0xFF6F8F7A),
                                    ],
                                  ),
                                ),
                                child: _loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Submit Registration',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // ================= INPUT =================
  Widget _input(
    TextEditingController c,
    String label, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: c,
      keyboardType: keyboard,
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        label: Text(
          label,
          style: GoogleFonts.bricolageGrotesque(color: Colors.black54),
        ),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFEEEFE0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );

  // ================= DOC ITEM =================
  Widget _docItem(String title, File? file, VoidCallback onUpload) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFEEEFE0),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                file == null ? 'Not uploaded' : 'Uploaded',
                style: TextStyle(
                  fontSize: 12,
                  color: file == null ? Colors.grey : Colors.green,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onUpload,
          icon: Icon(
            file == null ? Icons.upload_file : Icons.check_circle,
            color: file == null ? Colors.black54 : Colors.green,
            size: 28,
          ),
        ),
      ],
    ),
  );
}
