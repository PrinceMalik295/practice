import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Academy',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Colors.green,
          elevation: 0,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        Get.off(() => DashboardScreen());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Icon(
          Icons.chat_bubble_outline,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static List<Widget> _screens = <Widget>[
    ChatsScreen(),
    StatusScreen(),
    CallsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quran Academy',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_outlined),
            label: 'Calls',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ChatsScreen extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {"name": "Ustadh Ali", "message": "Assalamu Alaikum!"},
    {"name": "Ahmed", "message": "JazakAllah!"},
    {"name": "Fatima", "message": "Alhamdulillah!"},
    {"name": "Sara", "message": "Good morning!"},
    {"name": "Hamza", "message": "See you in class."},
    // Add more random data here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[200],
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              chats[index]["name"]!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chats[index]["message"]!),
            onTap: () {
              Get.to(() => ChatScreen(name: chats[index]["name"]!));
            },
          ),
        );
      },
    );
  }
}

class StatusScreen extends StatelessWidget {
  final List<Map<String, dynamic>> statuses = [
    {"text": "Ustadh Ali updated his status", "video": "assets/sample1.mp4"},
    {"text": "Fatima updated her status", "video": "assets/sample2.mp4"},
    {"text": "Sara's new video status", "video": "assets/sample3.mp4"},
    // Add more random statuses here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[200],
              child: Icon(Icons.circle, color: Colors.white),
            ),
            title: Text(
              statuses[index]["text"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Get.dialog(
                AlertDialog(
                  content: VideoPlayerWidget(videoPath: statuses[index]["video"]),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  VideoPlayerWidget({required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class CallsScreen extends StatelessWidget {
  final List<Map<String, String>> calls = [
    {"name": "Ustadh Maryam", "time": "Today, 12:00 PM"},
    {"name": "Ahmed", "time": "Yesterday, 3:30 PM"},
    {"name": "Sara", "time": "Monday, 2:00 PM"},
    {"name": "Hamza", "time": "Last week, 5:00 PM"},
    // Add more random call data here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[200],
              child: Icon(Icons.call, color: Colors.white),
            ),
            title: Text(
              calls[index]["name"]!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(calls[index]["time"]!),
            trailing: Icon(Icons.call, color: Colors.green),
            onTap: () {
              Get.snackbar('Call', 'Calling ${calls[index]["name"]}');
            },
          ),
        );
      },
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String name;

  ChatScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Handle call action
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Handle video call action
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more actions
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: [
                // Add chat messages here
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    // Handle add action
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    // Handle send action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
