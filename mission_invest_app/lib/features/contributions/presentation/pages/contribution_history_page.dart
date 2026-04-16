import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../providers/contribution_provider.dart';
import '../widgets/contribution_tile.dart';

class ContributionHistoryPage extends ConsumerWidget {
  final String missionId;

  const ContributionHistoryPage({super.key, required this.missionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Not signed in')),
      );
    }
    final contributionsAsync = ref.watch(
      missionContributionsProvider((missionId: missionId, userId: userId)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Contribution History')),
      body: contributionsAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (error, _) => Center(
          child: Text('Failed to load contributions: $error'),
        ),
        data: (contributions) {
          if (contributions.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(
                  missionContributionsProvider((missionId: missionId, userId: userId)),
                );
              },
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: const Center(
                      child: EmptyState(
                        icon: Icons.history,
                        title: 'No contributions yet',
                        subtitle:
                            'Log your first contribution to start tracking progress.',
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          final total = contributions.fold<double>(
            0,
            (sum, c) => sum + c.amount,
          );

          return Column(
            children: [
              // Summary card
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${contributions.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Contributions',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              CurrencyFormatter.format(total),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Total Saved',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(
                      missionContributionsProvider((missionId: missionId, userId: userId)),
                    );
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: contributions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final c = contributions[index];
                      return ContributionTile(
                        amount: c.amount,
                        date: c.date,
                        streakDay: c.streakDay,
                        note: c.note,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
