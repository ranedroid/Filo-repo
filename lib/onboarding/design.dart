import 'package:flutter/material.dart';

/// Duolingo-inspired color tokens and design system for Filo.
class DuoColors {
  // Vibrant Duolingo Signature Colors
  static const Color green = Color(0xFF58CC02);
  static const Color greenDark = Color(0xFF46A302);
  static const Color greenLight = Color(0xFFD7FFB8);
  static const Color greenSurface = Color(0xFFF2FBE9);

  // Deep Teal (Filo Brand Anchor)
  static const Color teal = Color(0xFF134E4A);
  static const Color tealDark = Color(0xFF0C3835);
  static const Color tealLight = Color(0xFFCCFBF1);
  static const Color tealSurface = Color(0xFFF0FDFA);

  // Sky Blue Accent
  static const Color blue = Color(0xFF1CB0F6);
  static const Color blueDark = Color(0xFF1899D6);
  static const Color blueLight = Color(0xFFDDF4FF);

  // Sunny Yellow (Streaks / Stars)
  static const Color yellow = Color(0xFFFFC800);
  static const Color yellowDark = Color(0xFFE5A800);
  static const Color yellowLight = Color(0xFFFFF7D6);

  // Coral / Red (Hearts / Errors)
  static const Color coral = Color(0xFFFF4B4B);
  static const Color coralDark = Color(0xFFEA2B2B);

  // Purple / Violet (Gems)
  static const Color violet = Color(0xFFCE82FF);
  static const Color violetDark = Color(0xFFA558E5);

  // Neutrals & Surfaces
  static const Color background = Color(0xFFFAFAF7);
  static const Color cardBg = Colors.white;
  static const Color borderGrey = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFFCECECE);
  static const Color textDark = Color(0xFF3C3C3C);
  static const Color textMuted = Color(0xFF777777);
  static const Color textLight = Color(0xFFAFAFAF);
}

enum DuoButtonVariant {
  primary, // Vibrant Green
  teal, // Rich Teal
  secondary, // Clean White with 3D border
  blue, // Sky Blue
  ghost, // Flat text button
}

/// Tactile 3D button inspired by Duolingo.
/// Depresses physically on click with a realistic mechanical feel.
class DuoButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final DuoButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final double height;
  final double? width;

  const DuoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DuoButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.height = 50,
    this.width,
  });

  @override
  State<DuoButton> createState() => _DuoButtonState();
}

class _DuoButtonState extends State<DuoButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    Color faceColor;
    Color bottomColor;
    Color textColor;
    Border? border;

    switch (widget.variant) {
      case DuoButtonVariant.primary:
        faceColor = DuoColors.green;
        bottomColor = DuoColors.greenDark;
        textColor = Colors.white;
        break;
      case DuoButtonVariant.teal:
        faceColor = DuoColors.teal;
        bottomColor = DuoColors.tealDark;
        textColor = Colors.white;
        break;
      case DuoButtonVariant.blue:
        faceColor = DuoColors.blue;
        bottomColor = DuoColors.blueDark;
        textColor = Colors.white;
        break;
      case DuoButtonVariant.secondary:
        faceColor = Colors.white;
        bottomColor = DuoColors.borderDark;
        textColor = DuoColors.textDark;
        border = Border.all(color: DuoColors.borderGrey, width: 2);
        break;
      case DuoButtonVariant.ghost:
        return SizedBox(
          height: widget.height,
          child: TextButton(
            onPressed: widget.onPressed,
            style: TextButton.styleFrom(
              foregroundColor: DuoColors.textMuted,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
        );
    }

    if (!isEnabled) {
      faceColor = DuoColors.borderGrey;
      bottomColor = DuoColors.borderDark;
      textColor = DuoColors.textLight;
      border = null;
    }

    final double bottomEdgeThickness = isEnabled ? 4.0 : 2.0;
    final double pressOffset = (_isPressed && isEnabled) ? bottomEdgeThickness : 0.0;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height + bottomEdgeThickness,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled
            ? (_) {
                setState(() => _isPressed = false);
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 3D Bottom Base Layer
            Positioned(
              top: bottomEdgeThickness,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: bottomColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Front Button Face (Moves Down When Pressed)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 60),
              curve: Curves.easeOut,
              top: pressOffset,
              left: 0,
              right: 0,
              bottom: bottomEdgeThickness - pressOffset,
              child: Container(
                decoration: BoxDecoration(
                  color: faceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: border,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            widget.icon!,
                            const SizedBox(width: 10),
                          ],
                          Text(
                            widget.label.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tactile 3D selectable card inspired by Duolingo.
class DuoCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsetsGeometry padding;

  const DuoCard({
    super.key,
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isSelected ? DuoColors.greenSurface : Colors.white;
    final Color borderColor = isSelected ? DuoColors.green : DuoColors.borderGrey;
    final Color bottomColor = isSelected ? DuoColors.greenDark : DuoColors.borderDark;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // 3D bottom shadow
          Positioned(
            top: 4,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: bottomColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Front card surface
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill-shaped animated progress bar with a glossy shine.
class DuoProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0

  const DuoProgressBar({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);

    return Container(
      height: 14,
      width: double.infinity,
      decoration: BoxDecoration(
        color: DuoColors.borderGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final targetWidth = constraints.maxWidth * clampedValue;

          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                width: targetWidth,
                height: 14,
                decoration: BoxDecoration(
                  color: DuoColors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Subtle 3D glossy highlight on top
              if (clampedValue > 0.05)
                Positioned(
                  top: 2,
                  left: 4,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                    width: (targetWidth - 8).clamp(0.0, constraints.maxWidth),
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Crisp speech bubble with a playful arrow tail pointing to content.
class DuoSpeechBubble extends StatelessWidget {
  final String text;
  final String? title;

  const DuoSpeechBubble({
    super.key,
    required this.text,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: DuoColors.borderGrey, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: DuoColors.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: DuoColors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        // Small tail pointing down/left
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: CustomPaint(
            size: const Size(18, 10),
            painter: _BubbleTailPainter(),
          ),
        ),
      ],
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = DuoColors.borderGrey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paintFill);
    canvas.drawLine(const Offset(0, 0), Offset(size.width / 2, size.height), paintStroke);
    canvas.drawLine(Offset(size.width / 2, size.height), Offset(size.width, 0), paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
