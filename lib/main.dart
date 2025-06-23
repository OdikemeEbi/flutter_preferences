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
  final TextEditingController _faveController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isSubscribe = false;
  String? _displayName = '';
  int? _displayAge;
  String? faveColor;
  String? selectedColor;
  final List<String> _availableColors = ['Red', 'Blue', 'Green', 'Black'];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// Saves all user data (name, age, favorite color from text, selected color from radio, and subscription status) to shared preferences.
  Future saveData() async {
    try {
      if (_formKey.currentState!.validate()) {
        await Prefs.saveName(_nameController.text);
        await saveAge();
        await displayName();
        await displayAge();
        await Prefs.saveNewFavouriteColor(_faveController.text);
        await Prefs.saveFavouriteColor(selectedColor ?? '');
        await Prefs.saveSubScription(isSubscribe);
      } else {
        print('Form not validated');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// Loads all user data (name, age, favorite color from text, selected color from radio, and subscription status) from shared preferences and updates the UI.
  Future loadData() async {
    await displayAge();
    await displayName();
    await displayColor();
    await selectedColors();
    await getSub();
  }

  /// Clears all user data from shared preferences and resets the UI fields.
  Future clearData() async {
    await Prefs.clearData();
    setState(() {
      _nameController.clear();
      _ageController.clear();
      _faveController.clear();
      selectedColor = null;
      faveColor = null;
      _displayName = '';
      _displayAge = 0;
    });
  }

  /// Saves the user's age to shared preferences and updates the displayed name.
  Future saveAge() async {
    await Prefs.saveAge(int.parse(_ageController.text));
    await displayName();
  }

  /// Loads the user's name from shared preferences and updates the UI.
  Future displayName() async {
    setState(() {
      _displayName = Prefs.getName();
      if (_displayName != null) _nameController.text = _displayName.toString();
    });
  }

  /// Loads the user's age from shared preferences and updates the UI.
  Future displayAge() async {
    setState(() {
      _displayAge = Prefs.displayAge();
      if (_displayAge != null) _ageController.text = _displayAge.toString();
    });
  }

  /// Loads the user's favorite color (from text field) from shared preferences and updates the UI.
  Future displayColor() async {
    setState(() {
      faveColor = Prefs.getNewFavouriteColor();
      if (faveColor != null) _faveController.text = faveColor.toString();
    });
  }

  /// Loads the user's selected color (from radio buttons) from shared preferences and updates the UI.
  Future selectedColors() async {
    setState(() {
      selectedColor = Prefs.getFavouriteColor();
    });
  }

  /// Loads the user's subscription status from shared preferences and updates the UI.
  Future getSub() async {
    isSubscribe = Prefs.isSubscribed() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Form(
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
                Text('Favourite Color'),

                SizedBox(height: 10),
                TextFormField(
                  controller: _faveController,
                  decoration: InputDecoration(hintText: 'Red, Blue, Green, Black', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                Text('Select Favourite Color'),
                SizedBox(height: 10),
                ..._availableColors.map((color) {
                  return RadioListTile(
                    value: color,
                    title: Text(color, style: TextStyle(color: _getColorFromString(color))),
                    activeColor: _getColorFromString(color),
                    groupValue: selectedColor,
                    onChanged: (value) {
                      setState(() {
                        selectedColor = value;
                      });
                    },
                  );
                }),
                SizedBox(height: 20),
                Switch(
                  value: isSubscribe,
                  onChanged: (value) {
                    setState(() {
                      isSubscribe = value;
                    });
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
                if (faveColor != null && faveColor!.isNotEmpty) Text(faveColor!),
                if (selectedColor != null && selectedColor!.isNotEmpty) Text(selectedColor!),
                if (isSubscribe == true) Text('Subscribed'),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns a [Color] object based on the provided color name string.
  Color _getColorFromString(String color) {
    switch (color) {
      case 'Red':
        return Colors.red;
      case 'Blue':
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Black':
        return Colors.black;
      default:
        return Colors.white;
    }
  }
}
