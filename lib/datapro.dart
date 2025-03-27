import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
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

  void updateVoteCounts(Map<String, String> newVoteCounts) {
    voteCounts = newVoteCounts;
    notifyListeners();
  }
}
