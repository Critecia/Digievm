// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field

import 'dart:typed_data';
import 'package:flutter/material.dart';
// Removed Bluetooth-related imports
import 'package:google_fonts/google_fonts.dart';
import 'package:sst/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:sst/datapro.dart';

class Count extends StatefulWidget {
  const Count({super.key});

  @override
  _CountState createState() => _CountState();
}

class _CountState extends State<Count> {
  // Removed Bluetooth-related fields
  Map<String, String> voteCounts = {
    'Bhartiya Janta Party': "0",
    'Indian National Congress': "0",
    'Rashtriya Loktantrik Party': "0",
    'Communist Party Of India (Marxist)': "0",
    'Bahujan Samaj Party': "0",
    'Samajwadi Party': "0",
    'Janata Party': "0",
    'Aam Aadmi Party': "0",
    'Nationalist Congress Party': "0",
    'Dravida Munnetra Party': "0",
    'Swatantrata Party': "0",
    'None Of The Above': "0",
  };

  @override
  void initState() {
    super.initState();
    _loadSavedVotes();
  }

  // Removed Bluetooth-related methods

  void _handleMenuSelection(String value) {
    setState(() {
      if (value == 'reset') {
        voteCounts.updateAll((key, value) => "0");
      } else if (value == 'save') {
        _saveToDatabase();
      }
    });
  }

  Future<void> _loadSavedVotes() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> savedVotes = await dbHelper.getVotes();
    setState(() {
      for (var vote in savedVotes) {
        if (voteCounts.containsKey(vote['party_name'])) {
          voteCounts[vote['party_name']] = vote['count'].toString();
        }
      }
    });
  }

  Future<void> _saveToDatabase() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.saveVotes(voteCounts);
    print("Votes saved to database!");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        home: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.bar_chart_rounded),
                padding: EdgeInsets.only(right: 30),
                splashColor: Colors.white,
                color: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, '/turnoutpage');
                },
              ),
            ],
            backgroundColor: const Color.fromARGB(255, 233, 233, 233),
            elevation: 12,
            title: Text(
              'Vote Count',
              style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Table(
                    border: TableBorder.all(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: _buildTableRows(),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurpleAccent,
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width - 100,
                  MediaQuery.of(context).size.height - 150,
                  10,
                  10,
                ),
                items: [
                  PopupMenuItem(
                    value: 'reset',
                    child: ListTile(
                      leading: Icon(Icons.refresh, color: Colors.blue),
                      title: Text("Reset Count"),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'save',
                    child: ListTile(
                      leading: Icon(Icons.save, color: Colors.green),
                      title: Text("Save to Database"),
                    ),
                  ),
                ],
              ).then((value) {
                if (value != null) _handleMenuSelection(value);
              });
            },
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows() {
    final List<Map<String, String>> parties = [
      {'name': 'Bhartiya Janta Party', 'logo': 'assets/bjp.png'},
      {'name': 'Indian National Congress', 'logo': 'assets/cng.png'},
      {'name': 'Rashtriya Loktantrik Party', 'logo': 'assets/rlp.png'},
      {'name': 'Communist Party Of India (Marxist)', 'logo': 'assets/cpoi.png'},
      {'name': 'Bahujan Samaj Party', 'logo': 'assets/bsp.png'},
      {'name': 'Samajwadi Party', 'logo': 'assets/sp.png'},
      {'name': 'Janata Party', 'logo': 'assets/jp.png'},
      {'name': 'Aam Aadmi Party', 'logo': 'assets/aap.png'},
      {'name': 'Nationalist Congress Party', 'logo': 'assets/ncp.png'},
      {'name': 'Dravida Munnetra Party', 'logo': 'assets/dmp.png'},
      {'name': 'Swatantrata Party', 'logo': 'assets/swp.png'},
      {'name': 'None Of The Above', 'logo': 'assets/nota.png'},
    ];

    List<TableRow> rows = [
      TableRow(
        decoration: BoxDecoration(
          color: Colors.deepPurple[100],
          borderRadius: BorderRadius.circular(12),
        ),
        children: [
          _buildHeaderCell('L O G O'),
          _buildHeaderCell('P A R T Y  N A M E'),
          _buildHeaderCell('C O U N T'), // Removed "Count" column
        ],
      ),
    ];

    for (var party in parties) {
      rows.add(
        TableRow(
          children: [
            _buildImageCell(party['logo'] ?? ''), // Ensure non-null String
            _buildCell(party['name'] ?? ''), // Ensure non-null String
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    voteCounts[party['name']] ?? '0',
                    style: GoogleFonts.sigmar(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    child: Text('+1'),
                    onPressed: () async {
                      setState(() {
                        int currentCount = int.parse(
                          voteCounts[party['name']] ?? '0',
                        );
                        voteCounts[party['name'] ?? ''] =
                            (currentCount + 1).toString();
                      });

                      // Update DataProvider
                      Provider.of<DataProvider>(
                        context,
                        listen: false,
                      ).updateVoteCounts(voteCounts);

                      // Save updated vote counts to the database
                      DatabaseHelper dbHelper = DatabaseHelper();
                      await dbHelper.saveVotes(voteCounts);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return rows;
  }

  Widget _buildHeaderCell(String text) {
    return _buildCell(text, isHeader: true);
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.sigmar(
              color: Colors.black87,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: isHeader ? 16 : 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCell(String imagePath) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Image.asset(imagePath, width: 40, height: 40),
      ),
    );
  }
}
