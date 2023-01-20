import 'package:flutter/material.dart';

class SizedCard extends StatefulWidget {
  const SizedCard({
    this.height,
    this.width,
    this.margin,
    this.alignment,
    this.child,
    super.key,
    this.elevation,
    this.onTap,
    double? cornerRadius,
    this.enabled = true,
    this.shape,
    this.stroke,
    bool? transparent,
    double? strokeWidth,
  })  : transparent = transparent ?? false,
        strokeWidth = strokeWidth ?? 10,
        cornerRadius = cornerRadius ?? 20;

  final void Function()? onTap;

  final bool enabled;
  final bool transparent;
  final Color? stroke;
  final double strokeWidth;

  final double? height;
  final double? width;

  final Widget? child;

  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  final ShapeBorder? shape;
  final double? cornerRadius;
  final double? elevation;

  @override
  State<SizedCard> createState() => _SizedCardState();
}

class _SizedCardState extends State<SizedCard> {
  @override
  Widget build(BuildContext context) {
    //set card color according to transparent or enabled
    Color? cardColor = getCardColor(context);

    //set card shape to a shape or to rounded corners
    ShapeBorder? shape = getShape();

    return Card(
        shape: shape,
        color: cardColor,
        elevation: 0, //widget.elevation,
        margin: widget.margin,
        child: InkWell(
            customBorder: shape,
            onTap: widget.onTap,
            child: Container(
              height: widget.height,
              width: widget.width,
              alignment: widget.alignment,
              child: widget.child,
            )));
  }

  ShapeBorder? getShape() {
    ShapeBorder? shape;

    if (widget.shape != null) {
      shape = widget.shape!;
    } else {
      if (widget.cornerRadius != null) {
        shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.cornerRadius!),
            side: (widget.stroke == null)
                ? BorderSide.none
                : BorderSide(color: widget.stroke!, width: widget.strokeWidth));
      } else {
        shape = null;
      }
    }

    return shape;
  }

  Color? getCardColor(BuildContext context) {
    if (widget.transparent) return Colors.transparent;

    if (!widget.enabled) return Theme.of(context).cardColor.withOpacity(0.5);

    //return the normal card color if no flag is set
    return null;
  }
}
