import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NewsBar extends StatefulWidget {
  @override
  _NewsBarState createState() => _NewsBarState();
}

class _NewsBarState extends State<NewsBar> {
  List<Map<String, String>> _articles = [];
  bool _isLoading = true;
  final String _apiKey = 'e099557be5934f7ba0a23ed8f56c7774';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  // Asynchronously fetches news articles using the News API.
  Future<void> _fetchNews() async {
    try {
      final dio = Dio();
      // Make a GET request to the News API endpoint for general news.
      final response = await dio.get(
        'https://newsapi.org/v2/everything?q=general&apiKey=$_apiKey',
      );

      // Extract the list of articles from the response data, defaulting to an empty list if null.
      final List<dynamic> rawapi =
          response.data['articles'] as List<dynamic>? ?? [];
      // Map the raw article data to a list of maps containing the title and image URL.
      _articles = rawapi.map<Map<String, String>>((article) {
        final title = article['title'] as String? ?? 'No title';
        final image = article['urlToImage'] as String? ?? '';
        return {'title': title, 'image': image};
      }).toList();
    } catch (e) {
      print('Error fetching news: $e');
    } finally {
      // After attempting to fetch the news, set _isLoading to false and trigger a UI rebuild if the widget is still mounted.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen.
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate a responsive width for each news card.
    final cardWidth = screenWidth * 0.6;
    // Calculate a responsive right margin for each news card.
    final cardMarginRight = screenWidth * 0.03;

    // While the news is loading, display a centered circular progress indicator.
    if (_isLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Display the horizontal list of news articles.
    return SizedBox(
      height: 150,
      child: ListView.builder(
        // Add horizontal padding to the list based on screen width.
        padding:
            EdgeInsets.symmetric(vertical: 8, horizontal: screenWidth * 0.03),
        scrollDirection: Axis.horizontal,
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return Container(
            width: cardWidth,
            // Add a right margin to each card for spacing.
            margin: EdgeInsets.only(right: cardMarginRight),
            child: Card(
              shape: const RoundedRectangleBorder(),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the news image if a URL is available.
                  if (article['image']?.isNotEmpty ?? false)
                    Image.network(
                      article['image']!,
                      height: 80,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Display a broken image icon if the image fails to load.
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 80,),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        article['title'] ?? 'No title',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
