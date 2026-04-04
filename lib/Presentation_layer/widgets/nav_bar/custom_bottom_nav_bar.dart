import 'package:flutter/material.dart';
import '../../../styles/color.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<IconData> icons = [
    Icons.local_pizza, // Wallet
    Icons.shopping_bag,                    // Link / Connection
    Icons.home,                            // Home (Lightning)
    Icons.shopping_cart_outlined,            // Document
    Icons.person_outline,                  // Profile
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double orbSize = 68.0;
    final double itemWidth = screenWidth / 5;

    return Container(
      color: Background_Color,
      height: 95,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // الشريط الداكن
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 78,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 15,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  final bool isSelected = widget.currentIndex == index;
                  return GestureDetector(
                    onTap: () => widget.onTap(index),
                    child: SizedBox(
                      width: itemWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icons[index],
                            color: isSelected ? Colors.transparent : Colors.grey[400],
                            size: 26,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // الكرة الزرقاء المتحركة (الـ Orb)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeInOutCubic,
            left: itemWidth * widget.currentIndex + (itemWidth - orbSize) / 2,
            top: -15,
            child: Container(
              width: orbSize,
              height: orbSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [primColor, const Color(0xFF773CE3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primColor.withOpacity(0.75),
                    blurRadius: 25,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: Icon(
                icons[widget.currentIndex],
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        ],
      ),
    );
  }
}