import 'package:flutter/material.dart';

class ListItem {
  final String heading;
  final String tagLine;
  final String imageAssetPath;
  final String details;
  final String customName; // New property for the custom name

  ListItem({
    required this.heading,
    required this.tagLine,
    required this.imageAssetPath,
    required this.details,
    required this.customName, // Include in the constructor
  });
}

class ListViewWithSearch extends StatefulWidget {
  @override
  _ListViewWithSearchState createState() => _ListViewWithSearchState();
}

class _ListViewWithSearchState extends State<ListViewWithSearch> {
  late List<ListItem> items;
  late List<ListItem> filteredItems;

  @override
  void initState() {
    super.initState();
    items = [
      ListItem(
        heading: 'Item 1',
        tagLine: 'Tag Line 1',
        imageAssetPath: 'assets/images/image1.jpg',
        details: 'Details about Item 1...',
        customName: 'Google', // Custom name
      ),
      ListItem(
        heading: 'Item 2',
        tagLine: 'Tag Line 2',
        imageAssetPath: 'assets/images/image2.jpg',
        details: 'Details about Item 2...',
        customName: 'Flutter', // Custom name
      ),
      // Add more items as needed
    ];
    filteredItems = items;
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) =>
      item.heading.toLowerCase().contains(query.toLowerCase()) ||
          item.tagLine.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List View Example with Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterItems,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      filteredItems[index].heading,
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(filteredItems[index].tagLine),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          filteredItems[index].imageAssetPath), // Use asset path
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            item: filteredItems[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final ListItem item;

  DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.customName), // Display custom name
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.heading,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              item.tagLine,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Image.asset(item.imageAssetPath),
            SizedBox(height: 16),
            Text(
              item.details,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}