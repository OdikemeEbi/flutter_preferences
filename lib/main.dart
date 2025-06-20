import 'package:flutter/material.dart';
import 'package:prefs/storage/prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  await Prefs.initCheck();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _displayName = '';
  int? _displayAge;

  @override
  void initState() {
    super.initState();
  }

  Future saveData() async {
    try {
      if (_formKey.currentState!.validate()) {
        await Prefs.saveName(_nameController.text);
        await saveAge();
        await displayName();
        await displayAge();
      } else {
        print('Form not validated');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future loadData() async {
    await displayAge();
    await displayName();
  }

  Future clearData() async {
    await Prefs.clearData();
    setState(() {
      _nameController.clear();
      _ageController.clear();
      _displayName = '';
      _displayAge = 0;
    });
  }

  Future saveAge() async {
    await Prefs.saveAge(int.parse(_ageController.text));
    // await displayName();
  }

  Future displayName() async {
    setState(() {
      _displayName = Prefs.getName();
      if (_displayName != null) _nameController.text = _displayName.toString();
    });
  }

  Future displayAge() async {
    setState(() {
      _displayAge = Prefs.displayAge();
      if (_displayAge != null) _ageController.text = _displayAge.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Name'),

              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Name', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name Field cannot be empty';
                  } else if (value.length < 6) {
                    return 'Name too short';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Age'),

              SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(hintText: 'Age', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Age Field cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: saveData, child: Text('Save Data')),
                  ElevatedButton(onPressed: clearData, child: Text('Clear Data')),
                  ElevatedButton(onPressed: loadData, child: Text('Load Data')),
                ],
              ),

              if (_displayName != null && _displayName!.isNotEmpty) Text(_displayName!),
              if (_displayAge != null && _displayAge != 0) Text(_displayAge.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
