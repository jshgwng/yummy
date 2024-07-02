// main.dart or any appropriate part of your application

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/products_screen.dart'; // Import the ProductsScreen
import 'widgets/home_tab.dart';
import 'widgets/profile_tab.dart';
import 'widgets/settings_tab.dart';
import 'services/user_service.dart';
import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  final UserService userService = UserService();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    bool loggedIn = await userService.isLoggedIn();
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  void handleLoggedIn() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void handleLogout() async {
    await userService.logout();
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return MainScreen(onLogout: handleLogout);
    } else {
      return AuthScreen(onLoggedIn: handleLoggedIn);
    }
  }
}

class AuthScreen extends StatefulWidget {
  final VoidCallback onLoggedIn;

  const AuthScreen({super.key, required this.onLoggedIn});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;

  void toggleAuthMode() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginScreen(onLoggedIn: widget.onLoggedIn)
        : RegisterScreen(onRegistered: widget.onLoggedIn);
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainScreen({super.key, required this.onLogout});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final UserService userService = UserService();
  User? user;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    User? fetchedUser = await userService.getUser();
    setState(() {
      user = fetchedUser;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBodyWidget() {
    switch (_selectedIndex) {
      case 0:
        return user == null ? const CircularProgressIndicator() : HomeTab(user: user!);
      case 1:
        return ProfileTab(user: user);
      case 2:
        return const SettingsTab();
      case 3:
        return ProductsScreen(); // Replace with ProductsScreen
      default:
        return Container(); // Handle other cases if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: Center(
        child: _getBodyWidget(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.amber,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.amber,),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Colors.amber,),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag,color: Colors.amber,),
            label: 'Products',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
