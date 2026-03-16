import 'package:flutter/material.dart';

class SwipeButton extends StatefulWidget {
  final String text;
  final VoidCallback onSwipeComplete;
  final bool enabled;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? disabledColor;

  const SwipeButton({
    super.key,
    required this.text,
    required this.onSwipeComplete,
    this.enabled = true,
    this.backgroundColor,
    this.buttonColor,
    this.disabledColor,
  });

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0;
  double _maxDragDistance = 0;
  late AnimationController _resetAnimationController;
  late Animation<double> _resetAnimation;

  @override
  void initState() {
    super.initState();
    _resetAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _resetAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _resetAnimationController,
      curve: Curves.easeOut,
    ));
  }

  
  @override
  void dispose() {
    _resetAnimationController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled) return;

    setState(() {
      _dragPosition =
          (_dragPosition + details.delta.dx).clamp(0, _maxDragDistance);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;

    if (_dragPosition >= _maxDragDistance * 0.9) {
     
      setState(() {
        _dragPosition = _maxDragDistance;
      });
      widget.onSwipeComplete();
    } else {
   
      _resetAnimation = Tween<double>(
        begin: _dragPosition,
        end: 0,
      ).animate(CurvedAnimation(
        parent: _resetAnimationController,
        curve: Curves.easeOut,
      ));

      _resetAnimationController.forward(from: 0).then((_) {
        setState(() {
          _dragPosition = 0;
        });
      });

      _resetAnimation.addListener(() {
        setState(() {
          _dragPosition = _resetAnimation.value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxDragDistance = constraints.maxWidth - 70;

        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: widget.enabled
                ? (widget.backgroundColor ?? Colors.green.shade100)
                : (widget.disabledColor ?? Colors.grey.shade300),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
            
              Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color:
                        widget.enabled ? Colors.black87 : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),

              // Draggable button
              Positioned(
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: widget.enabled
                          ? (widget.buttonColor ?? Colors.green)
                          : Colors.grey,
                      shape: BoxShape.circle,
                      boxShadow: widget.enabled
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
