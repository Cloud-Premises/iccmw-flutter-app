import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/services_page/presentation/pages/service_detail_page.dart';

class ServicesListtileWidget extends StatefulWidget {
  final String serviceTitle;
  final int serviceId;
  const ServicesListtileWidget(
      {super.key, required this.serviceTitle, required this.serviceId});

  @override
  State<ServicesListtileWidget> createState() => _ServicesListtileWidgetState();
}

class _ServicesListtileWidgetState extends State<ServicesListtileWidget> {
  void _handleTileTap() {
    // Navigate to the ServiceDetailPage when the tile is tapped
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailPage(serviceId: widget.serviceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: listTileColor,
        borderRadius: BorderRadius.circular(12), // Set the radius value
      ),
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: ListTile(
        title: Text(
          widget.serviceTitle,
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
