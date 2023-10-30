
import 'package:countdown/domain/countdown_entity.dart';
import 'package:countdown/services/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CountdownManager {
  static Uuid uuid = const Uuid();

  static Future<CountdownEntity> createCountdown() async {
    debugPrint('Creating new countdown');
    String id = uuid.v4();
    await SharedPrefs.setString(SharedPrefs.lastCountdownIdKey, id);
    CountdownEntity countdown = CountdownEntity(id: id);
    await saveCountdown(countdown);
    return countdown;
  }

  static Future<CountdownEntity> loadLastCountdown() async {
    String? id = await SharedPrefs.getString(SharedPrefs.lastCountdownIdKey);
    CountdownEntity countdown;
    
    if (id == null) {
      countdown = await createCountdown();
      return countdown;
    }

    int? persitedInitialTimeInSeconds = await SharedPrefs.getInt(id);
    
    if (persitedInitialTimeInSeconds == null) {
      countdown = await createCountdown();
      return countdown;
    }

    debugPrint('Successfully loaded countdown with id: $id');
    return CountdownEntity(id: id, initialTimeInSeconds: persitedInitialTimeInSeconds);
  }

  static Future<void> saveCountdown(CountdownEntity countdown) async {
    debugPrint('Saving countdown with id: ${countdown.id}');
    await SharedPrefs.setInt(countdown.id, countdown.initialTimeInSeconds);
  }
}