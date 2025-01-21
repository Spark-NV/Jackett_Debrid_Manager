import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/premiumize_service.dart';
import '../models/premiumize_models.dart';
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'premiumize_provider.g.dart';

class CacheNotifier extends StateNotifier<Map<String, bool>> {
  CacheNotifier() : super({});

  void updateCache(Map<String, bool> newResults) {
    state = {...state, ...newResults};
  }
}

final cacheNotifierProvider = StateNotifierProvider<CacheNotifier, Map<String, bool>>((ref) {
  return CacheNotifier();
});

final premiumizeServiceProvider = Provider<PremiumizeService>((ref) {
  return PremiumizeService(ref.read(cacheNotifierProvider.notifier));
});

final batchCacheCheckProvider = FutureProvider.family<Map<String, bool>, List<String>>((ref, magnetUrls) async {
  final service = ref.read(premiumizeServiceProvider);
  final results = await service.checkCacheBatch(magnetUrls);
  
  ref.read(cacheNotifierProvider.notifier).updateCache(results);

  return results;
});

final cacheStatusProvider = Provider.family<bool?, String>((ref, magnetUrl) {
  return ref.watch(cacheNotifierProvider)[magnetUrl];
});

final accountInfoProvider = FutureProvider<PremiumizeAccountInfo>((ref) async {
  final service = ref.read(premiumizeServiceProvider);
  return service.getAccountInfo();
});

final transfersProvider = FutureProvider.autoDispose<List<PremiumizeTransfer>>((ref) async {
  final service = ref.read(premiumizeServiceProvider);
  return service.getTransfers();
});

final premiumizeApiKeyProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(premiumizeServiceProvider);
  final apiKey = await service.getApiKey();
  return apiKey != null;
});

@riverpod
class TransferNotifier extends _$TransferNotifier {
  @override
  FutureOr<List<PremiumizeTransfer>> build() async {
    return ref.read(premiumizeServiceProvider).getTransfers();
  }

  Future<void> addTransfer(String magnetUrl) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(premiumizeServiceProvider);
      final transfer = await service.addMagnetLink(magnetUrl);
      
      state = AsyncValue.data([transfer, ...?state.value]);
      
      ref.read(cacheNotifierProvider.notifier).updateCache({
        magnetUrl: true,
      });
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> deleteTransfer(String id) async {
    try {
      final service = ref.read(premiumizeServiceProvider);
      await service.deleteTransfer(id);
      
      state = AsyncValue.data(
        state.value?.where((t) => t.id != id).toList() ?? [],
      );
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> clearFinished() async {
    try {
      final service = ref.read(premiumizeServiceProvider);
      await service.clearFinishedTransfers();
      
      final transfers = await service.getTransfers();
      state = AsyncValue.data(transfers);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
} 