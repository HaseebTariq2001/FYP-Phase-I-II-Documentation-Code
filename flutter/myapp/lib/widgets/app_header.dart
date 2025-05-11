// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class AppHeader extends StatelessWidget {
//   final String title;
//   final bool showMenu;
//   final bool showParent;
//   final bool showBack;
//   final VoidCallback? onMenuTap; // 👈 Callback for menu icon
//   final VoidCallback? onParentTap; // ✅ NEW: For parent icon

//   const AppHeader({
//     super.key,
//     required this.title,
//     this.showMenu = false,
//     this.showParent = false,
//     this.showBack = false,
//     this.onMenuTap,
//     this.onParentTap, // ✅ Add to constructor
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.blue[800],
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Left: Back icon+text or Menu icon+text
//           showBack
//               ? GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Column(
//                   children: [
//                     SvgPicture.asset(
//                       'assets/images/back_arrow.svg',
//                       height: 35,
//                       width: 40,
//                       colorFilter: const ColorFilter.mode(
//                         Colors.white,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     const Text(
//                       "Back",
//                       style: TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               )
//               : (showMenu
//                   ? GestureDetector(
//                     onTap: onMenuTap, // 👈 Open drawer
//                     child: Column(
//                       children: [
//                         SvgPicture.asset(
//                           'assets/images/bars.svg',
//                           height: 35,
//                           width: 40,
//                           colorFilter: const ColorFilter.mode(
//                             Colors.white,
//                             BlendMode.srcIn,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         const Text(
//                           "Menu",
//                           style: TextStyle(color: Colors.white, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   )
//                   : const SizedBox(width: 50)),

//           // Center title
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),

//           // Right: Parent icon+text
//           showParent
//               ? Column(
//                 children: [
//                   SvgPicture.asset(
//                     'assets/images/user.svg',
//                     height: 35,
//                     width: 40,
//                     colorFilter: const ColorFilter.mode(
//                       Colors.white,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   const Text(
//                     "Parent",
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ],
//               )
//               : const SizedBox(width: 50),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showMenu;
  final bool showParent;
  final bool showParentLabel; // ✅ NEW PARAMETER

  final bool showBack;
  final VoidCallback? onMenuTap; // ✅ For menu icon
  final VoidCallback? onParentTap; // ✅ NEW: For parent icon

  const AppHeader({
    super.key,
    required this.title,
    this.showMenu = false,
    this.showParent = false,
    this.showBack = false,
    this.showParentLabel = true, // ✅ DEFAULT: true

    this.onMenuTap,
    this.onParentTap, // ✅ Add to constructor  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[800],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Back or Menu
          showBack
              ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/back_arrow.svg',
                      height: 35,
                      width: 40,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
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
                  ? GestureDetector(
                    onTap: onMenuTap,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/bars.svg',
                          height: 35,
                          width: 40,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Menu",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
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

          // Right: Parent icon (now tappable)
          showParent
              ? GestureDetector(
                onTap: onParentTap, // ✅ Use the callback
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/user.svg',
                      height: 35,
                      width: 40,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Parent",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              )
              : const SizedBox(width: 50),
        ],
      ),
    );
  }
}
