import 'package:flutter/material.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({super.key});

  @override
  _RateAppScreenState createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  int _rating = 0;
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                    (index) => IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    _rating > index ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            const Text(
              'Comment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your comment here',
              ),
              onChanged: (value) => setState(() => _comment = value),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle rating and comment submission
                print('Rating: $_rating');
                print('Comment: $_comment');

                // Show a Toast message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thank you for your rating!'),
                  ),
                );

                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}