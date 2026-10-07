import 'package:flutter/material.dart';
import 'design.dart';

/// Duolingo-styled responsive screen shell for Filo.
/// Features the signature top progress bar and a pinned bottom action bar.
class FiloFrame extends StatelessWidget {
  final Widget body;
  final Widget? footer;
  final VoidCallback? onBack;
  final Widget? trailingHeader;
  final double progress; // 0.0 to 1.0 (for DuoProgressBar)
  final double maxWidth;
  final EdgeInsetsGeometry contentPadding;

  const FiloFrame({
    super.key,
    required this.body,
    this.footer,
    this.onBack,
    this.trailingHeader,
    this.progress = 0.0,
    this.maxWidth = 520,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DuoColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                // Duolingo-style Top Header with Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      if (onBack != null)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: DuoColors.textDark, size: 26),
                          onPressed: onBack,
                          splashRadius: 22,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                      else
                        const SizedBox(width: 8),

                      const SizedBox(width: 14),

                      // Animated Progress Bar
                      Expanded(
                        child: DuoProgressBar(value: progress),
                      ),

                      const SizedBox(width: 14),

                      if (trailingHeader != null)
                        trailingHeader!
                      else
                        const SizedBox(width: 8),
                    ],
                  ),
                ),

                // Main Scrollable Area
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: contentPadding,
                    child: body,
                  ),
                ),

                // Duolingo-style Sticky Bottom Footer
                if (footer != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: DuoColors.borderGrey, width: 2),
                      ),
                    ),
                    child: footer!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
