import 'package:flutter/material.dart';

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  donwloading,
  downloaded,
}

@immutable
class DownloadButton extends StatefulWidget {
  const DownloadButton({
    Key? key,
    required this.status,
    this.transitionDuration = const Duration(milliseconds: 5000),
  }) : super(key: key);

  final DownloadStatus status;
  final Duration transitionDuration;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
