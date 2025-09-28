import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sabeelapp/data/models/verse_model.dart';

class VerseCard extends StatelessWidget {
  final Verse verse;
  const VerseCard({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3E6088).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1EAEDB).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              verse.verseNumber.toString(),
              style: const TextStyle(
                color: Color(0xFF1EAEDB),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                verse.textUthmani,
                textAlign: TextAlign.right,
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 28,
                  height: 2.8,
                ),
              ),
            ),
          ),
          // const SizedBox(width: 16),
          // SvgPicture.asset(
          //   'assets/icons/bookmark.svg',
          //   width: 24,
          //   height: 24,
          //   colorFilter: ColorFilter.mode(
          //     Colors.white.withOpacity(0.7),
          //     BlendMode.srcIn,
          //   ),
          // ),
        ],
      ),
    );
  }
}
