import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart'; // Import your HomeScreen
import 'child_profile_management.dart'; // Import your ChildProfileUpdateScreen

class SelectChildScreen extends StatefulWidget {
  const SelectChildScreen({Key? key}) : super(key: key);

  @override
  _SelectChildScreenState createState() => _SelectChildScreenState();
}

class _SelectChildScreenState extends State<SelectChildScreen> {
  List<dynamic> children = [];
  bool isLoading = true;
  bool _isReadyToDelete =
      false; // Added: Track if the user has swiped once to reveal delete

  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.10:8000/child_list'),
      );
      if (response.statusCode == 200) {
        setState(() {
          children = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load children')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> deleteChild(String name) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.10:8000/child/$name'),
      );
      if (response.statusCode == 200) {
        setState(() {
          children.removeWhere((child) => child['name'] == name);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Child deleted successfully')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete child')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting child: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text(
          'Select a Child',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // added for icon
      ),
      body: Container(
        color: Colors.lightBlue[100], // Solid background
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : children.isEmpty
                ? Center(child: Text('No children found'))
                : ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    final child = children[index];
                    return Dismissible(
                      key: Key(child['name']),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Modified: Set a threshold to stop swipe when Delete text is fully shown
                      dismissThresholds: {
                        DismissDirection.endToStart:
                            0.6, // Approximate threshold for Delete text width
                      },
                      confirmDismiss: (direction) async {
                        // Modified: Implement two-step swipe process
                        if (!_isReadyToDelete) {
                          setState(() {
                            _isReadyToDelete =
                                true; // First swipe reveals Delete fully
                          });
                          await Future.delayed(
                            Duration(milliseconds: 200),
                          ); // Slight delay for feedback
                          return false; // Prevent dismissal on first swipe
                        } else {
                          setState(() {
                            _isReadyToDelete = false; // Reset for next item
                          });
                          return true; // Allow dismissal on second swipe
                        }
                      },
                      onDismissed: (direction) {
                        deleteChild(child['name']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChildProfileScreen(
                                      childName: child['name'],
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                child['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
