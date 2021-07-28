import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ExampleCupertinoDownloadButton(),
  ));
}

@immutable
class ExampleCupertinoDownloadButton extends StatefulWidget {
  const ExampleCupertinoDownloadButton({Key? key}) : super(key: key);

  @override
  _ExampleCupertinoDownloadButtonState createState() =>
      _ExampleCupertinoDownloadButtonState();
}

class _ExampleCupertinoDownloadButtonState
    extends State<ExampleCupertinoDownloadButton> {
  late final DownloadController _downloadController;

  @override
  void initState() {
    super.initState();
    _downloadController =
        SimulatedDownloadController(onOpenDownload: _openDownload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test download'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Here we go"),
            SizedBox(
              width: 80,
              //height: 30,
              child: AnimatedBuilder(
                animation: _downloadController,
                builder: (context, child) {
                  return DownloadButton(
                    status: _downloadController.downloadStatus,
                    onCancel: _downloadController.stopDownload,
                    onDownload: _downloadController.startDownload,
                    onOpen: _downloadController.openDownload,
                    progress: _downloadController.progress,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDownload() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Open App'),
      ),
    );
  }
}

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  donwloading,
  downloaded,
}

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;
  double get progress;

  void startDownload();
  void stopDownload();
  void openDownload();
}

class SimulatedDownloadController extends DownloadController
    with ChangeNotifier {
  SimulatedDownloadController(
      {DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
      double progress = 0.0,
      required VoidCallback onOpenDownload})
      : _downloadStatus = downloadStatus,
        _progress = progress,
        _onOpenDownload = onOpenDownload;

  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;
  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;
  bool _isDownloading = false;

  @override
  void startDownload() {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      _doSimulatedDownload();
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  Future<void> openDownload() async {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
      await Future<void>.delayed(const Duration(seconds: 1));
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      _isDownloading = false;
      notifyListeners();
    }
  }

  Future<void> _doSimulatedDownload() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    // Wait a second to simulate fetch time
    await Future<void>.delayed(const Duration(seconds: 1));

    // if the user choose to cancel download, stop the simulation
    if (!_isDownloading) {
      return;
    }

    // shift to the download phase
    _downloadStatus = DownloadStatus.donwloading;
    notifyListeners();

    const downloadProgressStops = [0.0, 0.15, 0.45, 0.88, 1.0];
    for (final stop in downloadProgressStops) {
      await Future<void>.delayed(const Duration(seconds: 1));
      // if the user choose to cancel download, stop the simulation
      if (!_isDownloading) {
        return;
      }

      // update progress bar
      _progress = stop;
      notifyListeners();
    }

    // wait a second to simulate a final delay
    await Future<void>.delayed(const Duration(seconds: 1));
    // if the user choose to cancel download, stop the simulation
    if (!_isDownloading) {
      return;
    }

    // shift to the downloaded phase
    _downloadStatus = DownloadStatus.downloaded;
    notifyListeners();
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    Key? key,
    required this.status,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 3000),
    this.progress = 0.0,
  }) : super(key: key);

  final DownloadStatus status;

  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;

  final Duration transitionDuration;
  final double progress;
  bool get _isDownloading => status == DownloadStatus.donwloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
        break;
      case DownloadStatus.fetchingDownload:
        // do nothing
        break;
      case DownloadStatus.donwloading:
        onCancel();
        break;
      case DownloadStatus.downloaded:
        onOpen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildButtonShape(
            child: _buildText(context),
          ),
          _buildDownloadingProgress(),
        ],
      ),
    );
  }

  Widget _buildButtonShape({
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: transitionDuration,
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

  Widget _buildText(BuildContext context) {
    final text = _isDownloaded ? 'OPEN' : 'GET';
    final opacity = _isDownloading || _isFetching ? 0.0 : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: transitionDuration,
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
        duration: transitionDuration,
        opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
        curve: Curves.ease,
        child: Stack(
          alignment: Alignment.center,
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
        tween: Tween(begin: 0.0, end: progress),
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
