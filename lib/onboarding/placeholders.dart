import 'package:flutter/material.dart';
import 'design.dart';

/// Playful 3D-feeling vector illustrations and badges inspired by Duolingo.
/// Provides rich, colorful visual anchors with zero external image dependencies.

class DuoIntroBadge extends StatelessWidget {
  final int slideIndex;

  const DuoIntroBadge({
    super.key,
    required this.slideIndex,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color primaryColor;
    Color shadowColor;
    Color badgeColor;
    String tagLabel;

    switch (slideIndex) {
      case 0:
        icon = Icons.school_rounded;
        primaryColor = DuoColors.teal;
        shadowColor = DuoColors.tealDark;
        badgeColor = DuoColors.green;
        tagLabel = 'COLLABORATIVE';
        break;
      case 1:
        icon = Icons.emoji_events_rounded;
        primaryColor = DuoColors.yellow;
        shadowColor = DuoColors.yellowDark;
        badgeColor = DuoColors.coral;
        tagLabel = 'DAILY GOALS';
        break;
      case 2:
      default:
        icon = Icons.auto_awesome_rounded;
        primaryColor = DuoColors.blue;
        shadowColor = DuoColors.blueDark;
        badgeColor = DuoColors.violet;
        tagLabel = 'UNLIMITED CURIOSITY';
        break;
    }

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Soft glowing background ring
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.12),
              ),
            ),

            // Floating sparkles
            Positioned(
              top: 10,
              left: 40,
              child: Icon(Icons.star_rounded, size: 28, color: DuoColors.yellow),
            ),
            Positioned(
              bottom: 20,
              right: 40,
              child: Icon(Icons.star_rounded, size: 22, color: DuoColors.blue),
            ),

            // Main 3D Icon Badge
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Bottom shadow
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: shadowColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Front Face
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        icon,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    tagLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DuoLoginBadge extends StatelessWidget {
  const DuoLoginBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DuoColors.blueLight.withOpacity(0.6),
              ),
            ),
            Positioned(
              top: 15,
              right: 40,
              child: Icon(Icons.bolt_rounded, size: 30, color: DuoColors.yellow),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: DuoColors.blueDark,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: DuoColors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(
                    Icons.lock_open_rounded,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DuoWelcomeBadge extends StatelessWidget {
  const DuoWelcomeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DuoColors.greenLight.withOpacity(0.6),
              ),
            ),
            // Confetti elements
            Positioned(
              top: 12,
              left: 45,
              child: Icon(Icons.star_rounded, size: 28, color: DuoColors.yellow),
            ),
            Positioned(
              bottom: 16,
              left: 40,
              child: Icon(Icons.celebration_rounded, size: 30, color: DuoColors.coral),
            ),
            Positioned(
              top: 20,
              right: 45,
              child: Icon(Icons.auto_awesome_rounded, size: 26, color: DuoColors.violet),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: DuoColors.greenDark,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: DuoColors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.5),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Chunky circular avatars in the signature Duolingo style.
class DuoAvatarPicker extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DuoAvatarPicker({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<Map<String, dynamic>> avatars = [
    {
      'label': 'Google',
      'icon': Icons.account_circle_rounded,
      'color': DuoColors.teal,
      'shadow': DuoColors.tealDark,
      'index': -1,
    },
    {
      'label': 'Green',
      'icon': Icons.sentiment_very_satisfied_rounded,
      'color': DuoColors.green,
      'shadow': DuoColors.greenDark,
      'index': 0,
    },
    {
      'label': 'Yellow',
      'icon': Icons.face_rounded,
      'color': DuoColors.yellow,
      'shadow': DuoColors.yellowDark,
      'index': 1,
    },
    {
      'label': 'Blue',
      'icon': Icons.mood_rounded,
      'color': DuoColors.blue,
      'shadow': DuoColors.blueDark,
      'index': 2,
    },
    {
      'label': 'Coral',
      'icon': Icons.tag_faces_rounded,
      'color': DuoColors.coral,
      'shadow': DuoColors.coralDark,
      'index': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CHOOSE YOUR AVATAR',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            color: DuoColors.textMuted,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: avatars.map((item) {
            final int idx = item['index'] as int;
            final bool isSelected = selectedIndex == idx;
            final Color color = item['color'] as Color;
            final Color shadow = item['shadow'] as Color;
            final IconData icon = item['icon'] as IconData;

            return GestureDetector(
              onTap: () => onSelected(idx),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 180),
                scale: isSelected ? 1.12 : 1.0,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // 3D Shadow Base
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: isSelected ? shadow : DuoColors.borderDark,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Front Avatar Disk
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: isSelected ? color : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : DuoColors.borderGrey,
                          width: 2.5,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : color,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
