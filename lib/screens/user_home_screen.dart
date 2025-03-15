import 'package:flutter/material.dart';
import 'package:project/screens/upload_screen.dart';
import 'package:project/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // Function to handle logout
  Future<void> _handleLogout() async {
    try {
      // Clear auth service state
      await AuthService.logout();

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to login screen and remove all previous routes
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to get the current screen
  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return UploadScreen();
      case 1:
        return ProfileScreen(onLogout: _handleLogout);
      default:
        return UploadScreen();
    }
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
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false, // This removes the back arrow
            title: Text(
              "Welcome Back,\nUser",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 49, 47, 47),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
      body: _getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF9B4DCA),
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatelessWidget {
  final Function onLogout;

  const ProfileScreen({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFF9B4DCA),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'User Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9B4DCA),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Profile Info
                ListTile(
                  leading: Icon(Icons.email, color: Color(0xFF9B4DCA)),
                  title: Text('Email'),
                  subtitle: Text('user@example.com'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.upload_file, color: Color(0xFF9B4DCA)),
                  title: Text('Total Uploads'),
                  subtitle: Text('0'),
                ),
                Divider(),
                // Notifications Section
                Expanded(
                  child: Column(
                    children: [
                      ExpansionTile(
                        leading: Icon(
                          Icons.notifications,
                          color: Color(0xFF9B4DCA),
                        ),
                        title: Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          '2 new notifications',
                          style: TextStyle(
                            color: Color(0xFF9B4DCA),
                            fontSize: 12,
                          ),
                        ),
                        children: [
                          SizedBox(
                            height: 200, // Reduced fixed height
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  NotificationItem(
                                    title: 'Data submission accepted',
                                    message:
                                        'Your submission "Sample Data 1" was accepted',
                                    status: 'accepted',
                                    timestamp: '2 hours ago',
                                  ),
                                  Divider(height: 1),
                                  NotificationItem(
                                    title: 'Data submission rejected',
                                    message:
                                        'Your submission "Sample Data 2" was rejected',
                                    status: 'rejected',
                                    timestamp: '1 day ago',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 80), // Space for logout button
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Fixed Logout Button at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text('Logout', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9B4DCA),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            'Confirm Logout',
                            style: TextStyle(
                              color: Color(0xFF9B4DCA),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9B4DCA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                onLogout();
                              },
                              child: Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String status;
  final String timestamp;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.status,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color:
                  status == 'accepted'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                color: status == 'accepted' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(message),
          SizedBox(height: 4),
          Text(
            timestamp,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
