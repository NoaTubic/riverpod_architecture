import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/base_notifier.dart';
import 'package:example/models/user.dart';
import 'package:example/notifiers/user_detail_notifier.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  const UserDetailScreen({super.key});

  @override
  ConsumerState<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  final TextEditingController _userIdController = TextEditingController(
    text: '1',
  );

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  void _fetchUser() {
    final userId = int.tryParse(_userIdController.text);
    if (userId != null) {
      ref.read(userDetailNotifierProvider.notifier).fetchUser(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userDetailNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BaseNotifier Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fetch User by ID',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _userIdController,
                            decoration: const InputDecoration(
                              labelText: 'User ID',
                              hintText: 'Enter user ID (try 999 for error)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _fetchUser,
                          child: const Text('Fetch'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildStateWidget(userState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateWidget(BaseState<User> state) {
    return switch (state) {
      BaseInitial() => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_search, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Enter a user ID and tap Fetch',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      BaseLoading() => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading user...'),
            ],
          ),
        ),
      BaseError(:final failure) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: ${failure.title}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(userDetailNotifierProvider.notifier).refresh();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      BaseData(:final data) => Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(data.avatarUrl),
                  ),
                  const SizedBox(height: 24),
                  _InfoRow(
                    icon: Icons.badge,
                    label: 'ID',
                    value: data.id.toString(),
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.person,
                    label: 'Name',
                    value: data.name,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.email,
                    label: 'Email',
                    value: data.email,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(userDetailNotifierProvider.notifier).refresh();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          ),
        ),
    };
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('BaseNotifier Example'),
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
              Text('• Using AutoDisposeBaseNotifier'),
              Text('• BaseState with initial/loading/error/data states'),
              Text('• Execute method for async operations'),
              Text('• Error handling with Either<Failure, T>'),
              Text('• Refresh functionality'),
              SizedBox(height: 12),
              Text(
                'Try entering 999 as the user ID to see error handling!',
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
