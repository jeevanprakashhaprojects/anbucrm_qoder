import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_skeleton_widget.dart';
import '../leads_list_screen/leads_list_screen.dart';
import '../leads_list_screen/widgets/lead_card_widget.dart';

/// Customers screen — shows only leads with Won or Result status
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearchActive = false;
  final _searchController = TextEditingController();
  List<LeadModel> _customers = [];

  static final List<Map<String, dynamic>> _globalLeadMaps = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _customers = _globalLeadMaps
            .where((m) => m['status'] == 'Won' || m['status'] == 'Result')
            .map(LeadModel.fromMap)
            .toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _customers = _globalLeadMaps
            .where((m) => m['status'] == 'Won' || m['status'] == 'Result')
            .map(LeadModel.fromMap)
            .toList();
        _isLoading = false;
      });
    }
  }

  List<LeadModel> get _filtered {
    if (_searchQuery.isEmpty) return _customers;
    return _customers
        .where(
          (c) =>
              c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.phone.contains(_searchQuery),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navBarHeight = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(bottom: navBarHeight),
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppTheme.primary,
          child: CustomScrollView(
            slivers: [
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              snap: true,
              backgroundColor: AppTheme.backgroundLight,
              elevation: 0,
              scrolledUnderElevation: 1,
              title: _isSearchActive
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search customers...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppTheme.textMuted,
                        ),
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                      onChanged: (v) => setState(() => _searchQuery = v),
                    )
                  : Text(
                      'Customers',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isSearchActive
                        ? Icons.close_rounded
                        : Icons.search_rounded,
                    color: AppTheme.textPrimary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearchActive = !_isSearchActive;
                      if (!_isSearchActive) {
                        _searchController.clear();
                        _searchQuery = '';
                      }
                    });
                  },
                ),
              ],
            ),
            // Stats banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.success, AppTheme.success.withAlpha(200)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.people_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_customers.length} Converted Customers',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            'Leads with Won / Result status',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.white.withAlpha(200),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Results count
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  _isLoading
                      ? 'Loading...'
                      : '${_filtered.length} customer${_filtered.length != 1 ? 's' : ''}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
            // Customer list
            if (_isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => const LeadCardSkeletonWidget(),
                  childCount: 3,
                ),
              )
            else if (_filtered.isEmpty)
              SliverFillRemaining(
                child: EmptyStateWidget(
                  icon: Icons.people_outline_rounded,
                  title: 'No customers yet',
                  subtitle:
                      'Customers appear here when leads are marked as Won or Result',
                  ctaLabel: 'View Leads',
                  onCta: () => context.go(AppRoutes.leadsListScreen),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.only(bottom: navBarHeight + 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        LeadCardWidget(lead: _filtered[index], index: index),
                    childCount: _filtered.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}
