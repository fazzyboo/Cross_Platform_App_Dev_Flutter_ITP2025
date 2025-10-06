import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rest_api_call/models/news_item.dart';
import 'package:rest_api_call/news_provider.dart';

class BestStoriesScreen extends ConsumerWidget {
  const BestStoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<NewsItem>> bestStories = ref.watch(bestStoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News Best Stories'),
      ),
      body: bestStories.when(
        data: (stories) {
          if (stories.isEmpty) {
            return const Center(child: Text('No stories found.'));
          }
          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    context.push('/details/${story.id}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.title ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('By: ${story.by ?? 'Unknown'}'),
                        Text('Score: ${story.score ?? 0}'),
                        Text('Comments: ${story.descendants ?? 0}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
