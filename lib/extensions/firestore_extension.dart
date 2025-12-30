import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension UniqueFieldChecker on CollectionReference {
  Future<void> checkUniqueField({
    required String field,
    required String value,
    required String uid,
  }) async {
    final query = await where(field, isEqualTo: value).limit(1).get();

    if (query.docs.isNotEmpty && query.docs.first.id != uid) {
      throw Exception("$field sudah digunakan");
    }
  }
}

extension TimeAgoExtension on DateTime {
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 1) return "baru saja";
    if (diff.inHours < 1) return "${diff.inMinutes} menit lalu";
    if (diff.inHours < 24) return "${diff.inHours} jam lalu";
    return "${diff.inDays} hari lalu";
  }
}

extension Base64ImageExtension on String? {
  ImageProvider toImageProvider({
    ImageProvider fallback = const AssetImage('assets/images/default-ava.png'),
  }) {
    if (this == null || this!.isEmpty) {
      return fallback;
    }

    try {
      print("load");
      return MemoryImage(base64Decode(this!));
    } catch (_) {
      return fallback;
    }
  }
}

extension DateTimeExtension on DateTime? {
  String toFormattedDate({String fallback = '-'}) {
    if (this == null) return fallback;

    final date = this!;
    final day = date.day;

    String suffix = 'th';
    if (!(day >= 11 && day <= 13)) {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
      }
    }

    final monthYear = DateFormat('MMM yyyy').format(date);
    return '$day$suffix $monthYear';
  }
}
