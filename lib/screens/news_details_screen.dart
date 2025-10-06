import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import kDebugMode
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rest_api_call/news_provider.dart';

class NewsDetailsScreen extends ConsumerWidget {
  final int itemId;
  const NewsDetailsScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsItemAsyncValue = ref.watch(newsItemDetailsProvider(itemId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: newsItemAsyncValue.when(
        data: (newsItem) {
          // Print the full JSON to the terminal
          if (kDebugMode) {
            print('Full JSON for story ID ${newsItem.id}:');
            print(newsItem.toJson());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsItem.title ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('By: ${newsItem.by ?? 'Unknown'}', style: const TextStyle(fontSize: 16)),
                Text('Score: ${newsItem.score ?? 0}', style: const TextStyle(fontSize: 16)),
                Text('Comments: ${newsItem.descendants ?? 0}', style: const TextStyle(fontSize: 16)),
                Text('Time: ${newsItem.time != null ? DateTime.fromMillisecondsSinceEpoch(newsItem.time! * 1000) : 'N/A'}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                if (newsItem.url != null && newsItem.url!.isNotEmpty && newsItem.url != 'No URL')
                  InkWell(
                    onTap: () async {
                      final uri = Uri.parse(newsItem.url!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch ${newsItem.url}')),
                        );
                      }
                    },
                    child: Text(
                      'Read full story: ${newsItem.url}',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                  ),
                if (newsItem.kids != null && newsItem.kids!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Comments:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer(
                    builder: (context, ref, _) {
                      final commentsAsyncValue = ref.watch(storyCommentsProvider(newsItem.kids!));
                      return commentsAsyncValue.when(
                        data: (comments) {
                          if (comments.isEmpty) {
                            return const Text('No comments found.');
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'By: ${comment.by ?? 'Unknown'}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comment.text ?? 'No comment text.',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Time: ${comment.time != null ? DateTime.fromMillisecondsSinceEpoch(comment.time! * 1000) : 'N/A'}',
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(child: Text('Error loading comments: $error')),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
