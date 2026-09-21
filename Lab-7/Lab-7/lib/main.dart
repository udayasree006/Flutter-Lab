import 'package:flutter/material.dart';

void main() {
  runApp(const SmartWaterApp());
}

class SmartWaterApp extends StatelessWidget {
  const SmartWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Water Intake Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const WaterTrackerPage(),
    );
  }
}

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  // Daily hydration goal
  static const int dailyGoal = 2000;

  // Today's water information
  int totalConsumed = 0;
  int entryCount = 0;

  // Controller for water input
  final TextEditingController waterController = TextEditingController();

  // ----------------------------------------------------------
  // REMAINING WATER
  // ----------------------------------------------------------

  int get remainingWater {
    final int remaining = dailyGoal - totalConsumed;

    if (remaining < 0) {
      return 0;
    }

    return remaining;
  }

  // ----------------------------------------------------------
  // COMPLETION PERCENTAGE
  // ----------------------------------------------------------

  double get completionPercentage {
    final double percentage = (totalConsumed / dailyGoal) * 100;

    if (percentage > 100) {
      return 100;
    }

    return percentage;
  }

  // ----------------------------------------------------------
  // PROGRESS VALUE
  // ----------------------------------------------------------

  double get progress {
    final double value = totalConsumed / dailyGoal;

    if (value > 1) {
      return 1;
    }

    return value;
  }

  // ----------------------------------------------------------
  // ADD WATER
  // ----------------------------------------------------------

  void addWater() {
    final String input = waterController.text.trim();

    // Empty input
    if (input.isEmpty) {
      showMessage(
        'Please enter a water amount.',
        Colors.red,
      );
      return;
    }

    // Convert input into number
    final int? amount = int.tryParse(input);

    // Invalid input
    if (amount == null) {
      showMessage(
        'Please enter numbers only.',
        Colors.red,
      );
      return;
    }

    // Prevent zero and negative values
    if (amount <= 0) {
      showMessage(
        'Water amount must be greater than 0 mL.',
        Colors.red,
      );
      return;
    }

    // Update water information
    setState(() {
      totalConsumed += amount;
      entryCount++;
    });

    // Clear text field
    waterController.clear();

    // Success message
    showMessage(
      '$amount mL added successfully!',
      Colors.green,
    );
  }

  // ----------------------------------------------------------
  // RESET WATER
  // ----------------------------------------------------------

  void resetWater() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Reset Water Intake?',
          ),
          content: const Text(
            'Are you sure you want to reset today\'s water intake?',
          ),
          actions: [
            // Cancel
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancel',
              ),
            ),

            // Reset
            ElevatedButton(
              onPressed: () {
                setState(() {
                  totalConsumed = 0;
                  entryCount = 0;
                });

                Navigator.of(dialogContext).pop();

                showMessage(
                  'Today\'s water intake has been reset.',
                  Colors.blue,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Reset',
              ),
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------
  // SHOW MESSAGE
  // ----------------------------------------------------------

  void showMessage(
    String message,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // DISPOSE
  // ----------------------------------------------------------

  @override
  void dispose() {
    waterController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // BUILD UI
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------

      appBar: AppBar(
        title: const Text(
          'Smart Water Tracker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      // ------------------------------------------------------
      // BODY
      // ------------------------------------------------------

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ------------------------------------------------
            // WATER ICON
            // ------------------------------------------------

            const Icon(
              Icons.water_drop,
              color: Colors.blue,
              size: 80,
            ),

            const SizedBox(height: 10),

            // ------------------------------------------------
            // DAILY GOAL
            // ------------------------------------------------

            const Text(
              'Daily Hydration Goal',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              '2000 mL',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // ------------------------------------------------
            // PROGRESS CARD
            // ------------------------------------------------

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Today\'s Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Circular progress indicator
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 14,
                            backgroundColor: Colors.blue.shade100,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                          Center(
                            child: Text(
                              '${completionPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      '$totalConsumed mL consumed',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------
            // CONSUMED + REMAINING
            // ------------------------------------------------

            Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    icon: Icons.water_drop,
                    title: 'Consumed',
                    value: '$totalConsumed mL',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildStatCard(
                    icon: Icons.hourglass_bottom,
                    title: 'Remaining',
                    value: '$remainingWater mL',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ------------------------------------------------
            // ENTRIES + PERCENTAGE
            // ------------------------------------------------

            Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    icon: Icons.format_list_numbered,
                    title: 'Entries',
                    value: '$entryCount',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildStatCard(
                    icon: Icons.percent,
                    title: 'Completed',
                    value: '${completionPercentage.toStringAsFixed(0)}%',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ------------------------------------------------
            // INPUT TITLE
            // ------------------------------------------------

            const Text(
              'Add Water Intake',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ------------------------------------------------
            // INPUT FIELD
            // ------------------------------------------------

            TextField(
              controller: waterController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
                signed: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter amount in mL',
                prefixIcon: const Icon(
                  Icons.local_drink,
                  color: Colors.blue,
                ),
                suffixText: 'mL',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------
            // ADD BUTTON
            // ------------------------------------------------

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: addWater,
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text(
                  'Add Water',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------
            // RESET BUTTON
            // ------------------------------------------------

            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: resetWater,
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.red,
                ),
                label: const Text(
                  'Reset Today\'s Intake',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ------------------------------------------------
            // STATUS MESSAGE
            // ------------------------------------------------

            if (totalConsumed >= dailyGoal)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.celebration,
                      color: Colors.green,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Congratulations! You have reached your daily hydration goal!',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'You need $remainingWater mL more to reach your daily goal.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // STATISTIC CARD
  // ----------------------------------------------------------

  Widget buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
