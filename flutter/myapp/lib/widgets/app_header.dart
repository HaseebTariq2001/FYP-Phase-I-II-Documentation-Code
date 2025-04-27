import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showMenu;
  final bool showParent;
  final bool showBack;

  const AppHeader({
    super.key,
    required this.title,
    this.showMenu = false,
    this.showParent = false,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[800],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Back icon+text or Menu icon+text
          showBack
              ? GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/back_arrow.svg',
                        height: 35,
                        width: 40,
                        colorFilter:
                            const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Back",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                )
              : (showMenu
                  ? Column(
                      children: [
                        SvgPicture.asset(
                          'assets/bars.svg',
                          height: 35,
                          width: 40,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Menu",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    )
                  : const SizedBox(width: 50)),

          // Center title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Right: Parent icon+text
          showParent
              ? Column(
                  children: [
                    SvgPicture.asset(
                      'assets/user.svg',
                      height: 35,
                      width: 40,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Parent",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                )
              : const SizedBox(width: 50),
        ],
      ),
    );
  }
}


