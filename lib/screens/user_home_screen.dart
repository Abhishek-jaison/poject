import 'package:flutter/material.dart';
import 'package:project/screens/upload_screen.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0; // Index of the selected bottom navigation item

  // List of screens for each bottom navigation item
  final List<Widget> _screens = [
    HomeScreen(), // Replace with your home screen
    UploadScreen(), // Your existing upload screen
    ProfileScreen(), // Replace with your profile screen
  ];

  // Animation controller and animation for page transitions
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller and animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Trigger animation when switching screens
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Adjust shadow intensity
                blurRadius: 6, // Increase for a softer shadow
                spreadRadius: 1, // Increase for a more prominent effect
                offset: Offset(0, 1), // Move shadow downward
              ),
            ],
          ),
          child: AppBar(
            title: Text(
              "Welcome Back,\nUser",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 49, 47, 47),
              ),
            ),
            backgroundColor: Colors.white, // Ensure background is set
            elevation:
                0, // Remove default elevation (since we're using a custom shadow)
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: _screens[_currentIndex], // Display the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Placeholder for the Home Screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home Screen"));
  }
}

// Placeholder for the Profile Screen
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Profile Screen"));
  }
}
