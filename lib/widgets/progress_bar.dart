import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class ProgressWid extends StatefulWidget {
  ProgressWid(
      {super.key,
      required this.radiusValue,
      this.percentageValue,
      required this.fontValue,
      required this.textColor,
      this.lineWidth});
  final double radiusValue;
  double? percentageValue;
  final double fontValue;
  final Color textColor;
  double? lineWidth;

  @override
  State<ProgressWid> createState() => _ProgressWidState();
}

class _ProgressWidState extends State<ProgressWid> {
  @override
  void initState() {
    if (widget.percentageValue! > 1.0) {
      widget.percentageValue = 1.0;
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Color.fromRGBO(69, 138, 0, 0.842),
      radius: widget.radiusValue,
      animationDuration: 2000,
      lineWidth: widget.lineWidth ?? 15.0,
      animation: true,
      percent: widget.percentageValue!,
      center: Text("${widget.percentageValue! * 100}%",
          style: GoogleFonts.prompt(
              color: widget.textColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.fontValue)),
    );
  }
}
