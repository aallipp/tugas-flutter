//memasukkan package yang dibutuhkan oleh aplikasi
import 'package:english_words/english_words.dart';//paket bahasa inggris
import 'package:flutter/material.dart';//paket untuk tampilan UI (material UI)
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';//paket untuk interaksi aplikasi

//fungsi main (fungsi utama)
void main() {
  runApp(MyApp());//memanggil fungsi runApp (yg menjalankan keseluruhan aplikasi di dalam MyApp)
}


//membuat abstrak aplikasi dari statelessWidget (template aplikasi), aplikasi bernama MyApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});//menunjukkan bahwa aplikasi ini akan tetap, tidak berubah setelah di-build

  @override //mengganti nilai lama yg sudah ada di template, dengan nilai-nilai yg baru (replace / overwrite) 
  Widget build(BuildContext context) {
    //fungsi yg membagun UI (mengatur posisi widget, dst)
    //ChangeNotifierProvider / mendeteksi semua interaksi yang terjadi di aplikasi
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      //membuat satu state bernama MyAppState
      child: MaterialApp( // pada state ini, menggunakan style desain MaterialUI
        title: 'Namer App', //diberi judul Namer App
        theme: ThemeData( //data tema aplikasi, diberi warna blue.shade200
          useMaterial3: true, //versi materialUI yang dipakai versi 3
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade200),
        ),
        home: MyHomePage(), //nama halaman "MyHomePage" yang menggunakan state "MyAppState".
      ),
    );
  }
}
//mendefinisikan isi MyAppState
class MyAppState extends ChangeNotifier {
  //state MyAppState diisi dengan 2 kata random yang digabung. kata random tsb disimpan di variable WordPair
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

//membuat layout pada halaman HomePage
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = Placeholder();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
}
    return LayoutBuilder(
      builder: (context, Constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: Constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),//memberi jarak/padding di sekitar teks
        child: Text(pair.asLowerCase, style: style,semanticsLabel: "${pair.first} ${pair.second}",),//membuat kata mencajdi huruf kecil
      ),
    );
  }
}