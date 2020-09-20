import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiProvider {
  final bool mockup;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  ApiProvider({this.mockup = true});

  /// Fetches data from Cloud Firetore or from mockup data
  Future<dynamic> fetch(String url, {Map<String, dynamic> payload}) async {
    if (mockup) {
      final completeUrl = 'assets/data/mockup/' + url + '.json';
      final data = await rootBundle.loadString(completeUrl);
      await Future.delayed(Duration(seconds: 1));
      return json.decode(data);
    }

    print(url);
    if (payload == null) {
      // TODO(@amerlo): implement more robust checks
      // TODO(@amerlo): is the use of then() a best practice over FutureBuilder?
      // Check for documentPath
      if (url.contains("/")) {
        DocumentReference ref = db.doc(url);
        return ref.get().then((d) => d.data());
      }
      // Get collections
      CollectionReference ref = db.collection(url);
      return ref.get().then((c) => c.docs.map((d) => d.data()).toList());
    } else {
      //TODO(@amerlo)
    }
  }
}
