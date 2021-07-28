import 'package:flutter/cupertino.dart';
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
    this.progress = 0.0,
  }) : super(key: key);

  final DownloadStatus status;
  final Duration transitionDuration;
  final double progress;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool get _isDownloading => widget.status == DownloadStatus.donwloading;

  bool get _isFetching => widget.status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => widget.status == DownloadStatus.downloaded;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildButtonShape(
          child: _buildText(),
        ),
        _buildDownloadingProgress(),
      ],
    );
  }

  Widget _buildButtonShape({
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: widget.transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: _isDownloading || _isFetching
          ? ShapeDecoration(
              shape: const CircleBorder(),
              color: Colors.white.withOpacity(0.0),
            )
          : const ShapeDecoration(
              shape: StadiumBorder(),
              color: CupertinoColors.lightBackgroundGray,
            ),
      child: child,
    );
  }

  Widget _buildText() {
    final text = _isDownloaded ? 'OPEN' : 'GET';
    final opacity = _isDownloading || _isFetching ? 0.0 : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: widget.transitionDuration,
        curve: Curves.ease,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.button?.copyWith(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.activeBlue,
              ),
        ),
      ),
    );
  }

  Widget _buildDownloadingProgress() {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: widget.transitionDuration,
        opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
        curve: Curves.ease,
        child: Stack(
          children: [
            _buildProgressIndicator(),
            if (_isDownloading)
              const Icon(
                Icons.stop,
                size: 14.0,
                color: CupertinoColors.activeBlue,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: widget.progress),
        duration: const Duration(milliseconds: 200),
        builder: (BuildContext context, double progress, Widget? child) {
          return CircularProgressIndicator(
            backgroundColor: _isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0.0),
            valueColor: AlwaysStoppedAnimation(
              _isFetching
                  ? CupertinoColors.lightBackgroundGray
                  : CupertinoColors.activeBlue,
            ),
            strokeWidth: 2.0,
            value: _isFetching ? null : progress,
          );
        },
      ),
    );
  }
}
