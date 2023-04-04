import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ActivityScreen());
  }
}

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          activityTranscript("กิจกรรมรับน้องใหม่", 3, "ทั่วไป"),
          activityTranscript("บริจาคเลือด", 3, "จิตอาสา"),
          activityTranscript("กิจกรรมกีฬาสี", 3, "ทั่วไป"),
          activityTranscript("กิจกรรมฟังธรรม", 3, "ธรรมะ"),
          activityTranscript("กิจกรรมจัดเก็บหนังสือห้องสมุด", 3, "จิตอาสา")
        ],
      ),
    );
  }

  Widget activityTranscript(activityName, activityHour, activityType){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpandablePanel(
            header: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${activityName}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${activityHour} Hours", style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            collapsed: Text(
              "${activityType}",
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            expanded: Column(
              children: [
                Text(
                  "เวลา 9.00-20.00 น.",
                  softWrap: true,
                ),
                Text(
                  "สถานที่ ลานกิจกรรม",
                  softWrap: true,
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}