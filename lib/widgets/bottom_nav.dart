import 'package:flutter/material.dart';
import 'package:qr_code_scanner/pages/generate_code.dart';
import 'package:qr_code_scanner/pages/scan_code.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  PageController pageController = PageController();

  List<Widget> widgets = [
    const Text('Scan code'),
    const Text('Generate code'),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: const [
              ScanCodePage(),
              GenerateCodePage(),
            ],
          ),
          Positioned(
            left: 110,
            right: 110,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20.0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.qr_code_scanner,
                            size: 35,
                          ),
                        ),
                        label: 'Scan code'),
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.qr_code,
                            size: 35,
                          ),
                        ),
                        label: 'Generate code'),
                  ],
                  currentIndex: selectedIndex,
                  selectedItemColor: const Color(0xFF34a853),
                  unselectedItemColor: Colors.black,
                  onTap: onItemTapped,
                  backgroundColor:
                      Colors.white, // Change color to your desired color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
