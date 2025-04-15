import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final cardColor = isDark ? Colors.grey[900] : Colors.grey[200];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        
        const SizedBox(height: 16),
        const SizedBox(height: 20),

        // Coming soon text
        Center(
          child: Text(
            '🌌 Sacred Timeline\nWill be integrated in future!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ),

        const SizedBox(height: 30),

        // Pick where you left off
        Text(
          '🎧 Pick where you left off',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.play_circle_fill, color: Colors.deepPurple),
            title: Text('Episode 2 • Title TBD', style: TextStyle(color: textColor)),
            subtitle: Text('Last played • 2 mins ago', style: TextStyle(color: textColor)),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.deepPurple),
              onPressed: () {
                // TODO: Resume logic
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Recent activity
        Text(
          'Recent Activity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),

        // Placeholder cards
        ...List.generate(3, (index) {
          return Card(
            color: cardColor,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.podcasts, color: Colors.deepPurple),
              title: Text('Episode ${index + 1}', style: TextStyle(color: textColor)),
              subtitle: Text('Activity details here', style: TextStyle(color: textColor)),
              trailing: const Icon(Icons.play_arrow_rounded, color: Colors.deepPurple),
              onTap: () {
                // TODO: Play episode
              },
            ),
          );
        }),
      ],
    );
  }
}
