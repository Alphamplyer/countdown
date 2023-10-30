
import 'package:countdown/domain/countdown_entity.dart';
import 'package:countdown/domain/countdown_manager.dart';
import 'package:countdown/widgets/countdown.dart';
import 'package:flutter/material.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({super.key});

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  late Future<CountdownEntity> loadLastCountdownFuture;

  @override
  void initState() {
    super.initState();
    loadLastCountdownFuture = CountdownManager.loadLastCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown'),
      ),
      body: FutureBuilder(
        future: loadLastCountdownFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Error: Could not load last countdown or create a new one.'),
            );
          }

          CountdownEntity countdown = snapshot.data!;

          return Center(
            child: Countdown(countdown: countdown),
          );
        }
      ),
    );
  }
}