import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitlesWid extends StatelessWidget {
  const TitlesWid({super.key, required this.Title});
  final String Title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(Title,
            style: GoogleFonts.tenorSans(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            )),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class DreamAmmountText extends StatelessWidget {
  DreamAmmountText(
      {super.key, required this.leadingText, required this.TrailingText});
  final String leadingText;
  final String TrailingText;

  @override
  Widget build(BuildContext context) {
    TextStyle? fontStyle = GoogleFonts.tenorSans(
        fontSize: 19, fontWeight: FontWeight.w500, color: Colors.white);
    return Container(
        height: 70,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Text(leadingText, style: fontStyle),
          trailing: Text("₹ ${TrailingText}", style: fontStyle),
        ));
  }
}

class OngoingTile extends StatelessWidget {
  const OngoingTile({super.key, required this.textt});
  final String textt;

  @override
  Widget build(BuildContext context) {
    return Text(textt,
        style:
            GoogleFonts.tenorSans(fontSize: 20, fontWeight: FontWeight.w500));
  }
}

// ignore: must_be_immutable
class DrawerTile extends StatelessWidget {
  DrawerTile(
      {super.key,
      required this.onTap,
      required this.iconn,
      required this.texxt,
      this.colrr});
  Function()? onTap;
  final IconData iconn;
  final String texxt;
  Color? colrr;
  @override
  Widget build(BuildContext context) {
    Color BlackColor = Colors.black;
    return ListTile(
      onTap: onTap,
      leading: Icon(iconn, color: colrr ?? BlackColor),
      title: Text(texxt,
          style: GoogleFonts.tenorSans(
            color: colrr ?? BlackColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          )),
    );
  }
}

// ignore: must_be_immutable
class SettingsTile extends StatelessWidget {
  SettingsTile(
      {super.key,
      required this.icon,
      required this.text,
      this.colors,
      required this.onTap});

  final IconData icon;
  final String text;
  Color? colors;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    Color black = Colors.black;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 22, color: colors ?? black),
      title: Text(text,
          style: GoogleFonts.tenorSans(
            color: colors ?? black,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          )),
    );
  }
}
