import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'OspedaliSicilia',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IntroductionScreen()),
                );
              },
              child: Text('Avanti'),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  List<Widget> _pages = [
    IntroductionPage(
      title: 'Benvenuto su OspedaliSicilia!',
      content: 'Con questa app puoi conoscere la posizione dei pronto soccorso in Sicilia e visualizzarne l\'affollamento.',
    ),
    IntroductionPage(
      title: 'In caso di emergenza',
      content: 'Chiama il numero unico 112.',
    ),
    IntroductionPage(
      title: 'Informazioni sui pronto soccorso',
      content: 'Puoi visualizzare i dati sui pronto soccorso:\n- Numero di pazienti in trattamento e in attesa\n- Livelli di gravità: rosso (EMERGENZA), arancione (URGENZA), azzurro (URGENZA DIFFERIBILE), verde (URGENZA MINORE), bianco (NON URGENZA)',
    ),
    IntroductionPage(
      title: 'Trova il pronto soccorso più vicino',
      content: 'L\'app ti aiuta a individuare il pronto soccorso più vicino e avvia la navigazione per raggiungerlo.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _pages[index];
              },
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: ElevatedButton(
              onPressed: () {
                if (currentPage < _pages.length - 1) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                currentPage < _pages.length - 1 ? 'Avanti' : 'Inizia',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroductionPage extends StatelessWidget {
  final String title;
  final String content;

  const IntroductionPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HospitalList(),
    Center(child: Text('Mappa della Sicilia con gli ospedali')),
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
        title: Text('OspedaliSicilia'),
      ),
      drawer: Drawer(
        child: MenuDrawer(),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ospedali',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mappa',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HospitalList extends StatefulWidget {
  @override
  _HospitalListState createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  List<String> _hospitalNames = [
    'Ospedale 1',
    'Ospedale 2',
    'Ospedale 3',
    'Ospedale 4',
    'Ospedale 5',
    'Ospedale 6',
    'Ospedale 7',
    'Ospedale 8',
    'Ospedale 9',
    'Ospedale 10',
  ];

  List<String> _filteredHospitals = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _filteredHospitals.addAll(_hospitalNames);
    super.initState();
  }

  void _filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(_hospitalNames);
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filteredHospitals.clear();
        _filteredHospitals.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filteredHospitals.clear();
        _filteredHospitals.addAll(_hospitalNames);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              _filterSearchResults(value);
            },
            decoration: InputDecoration(
              labelText: 'Cerca ospedali',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredHospitals.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_filteredHospitals[index]),
                subtitle: Text('Dettagli ${_filteredHospitals[index]}'),
                onTap: () {
                  // Implementazione del tap su un ospedale
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('HOME'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        ListTile(
          title: Text('INTRODUZIONE'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => IntroductionScreen()),
            );
          },
        ),
        ListTile(
          title: Text('TI PIACE L\'APP?'),
          onTap: () {
            // Implementa la logica per "Ti piace l'app?"
          },
        ),
        ListTile(
          title: Text('CONTATTI'),
          onTap: () {
            // Implementa la logica per "Contatti"
          },
        ),
      ],
    );
  }
}
