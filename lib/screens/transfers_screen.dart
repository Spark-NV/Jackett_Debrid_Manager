import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/premiumize_provider.dart';
import '../models/premiumize_models.dart';

class TransfersScreen extends ConsumerWidget {
  const TransfersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfers'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(transferNotifierProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: () {
              ref.read(transferNotifierProvider.notifier).clearFinished();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Clearing Finished Transfers...')),
              );
            },
          ),
        ],
      ),
      body: ref.watch(transferNotifierProvider).when(
        data: (transfers) {
          if (transfers.isEmpty) {
            return const Center(
              child: Text('No Active Transfers'),
            );
          }

          return ListView.builder(
            itemCount: transfers.length,
            itemBuilder: (context, index) {
              final transfer = transfers[index];
              return TransferTile(transfer: transfer);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class TransferTile extends ConsumerWidget {
  final PremiumizeTransfer transfer;

  const TransferTile({
    super.key,
    required this.transfer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: ListTile(
        title: Text(
          transfer.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Status: ${transfer.status}'),
            if (transfer.progress > 0)
              LinearProgressIndicator(
                value: transfer.progress / 100,
              ),
            if (transfer.message.isNotEmpty)
              Text(
                transfer.message,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            ref.read(transferNotifierProvider.notifier)
               .deleteTransfer(transfer.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deleting Transfer...')),
            );
          },
        ),
      ),
    );
  }
} 