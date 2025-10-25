import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/paginated_notifier.dart';
import 'package:example/models/user.dart';
import 'package:example/notifiers/users_notifier.dart';

class UsersListScreen extends ConsumerWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PaginatedNotifier Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(usersNotifierProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: switch (usersState) {
        PaginatedLoading() => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading users...'),
              ],
            ),
          ),
        PaginatedLoadingMore(:final list) => _buildUserList(
            context,
            ref,
            list,
            isLoadingMore: true,
          ),
        PaginatedLoaded(:final list, :final isLastPage) => _buildUserList(
            context,
            ref,
            list,
            isLastPage: isLastPage,
          ),
        PaginatedError(:final list, :final failure) => list.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${failure.title}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(usersNotifierProvider.notifier).refresh();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _buildUserList(
                context,
                ref,
                list,
                error: failure.title,
              ),
      },
    );
  }

  Widget _buildUserList(
    BuildContext context,
    WidgetRef ref,
    List<User> users, {
    bool isLoadingMore = false,
    bool isLastPage = false,
    String? error,
  }) {
    return Column(
      children: [
        if (error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.red.shade100,
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(usersNotifierProvider.notifier).getNextPage();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: users.length + (isLoadingMore || !isLastPage ? 1 : 0),
            itemBuilder: (context, index) {
              // Loading indicator at the end
              if (index == users.length) {
                if (isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (!isLastPage) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(usersNotifierProvider.notifier)
                              .getNextPage();
                        },
                        child: const Text('Load More'),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(
                  '#${user.id}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        if (isLastPage && users.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'All users loaded',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PaginatedNotifier Example'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This example demonstrates:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Using AutoDisposePaginatedNotifier'),
              Text('• PaginatedState with loading/loadingMore/loaded/error'),
              Text('• Automatic first page loading'),
              Text('• Load more functionality'),
              Text('• Error handling with partial data'),
              Text('• Refresh functionality'),
              Text('• Last page detection'),
              SizedBox(height: 12),
              Text(
                'Scroll to the bottom and tap "Load More" to load additional pages!',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
