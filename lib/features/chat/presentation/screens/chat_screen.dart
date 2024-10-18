import 'package:flutter/material.dart';

class MessagingPage extends StatelessWidget {
  const MessagingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Left sidebar for navigation
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {
              // Handle navigation
            },
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.message),
                label: Text('Messages'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notifications),
                label: Text('Notifications'),
              ),
              // Add more navigation items as needed
            ],
          ),
          // Message list
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with actual message count
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('U'), // Replace with user initial or avatar
                  ),
                  title: Text('User ${index + 1}'),
                  subtitle: Text('Last message preview'),
                  trailing: Text('2h ago'), // Replace with actual timestamp
                  onTap: () {
                    // Open chat detail view
                  },
                );
              },
            ),
          ),
          // Chat detail view (can be conditionally rendered)
          Expanded(
            child: Column(
              children: [
                // Chat header
                AppBar(
                  title: Text('Chat with User'),
                ),
                // Chat messages
                Expanded(
                  child: ListView(
                    children: [
                      // Implement chat messages here
                    ],
                  ),
                ),
                // Message input
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          // Send message
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
