import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FooDy GooDy",
      initialRoute: '/login',
      routes: {
        '/login': (context) => (LogIn()),
        '/home': (context) {
          return Home();
        },
        '/register': (context) => (Register()),
      },
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final textController = TextEditingController();
  final passController = TextEditingController();
  final dbh = DatabaseHelper.instance;

  Future<void> handleLogin() async {
    final text = textController.text;
    final pass = passController.text;
    bool canLog = await dbh.canLogin(text, pass);
    if (!mounted) return;
    if (canLog) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid name or password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text("Log In"),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: "user name",
                  hintText: 'UserName',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: handleLogin,
                      child: Text("Login"),
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text("Register"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("HOME"), centerTitle: true));
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final dbh = DatabaseHelper.instance;
  final userController = TextEditingController();
  final passController = TextEditingController();

  Future<void> handleRegister(String name, String password) async {
    final result = await dbh.insert(name, password);
    if (result >= 1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Registered")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Register"))),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                TextField(
                  controller: userController,
                  decoration: InputDecoration(hintText: 'username'),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: passController,
                  decoration: InputDecoration(hintText: 'password'),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                handleRegister(userController.text, passController.text);
                Navigator.pushNamed(context, '/login');
              },
              child: Text("Register"),
            ),
          ),
        ],
      ),
    );
  }
}
