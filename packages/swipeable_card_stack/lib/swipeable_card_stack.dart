import 'package:flutter/material.dart';

class SwipeableCardStack extends StatefulWidget {
  const SwipeableCardStack({super.key});

  @override
  State<SwipeableCardStack> createState() => _SwipeableCardStackState();
}

class _SwipeableCardStackState extends State<SwipeableCardStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;

  late Animation<double> _scaleAnimation;

  late Animation<double> _alignAnimation;

  ValueNotifier<List<Card>> cards = ValueNotifier([
    Card(
      key: const ValueKey('purple'),
      color: Colors.purple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    Card(
      key: const ValueKey('red'),
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    Card(
      key: const ValueKey('blue'),
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    Card(
      key: const ValueKey('green'),
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    Card(
      key: const ValueKey('pink'),
      color: Colors.pink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  ]);

  void onHorizontalSwipe(int index, DragEndDetails dragDetails) {
    if (dragDetails.primaryVelocity! > 0 || dragDetails.primaryVelocity! < 0) {
      // Start the animation.
      _animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation =
        Tween<double>(begin: 0.4 + ((cards.value.length - 2) / 10), end: 1.0)
            .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _alignAnimation = Tween<double>(begin: -30, end: 30).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        setState(() {
          // Remove the swiped card and save it temporarily.
          final removedCard = cards.value.removeAt(cards.value.length - 1);

          // Insert the saved card at the end of the list.
          cards.value.insert(0, removedCard);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cards,
      builder: (context, value, child) => Stack(
        alignment: Alignment.center,
        children: List.generate(
          cards.value.length,
          (index) => Positioned(
            key: ValueKey(index),
            top: index * 30,
            child: IgnorePointer(
              ignoring: cards.value.length - 1 == index ? false : true,
              child: GestureDetector(
                onHorizontalDragEnd: (DragEndDetails dragDetails) =>
                    onHorizontalSwipe(index, dragDetails),
                child: cards.value.length - 1 == index
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: _ListItem(card: cards.value[index]),
                      )
                    : cards.value.length - 2 == index
                        ? AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(0, _alignAnimation.value),
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: _ListItem(card: cards.value[index]),
                              ),
                            ),
                          )
                        : Transform.translate(
                            offset: const Offset(0, -30),
                            child: Transform.scale(
                              scale: 0.4 + (index / 10),
                              child: _ListItem(
                                card: cards.value[index],
                              ),
                            ),
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    Key? key,
    required this.card,
  }) : super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 300,
      child: card,
    );
  }
}
