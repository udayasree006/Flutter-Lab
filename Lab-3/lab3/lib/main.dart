import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StudentDashboard(),
    );
  }
}

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Image + Profile Image
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  "assets/image1.jpg",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 20,
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage("assets/image2.jpg"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            // Student Details
            const Text(
              "Udaya Sree",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Computer Science and Engineering",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // Feature Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                feature(Icons.book, "Books"),
                feature(Icons.task, "Tasks"),
                feature(Icons.star, "Marks"),
                feature(Icons.person, "Profile"),
              ],
            ),

            const SizedBox(height: 25),

            // Notification Switch
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(fontSize: 17),
                  ),
                  Switch(
                    value: notifications,
                    onChanged: (value) {
                      setState(() {
                        notifications = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Login Button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: notifications
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login clicked"),
                          ),
                        );
                      }
                    : null,
                child: const Text("Login"),
              ),
            ),

            const SizedBox(height: 10),

            // Register Button
            SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: notifications
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Register clicked"),
                          ),
                        );
                      }
                    : null,
                child: const Text("Register"),
              ),
            ),

            const SizedBox(height: 25),

            // Counter
            const Text(
              "Counter",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Counter(
              enabled: notifications,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

// Feature Widget
  Widget feature(IconData icon, String text) {
    return Container(
      width: 75,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.blue,
          ),
          const SizedBox(height: 5),
          Text(text),
        ],
      ),
    );
  }
}

// Counter StatefulWidget
class Counter extends StatefulWidget {
  final bool enabled;

  const Counter({
    super.key,
    required this.enabled,
  });

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrement Button
        ElevatedButton(
          onPressed: widget.enabled
              ? () {
                  setState(() {
                    count--;
                  });
                }
              : null,
          child: const Text(
            "-",
            style: TextStyle(fontSize: 20),
          ),
        ),

        const SizedBox(width: 20),

        // Count
        Text(
          "$count",
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 20),

        // Increment Button
        ElevatedButton(
          onPressed: widget.enabled
              ? () {
                  setState(() {
                    count++;
                  });
                }
              : null,
          child: const Text(
            "+",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
