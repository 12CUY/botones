import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botones deslizados con diferentes colores y bordes
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  swipeButton("Swipe to Red", const Color.fromARGB(255, 214, 192, 192), BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    
                  ), true, backgroundColor: const Color.fromARGB(255, 248, 2, 2), icon: Icons.chevron_right, ), // Rojo con ícono >> (flechas)
                  SizedBox(height: 8),
                  swipeButton("Swipe to Blue", const Color.fromARGB(248, 160, 233, 255), BorderRadius.circular(25), false), 
                  SizedBox(height: 8),
                  swipeButton("Swipe to Yellow", const Color.fromARGB(120, 133, 241, 255), BorderRadius.circular(50), true),
                  SizedBox(height: 8),
                  swipeButton("Swipe to Orange", const Color.fromARGB(144, 255, 153, 0), BorderRadius.circular(10), false, isSlim: true), 
                  SizedBox(height: 8),
                  swipeButton("Swipe to Green", Colors.green, BorderRadius.circular(15), false, isSmall: true), 
                ],
              ),
            ),
            Expanded(
              child: Center(child: Text("Wiliam Morales")),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Minha conta",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: "Meus pedidos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favoritos",
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  // Widget que integra el SwipeButton con las características específicas
  Widget swipeButton(String text, Color color, BorderRadius borderRadius, bool isLarge, {bool isSlim = false, bool isSmall = false, Color? iconColor, Color? backgroundColor, IconData? icon}) {
    return SwipeButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
      activeThumbColor: const Color.fromARGB(179, 59, 59, 59),
      inactiveThumbColor: Colors.grey,
      activeTrackColor: color,
      inactiveTrackColor: Colors.grey.shade300,
      borderRadius: borderRadius,
      width: isLarge ? 400 : (isSmall ? 150 : 300), // Ajustamos el tamaño
      height: isSlim ? 40 : (isSmall ? 40 : 50), // Ajustamos la altura
      onSwipe: () {
        print("Deslizado hacia $text");
      },
      onSwipeStart: () {
        print("Inició el deslizamiento hacia $text");
      },
      onSwipeEnd: () {
        print("Deslizamiento finalizado hacia $text");
      },
      thumb: isLarge
          ? Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.red, 
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon ?? Icons.chevron_right, // Usamos el ícono de flecha o el icono proporcionado
                color: iconColor ?? Colors.white, // Color blanco para el ícono
              ),
            )
          : null, 
    );
  }
}

enum _SwipeButtonType {
  swipe,
  expand,
}

class SwipeButton extends StatefulWidget {
  final Widget child;
  final Widget? thumb;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final EdgeInsets thumbPadding;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final EdgeInsets trackPadding;
  final BorderRadius? borderRadius;
  final double width;
  final double height;
  final bool enabled;
  final double elevationThumb;
  final double elevationTrack;
  final VoidCallback? onSwipeStart;
  final VoidCallback? onSwipe;
  final VoidCallback? onSwipeEnd;
  final _SwipeButtonType _swipeButtonType;
  final Duration duration;

  const SwipeButton({
    super.key,
    required this.child,
    this.thumb,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.thumbPadding = EdgeInsets.zero,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.trackPadding = EdgeInsets.zero,
    this.borderRadius,
    this.width = double.infinity,
    this.height = 30,
    this.enabled = true,
    this.elevationThumb = 0,
    this.elevationTrack = 0,
    this.onSwipeStart,
    this.onSwipe,
    this.onSwipeEnd,
    this.duration = const Duration(milliseconds: 250),
  })  : assert(elevationThumb >= 0.0),
        assert(elevationTrack >= 0.0),
        _swipeButtonType = _SwipeButtonType.swipe;

  const SwipeButton.expand({
    super.key,
    required this.child,
    this.thumb,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.thumbPadding = EdgeInsets.zero,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.trackPadding = EdgeInsets.zero,
    this.borderRadius,
    this.width = double.infinity,
    this.height = 50,
    this.enabled = true,
    this.elevationThumb = 0,
    this.elevationTrack = 0,
    this.onSwipeStart,
    this.onSwipe,
    this.onSwipeEnd,
    this.duration = const Duration(milliseconds: 250),
  })  : assert(elevationThumb >= 0.0),
        assert(elevationTrack >= 0.0),
        _swipeButtonType = _SwipeButtonType.expand;

  @override
  State<SwipeButton> createState() => _SwipeState();
}

class _SwipeState extends State<SwipeButton> with TickerProviderStateMixin {
  late AnimationController swipeAnimationController;
  late AnimationController expandAnimationController;

  bool swiped = false;

  @override
  void initState() {
    _initAnimationControllers();
    super.initState();
  }

  _initAnimationControllers() {
    swipeAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0,
      upperBound: 1,
      value: 0,
    );
    expandAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0,
      upperBound: 1,
      value: 0,
    );
  }

  @override
  void didUpdateWidget(covariant SwipeButton oldWidget) {
    if (oldWidget.duration != widget.duration) {
      _initAnimationControllers();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    swipeAnimationController.dispose();
    expandAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              _buildTrack(context, constraints),
              _buildThumb(context, constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTrack(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    final trackColor = widget.enabled
        ? widget.activeTrackColor ?? theme.colorScheme.surface
        : widget.inactiveTrackColor ?? theme.disabledColor;

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(150);
    final elevationTrack = widget.enabled ? widget.elevationTrack : 0.0;

    return Padding(
      padding: widget.trackPadding,
      child: Material(
        elevation: elevationTrack,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        color: trackColor,
        child: Container(
          width: constraints.maxWidth,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }

  Widget _buildThumb(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    final thumbColor = widget.enabled
        ? widget.activeThumbColor ?? theme.colorScheme.secondary
        : widget.inactiveThumbColor ?? theme.disabledColor;

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(150);

    final elevationThumb = widget.enabled ? widget.elevationThumb : 0.0;

    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;

    return AnimatedBuilder(
      animation: swipeAnimationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate((isRTL ? -1 : 1) *
                swipeAnimationController.value *
                (constraints.maxWidth - widget.height)),
          child: Container(
            padding: widget.thumbPadding,
            child: GestureDetector(
              onHorizontalDragStart: _onHorizontalDragStart,
              onHorizontalDragUpdate: (details) =>
                  _onHorizontalDragUpdate(details, constraints.maxWidth),
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Material(
                elevation: elevationThumb,
                borderRadius: borderRadius,
                color: thumbColor,
                clipBehavior: Clip.antiAlias,
                child: AnimatedBuilder(
                  animation: expandAnimationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: widget.height +
                          (expandAnimationController.value *
                              (constraints.maxWidth - widget.height)) -
                          widget.thumbPadding.horizontal,
                      height: widget.height - widget.thumbPadding.vertical,
                      child: widget.thumb ?? 
                          Icon(
                            Icons.arrow_forward,
                            color: widget.activeTrackColor ?? widget.inactiveTrackColor,
                          ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _onHorizontalDragStart(DragStartDetails details) {
    setState(() {
      swiped = false;
    });
    widget.onSwipeStart?.call();
  }

  _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    final double offset = details.primaryDelta! / (width - widget.height);

    switch (widget._swipeButtonType) {
      case _SwipeButtonType.swipe:
        if (!swiped && widget.enabled) {
          if (isRTL) {
            swipeAnimationController.value -= offset;
          } else {
            swipeAnimationController.value += offset;
          }

          if (swipeAnimationController.value == 1) {
            setState(() {
              swiped = true;
              widget.onSwipe?.call();
            });
          }
        }
        break;
      case _SwipeButtonType.expand:
        if (!swiped && widget.enabled) {
          if (isRTL) {
            expandAnimationController.value -= offset;
          } else {
            expandAnimationController.value += offset;
          }
          if (expandAnimationController.value == 1) {
            setState(() {
              swiped = true;
              widget.onSwipe?.call();
            });
          }
        }
        break;
    }
  }

  _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      swipeAnimationController.animateTo(0);
      expandAnimationController.animateTo(0);
    });
    widget.onSwipeEnd?.call();
  }
}
