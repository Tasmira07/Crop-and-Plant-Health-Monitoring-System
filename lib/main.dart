import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green, // Change the primary color
        // accentColor: Colors.green, // Change the accent color
        scaffoldBackgroundColor: Colors.white, // Change the background color
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    // ... (unchanged)
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/token/'), // Replace with your Django API endpoint
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      // ... (unchanged)
      final Map<String, dynamic> data = json.decode(response.body);
      final String accessToken = data['access'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProtectedResourcePage(accessToken: accessToken),
        ),
      );
    } else {
      // ... (unchanged)
      print('Login failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Plant Health Monitoring System!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(), // Add border
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(), // Add border
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
              child: Text('Don\'t have an account? Sign up here.'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    // ... (unchanged)
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/token/'), // Replace with your Django API endpoint
      body: {
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      // ... (unchanged)
      final Map<String, dynamic> data = json.decode(response.body);
      final String accessToken = data['access'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProtectedResourcePage(accessToken: accessToken),
        ),
      );
    } else {
      // ... (unchanged)
      print('Signin failed.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement sign-up logic here
                // You may send a request to your server to create a new account
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProtectedResourcePage extends StatefulWidget {
  final String accessToken;

  const ProtectedResourcePage({required this.accessToken});

  @override
  _ProtectedResourcePageState createState() => _ProtectedResourcePageState();
}

class _ProtectedResourcePageState extends State<ProtectedResourcePage> {
  List<dynamic> cropData = [];

  @override
  void initState() {
    super.initState();
    fetchCropData(widget.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Health Monitoring System'),
      ),
      body: ListView.builder(
        itemCount: cropData.length,
        itemBuilder: (context, index) {
          final item = cropData[index];
          return Card(
            margin: EdgeInsets.all(8), // Add margin
            child: ListTile(
              title: Text(
                'Temperature: ${item['temperature']} - Humidity: ${item['humidity']} - Moisture: ${item['moisture']}',
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchCropData(String accessToken) async {
    // ... (unchanged)
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/api/data/'), // Replace with your API endpoint
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        cropData = data;
      });
    } else {
      print('API request failed.');
    }
  }
}
