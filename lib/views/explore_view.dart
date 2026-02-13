import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controllers.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final _searchCtrl = TextEditingController();
  bool _isFocused = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Consumer<ExploreController>(
          builder: (_, ctrl, __) => Column(
            children: [
              _SearchBar(
                controller: _searchCtrl,
                focusNode: _focusNode,
                isFocused: _isFocused,
                onChanged: ctrl.setSearchQuery,
                onClear: () {
                  _searchCtrl.clear();
                  ctrl.clearSearch();
                  _focusNode.unfocus();
                },
              ),
              Expanded(
                child: ctrl.isSearching
                    ? _SearchResults(ctrl: ctrl)
                    : _ExploreGrid(ctrl: ctrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                style: const TextStyle(
                    color: AppTheme.textPrimary, fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: AppTheme.textTertiary),
                  prefixIcon: Icon(Icons.search,
                      color: AppTheme.textTertiary, size: 20),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isFocused ? 60 : 0,
            child: isFocused
                ? TextButton(
                    onPressed: onClear,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: AppTheme.textPrimary, fontSize: 14),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class _ExploreGrid extends StatelessWidget {
  final ExploreController ctrl;
  const _ExploreGrid({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    if (ctrl.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.textSecondary),
      );
    }

    return CustomScrollView(
      slivers: [
        // Category chips
        SliverToBoxAdapter(
          child: _CategoryChips(),
        ),
        // Main grid
        SliverPadding(
          padding: const EdgeInsets.all(2),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _GridTile(item: ctrl.grid[i]),
              childCount: ctrl.grid.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount(i: 0, total: ctrl.grid.length),
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  int _crossAxisCount({required int i, required int total}) => 3;
}

class _CategoryChips extends StatefulWidget {
  @override
  State<_CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<_CategoryChips> {
  int _selected = 0;
  final _cats = ['For You', 'Reels', 'Photos', 'Videos', 'Style', 'Travel', 'Food'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: _cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => setState(() => _selected = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: i == _selected
                  ? AppTheme.textPrimary
                  : AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _cats[i],
              style: TextStyle(
                color: i == _selected
                    ? AppTheme.background
                    : AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const _GridTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(url: item['url'] as String),
          // Reel indicator
          if (item['type'] == 'reel')
            const Positioned(
              top: 6,
              right: 6,
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 18,
              ),
            ),
          // Carousel indicator
          if (item['isCarousel'] == true)
            const Positioned(
              top: 6,
              right: 6,
              child: Icon(
                Icons.copy,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final ExploreController ctrl;
  const _SearchResults({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Recent searches header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Recent',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...ctrl.suggestedUsers.map((u) => ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.storyGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.background),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(u.avatarUrl),
                    ),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    u.username,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (u.isVerified) ...[
                    const SizedBox(width: 4),
                    const VerifiedBadge(),
                  ],
                ],
              ),
              subtitle: Text(
                u.displayName,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                onPressed: () {},
              ),
            )),
      ],
    );
  }
}
