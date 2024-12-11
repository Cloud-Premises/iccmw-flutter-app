import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/sports_activities_page/presentation/pages/activities_detail_page.dart';

class ActivitiesListtileWidget extends StatefulWidget {
  final String sportsTitle;
  final int sportsId;
  const ActivitiesListtileWidget(
      {super.key, required this.sportsTitle, required this.sportsId});

  @override
  State<ActivitiesListtileWidget> createState() =>
      _ActivitiesListtileWidgetState();
}

class _ActivitiesListtileWidgetState extends State<ActivitiesListtileWidget> {
  void _handleTileTap() {
    // Navigate to the sports when the tile is tapped
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivitiesDetailPage(sportsId: widget.sportsId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.green,
        color: listTileColor,
        borderRadius: BorderRadius.circular(12), // Set the radius value
      ),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: ListTile(
        title: Text(
          widget.sportsTitle,
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
        ),
        onTap: _handleTileTap,
      ),
    );
  }
}
