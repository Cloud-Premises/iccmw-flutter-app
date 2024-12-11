// lib/features/social_media_page/presentation/widgets/social_media_widget.dart

import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iccmw/features/social_media_page/presentation/pages/qr_code_page.dart'; // Update with your actual package path

class SocialMediaWidget extends StatefulWidget {
  final String title;
  final String description;
  final String socialMediaIcon;
  final String socialMediaUrl;
  final String qrImageUrl;

  const SocialMediaWidget({
    super.key,
    required this.title,
    required this.description,
    required this.qrImageUrl,
    required this.socialMediaIcon,
    required this.socialMediaUrl,
  });

  @override
  State<SocialMediaWidget> createState() => _SocialMediaWidgetState();
}

class _SocialMediaWidgetState extends State<SocialMediaWidget> {
  Future<void> _launchURL() async {
    final Uri url = Uri.parse(widget.socialMediaUrl);
    if (!await launchUrl(url)) {
      throw 'Could not launch ${widget.socialMediaUrl}';
    }
  }

  void _navigateToQRCodePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodePage(qrImageUrl: widget.qrImageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        // color: Colors.green,
        color: listTileColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 4,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  widget.description != ''
                      ? SizedBox(height: 5)
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                  const SizedBox(height: 5),
                  widget.description != ''
                      ? Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          maxLines: 17,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                ],
              ),
            ),
            IconButton(
              icon: Image.asset(
                widget.socialMediaIcon,
                color: Colors.white,
                width: 32,
              ),
              iconSize: 32,
              onPressed: _launchURL, // Opens the social media URL
            ),
            IconButton(
              onPressed: _navigateToQRCodePage, // Navigates to QR code page
              icon: Icon(
                Icons.qr_code_2,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
