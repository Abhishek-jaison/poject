import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/services/auth_services.dart';
import 'package:project/widgets/shimmer.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  // Color scheme constants
  final Color baseColor = Color(0xFFE6BFFF);
  final Color darkPurple = Color(0xFF9B4DCA);
  final Color lightPurple = Color(0xFFF2E6FF);

  // Dummy data for UI demonstration
  final List<Map<String, dynamic>> contentItems = [
    {
      'id': '1',
      'image': 'https://placeholder.com/150',
      'description': 'Sample description 1',
      'audioUrl': 'sample_audio_1.mp3',
      'status': 'pending',
    },
    {
      'id': '2',
      'image': 'https://placeholder.com/150',
      'description': 'Sample description 2',
      'audioUrl': 'sample_audio_2.mp3',
      'status': 'pending',
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        elevation: 0,
        backgroundColor: baseColor.withOpacity(0.3),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: baseColor.withOpacity(0.3)),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: darkPurple,
                        radius: 40,
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Admin Panel',
                        style: TextStyle(
                          color: darkPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard, color: darkPurple),
                title: Text(
                  'Dashboard',
                  style: TextStyle(color: darkPurple, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                },
              ),
              Divider(color: baseColor.withOpacity(0.3)),
              Spacer(),
              Divider(color: baseColor.withOpacity(0.3)),
              ListTile(
                leading: Icon(Icons.logout, color: darkPurple),
                title: Text(
                  'Logout',
                  style: TextStyle(color: darkPurple, fontSize: 16),
                ),
                onTap: () {
                  // Show confirmation dialog
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
                            color: darkPurple,
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
                              backgroundColor: darkPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              _handleLogout(); // Handle logout
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Dashboard Header
          Container(
            padding: EdgeInsets.all(16),
            color: baseColor.withOpacity(0.3),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: baseColor, width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pending Reviews',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${contentItems.length}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: baseColor, width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Processed',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Review List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: contentItems.length,
              itemBuilder: (context, index) {
                final item = contentItems[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: baseColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        item['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: baseColor.withOpacity(0.2),
                            child: Icon(Icons.image, color: darkPurple),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      item['description'],
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Status: ${item['status']}',
                      style: TextStyle(color: darkPurple),
                    ),
                    onTap: () {
                      _showContentDetail(context, item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showContentDetail(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image with Shimmer
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: baseColor, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ShimmerPlaceholder(),
                      Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return ShimmerPlaceholder();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Description
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkPurple,
                ),
              ),
              SizedBox(height: 8),
              Text(
                item['description'],
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 16),

              // Audio Player
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: lightPurple,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: baseColor, width: 1),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_arrow, color: darkPurple),
                      onPressed: () {
                        // TODO: Implement audio playback
                      },
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: darkPurple,
                          thumbColor: darkPurple,
                          inactiveTrackColor: baseColor.withOpacity(0.3),
                        ),
                        child: Slider(
                          value: 0,
                          onChanged: (value) {
                            // TODO: Implement audio seeking
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Implement reject logic
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Reject',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkPurple,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Implement accept logic
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Accept',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
