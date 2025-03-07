import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_project_presentation_lastsegment/demoson.dart';
import 'package:flutter_project_presentation_lastsegment/main.dart';

void main() {
  runApp(LoginScreen_App());
}

class LoginScreen_App extends StatelessWidget {
  const LoginScreen_App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/computer1.png',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                'Hệ Thống Quản Lý Thiết Bị Trường Học',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                  suffixIcon: Icon(Icons.visibility),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreenNow()),
                  );
                },
                child: Text('Sign In', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 15),
              Text('or continue with'),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    label: Text('Google'),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                    label: Text('Apple'),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextButton(onPressed: () {}, child: Text('Forgot Password?')),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New to our platform? '),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Create Account',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Terms of Service  •  Privacy Policy',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DemoFormScreen()),
                  );
                },
                child: Text("Đi Đến Demo Screen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
