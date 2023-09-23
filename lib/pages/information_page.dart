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
    heading: 'Depression in India',
    tagLine: 'Country-wise Statistics',
    imageAssetPath: 'assets/images/depression.jpg',
    details: 'In India, approximately 7.5% of the population suffers from depression. According to recent surveys, urban areas tend to have higher rates compared to rural areas. Factors contributing to depression include work stress, lifestyle changes, and lack of awareness.',
    customName: 'Depression',
  ),
  ListItem(
    heading: 'Anxiety in Indian Youth',
    tagLine: 'Year-wise Comparison',
    imageAssetPath: 'assets/images/anxiety.jpg',
    details: 'Over the past decade, anxiety disorders among Indian youth have been on the rise. In 2010, the prevalence was around 3%, but by 2020, it had increased to nearly 8%. The pressures of education, career choices, and social media are contributing factors.',
    customName: 'Anxiety',
  ),
  ListItem(
    heading: 'Suicide Rates in States',
    tagLine: 'State-wise Comparison',
    imageAssetPath: 'assets/images/suicide.jpg',
    details: 'India has significant variations in suicide rates among states. For example, states like Kerala, Tamil Nadu, and Maharashtra have higher rates, while states like Bihar, Jharkhand, and West Bengal have relatively lower rates. These differences are influenced by cultural, socioeconomic, and educational factors.',
    customName: 'Suicide',
  ),
  ListItem(
    heading: 'Mental Health Awareness Campaigns',
    tagLine: 'Awareness Initiatives',
    imageAssetPath: 'assets/images/awareness.jpg',
    details: 'In recent years, India has witnessed an increase in mental health awareness campaigns and initiatives. Organizations and government programs are working to reduce stigma and promote mental health education. These efforts aim to improve access to mental health services across the country.',
    customName: 'Awareness',
  ),
  ListItem(
    heading: 'Psychiatric Facilities in India',
    tagLine: 'Facility Availability',
    imageAssetPath: 'assets/images/hospital.jpg',
    details: 'India faces a shortage of psychiatric facilities. There are approximately 0.3 psychiatrists per 100,000 population. This shortage impacts access to mental health care, especially in rural areas. Efforts are being made to increase the number of mental health professionals and facilities.',
    customName: 'Facilities',
  ),
  ListItem(
    heading: 'Youth Mental Health Trends',
    tagLine: 'Youth Perspective',
    imageAssetPath: 'assets/images/youth.jpg',
    details: 'Indian youth are increasingly seeking help for mental health issues. More young people are open to discussing their problems and seeking professional help. This positive trend indicates a growing awareness and willingness to address mental health concerns.',
    customName: 'Youth Mental Health',
  ),
  ListItem(
    heading: 'Stress Levels in Urban Areas',
    tagLine: 'Urban vs. Rural',
    imageAssetPath: 'assets/images/stress.jpg',
    details: 'Urban areas in India often report higher stress levels due to the fast-paced lifestyle, competition, and work-related pressures. In contrast, rural areas generally have lower stress levels, but face challenges related to access to mental health care.',
    customName: 'Stress',
  ),
  ListItem(
    heading: 'Government Mental Health Budget',
    tagLine: 'Budget Allocation',
    imageAssetPath: 'assets/images/budget.jpg',
    details: 'The Indian government has been increasing its budget allocation for mental health services in recent years. These funds are directed towards improving mental health infrastructure, awareness campaigns, and training of mental health professionals.',
    customName: 'Budget',
  ),
  ListItem(
    heading: 'Substance Abuse and Mental Health',
    tagLine: 'Co-occurrence',
    imageAssetPath: 'assets/images/substance.jpg',
    details: 'There is a strong connection between substance abuse and mental health issues in India. Individuals with substance use disorders are at a higher risk of developing mental health problems. Integrated treatment programs are addressing this co-occurrence.',
    customName: 'Substance Abuse',
  ),
  ListItem(
    heading: 'Mental Health Policies',
    tagLine: 'Policy Developments',
    imageAssetPath: 'assets/images/policy.jpg',
    details: 'India has been working on developing comprehensive mental health policies to address the growing mental health needs of the population. These policies focus on improving access to care, reducing stigma, and promoting mental well-being.',
    customName: 'Policies',
  ),
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