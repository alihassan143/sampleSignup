import '../core.dart';

/// Toast Length
/// Only for Android Platform
enum Toast {
  /// Show Short toast for 1 sec
  LENGTH_SHORT,

  /// Show Long toast for 5 sec
  LENGTH_LONG
}

/// ToastGravity
/// Used to define the position of the Toast on the screen
enum ToastGravity {
  TOP,
  BOTTOM,
  CENTER,
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  CENTER_LEFT,
  CENTER_RIGHT,
  SNACKBAR,
  NONE
}

/// Plugin to show a toast message on screen
/// Only for android, ios and Web platforms

typedef PositionedToastBuilder = Widget Function(
    BuildContext context, Widget child);

class CustomToast {
  static final CustomToast _instance = CustomToast._internal();

  /// Prmary Constructor for CustomToast
  factory CustomToast() {
    return _instance;
  }

  /// Take users Context and saves to avariable

  CustomToast._internal();

  OverlayEntry? _entry;
  final List<_ToastEntry> _overlayQueue = [];
  Timer? _timer;
  Timer? _fadeTimer;

  /// Internal function which handles the adding
  /// the overlay to the screen
  ///
  _showOverlay() {
    if (_overlayQueue.isEmpty) {
      _entry = null;
      return;
    }

    /// To prevent exception "Looking up a deactivated widget's ancestor is unsafe."
    /// which can be thrown if context was unmounted (e.g. screen with given context was popped)
    /// TODO: revert this change when envoirment will be Flutter >= 3.7.0
    // if (context?.mounted != true) {
    //   if (kDebugMode) {
    //     print(
    //         'CustomToast: Context was unmuted, can not show ${_overlayQueue.length} toast.');
    //   }

    //   /// Need to clear queue
    //   removeQueuedCustomToasts();
    //   return; // Or maybe thrown error too
    // }

    /// Create entry only after all checks
    _ToastEntry toastEntry = _overlayQueue.removeAt(0);
    _entry = toastEntry.entry;
    NavigationService.navigatorKey.currentState!.overlay!.insert(_entry!);

    _timer = Timer(toastEntry.duration, () {
      _fadeTimer = Timer(toastEntry.fadeDuration, () {
        removeCustomToast();
      });
    });
  }

  /// If any active toast present
  /// call removeCustomToast to hide the toast immediately
  removeCustomToast() {
    _timer?.cancel();
    _fadeTimer?.cancel();
    _timer = null;
    _fadeTimer = null;
    _entry?.remove();
    _entry = null;
    _showOverlay();
  }

  /// CustomToast maintains a queue for every toast
  /// if we called showToast for 3 times we all to queue
  /// and show them one after another
  ///
  /// call removeCustomToast to hide the toast immediately
  removeQueuedCustomToasts() {
    _timer?.cancel();
    _fadeTimer?.cancel();
    _timer = null;
    _fadeTimer = null;
    _overlayQueue.clear();
    _entry?.remove();
    _entry = null;
  }

  /// showToast accepts all the required paramenters and prepares the child
  /// calls _showOverlay to display toast
  ///
  /// Paramenter [child] is requried
  /// toastDuration default is 2 seconds
  /// fadeDuration default is 350 milliseconds
  void showToast({
    required Widget child,
    PositionedToastBuilder? positionedToastBuilder,
    Duration toastDuration = const Duration(seconds: 2),
    ToastGravity? gravity,
    Duration fadeDuration = const Duration(milliseconds: 350),
    bool ignorePointer = false,
    bool isDismissable = false,
  }) {
    final context = NavigationService.navigatorKey.currentContext!;
    Widget newChild = _ToastStateFul(
        child,
        toastDuration,
        fadeDuration,
        ignorePointer,
        !isDismissable
            ? null
            : () {
                removeCustomToast();
              });

    /// Check for keyboard open
    /// If open will ignore the gravity bottom and change it to center
    if (gravity == ToastGravity.BOTTOM) {
      if (MediaQuery.of(context).viewInsets.bottom != 0) {
        gravity = ToastGravity.CENTER;
      }
    }

    OverlayEntry newEntry = OverlayEntry(builder: (context) {
      if (positionedToastBuilder != null)
        return positionedToastBuilder(context, newChild);
      return _getPostionWidgetBasedOnGravity(newChild, gravity);
    });
    _overlayQueue.add(_ToastEntry(
        entry: newEntry, duration: toastDuration, fadeDuration: fadeDuration));
    if (_timer == null) _showOverlay();
  }

  /// _getPostionWidgetBasedOnGravity generates [Positioned] [Widget]
  /// based on the gravity  [ToastGravity] provided by the user in
  /// [showToast]
  _getPostionWidgetBasedOnGravity(Widget child, ToastGravity? gravity) {
    final context = NavigationService.navigatorKey.currentContext!;
    switch (gravity) {
      case ToastGravity.TOP:
        return Positioned(top: 100.0, left: 24.0, right: 24.0, child: child);
      case ToastGravity.TOP_LEFT:
        return Positioned(top: 100.0, left: 24.0, child: child);
      case ToastGravity.TOP_RIGHT:
        return Positioned(top: 100.0, right: 24.0, child: child);
      case ToastGravity.CENTER:
        return Positioned(
            top: 50.0, bottom: 50.0, left: 24.0, right: 24.0, child: child);
      case ToastGravity.CENTER_LEFT:
        return Positioned(top: 50.0, bottom: 50.0, left: 24.0, child: child);
      case ToastGravity.CENTER_RIGHT:
        return Positioned(top: 50.0, bottom: 50.0, right: 24.0, child: child);
      case ToastGravity.BOTTOM_LEFT:
        return Positioned(bottom: 50.0, left: 24.0, child: child);
      case ToastGravity.BOTTOM_RIGHT:
        return Positioned(bottom: 50.0, right: 24.0, child: child);
      case ToastGravity.SNACKBAR:
        return Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: child);
      case ToastGravity.NONE:
        return Positioned.fill(child: child);
      case ToastGravity.BOTTOM:
      default:
        return Positioned(bottom: 50.0, left: 24.0, right: 24.0, child: child);
    }
  }
}

/// Simple builder method to create a [TransitionBuilder]
/// and for the use in MaterialApp builder method
// ignore: non_constant_identifier_names
TransitionBuilder CustomToastBuilder() {
  return (context, child) {
    return _CustomToastHolder(
      child: child!,
    );
  };
}

/// Simple StatelessWidget which holds the child
/// and creates an [Overlay] to display the toast
class _CustomToastHolder extends StatelessWidget {
  const _CustomToastHolder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            return child;
          },
        ),
      ],
    );
  }
}

/// internal class [_ToastEntry] which maintains
/// each [OverlayEntry] and [Duration] for every toast user
/// triggered
class _ToastEntry {
  final OverlayEntry entry;
  final Duration duration;
  final Duration fadeDuration;

  _ToastEntry({
    required this.entry,
    required this.duration,
    required this.fadeDuration,
  });
}

/// internal [StatefulWidget] which handles the show and hide
/// animations for [CustomToast]
class _ToastStateFul extends StatefulWidget {
  const _ToastStateFul(this.child, this.duration, this.fadeDuration,
      this.ignorePointer, this.onDismiss,
      {super.key});

  final Widget child;
  final Duration duration;
  final Duration fadeDuration;
  final bool ignorePointer;
  final VoidCallback? onDismiss;

  @override
  ToastStateFulState createState() => ToastStateFulState();
}

/// State for [_ToastStateFul]
class ToastStateFulState extends State<_ToastStateFul>
    with SingleTickerProviderStateMixin {
  /// Start the showing animations for the toast
  showIt() {
    _animationController!.forward();
  }

  /// Start the hidding animations for the toast
  hideIt() {
    _animationController!.reverse();
    _timer?.cancel();
  }

  /// Controller to start and hide the animation
  AnimationController? _animationController;
  late Animation _fadeAnimation;

  Timer? _timer;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn);
    super.initState();

    showIt();
    _timer = Timer(widget.duration, () {
      hideIt();
    });
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _animationController!.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss == null ? null : () => widget.onDismiss!(),
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        ignoring: widget.ignorePointer,
        child: FadeTransition(
          opacity: _fadeAnimation as Animation<double>,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
