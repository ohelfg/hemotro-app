import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/index.dart';
import '../providers/index.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم الإدارية'),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedTabIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedTabIndex = index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('لوحة التحكم'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.tv),
                label: Text('المسلسلات'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.video_library),
                label: Text('الحلقات'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('المستخدمون'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('الإحصائيات'),
              ),
            ],
          ),

          // Main content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildSeriesManagement();
      case 2:
        return _buildEpisodesManagement();
      case 3:
        return _buildUsersManagement();
      case 4:
        return _buildAnalytics();
      default:
        return const Center(child: Text('غير معروف'));
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'لوحة التحكم',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.xxl),

          // Stats grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSizes.lg,
            mainAxisSpacing: AppSizes.lg,
            children: [
              _buildStatCard('المسلسلات', '25', Icons.tv),
              _buildStatCard('الحلقات', '150', Icons.video_library),
              _buildStatCard('المستخدمون', '1,234', Icons.people),
              _buildStatCard('المشاهدات', '45,678', Icons.visibility),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إدارة المسلسلات',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Add new series
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة مسلسل'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xxl),

          // Series list placeholder
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            padding: const EdgeInsets.all(AppSizes.lg),
            child: const Center(
              child: Text('قائمة المسلسلات ستظهر هنا'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodesManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إدارة الحلقات',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Add new episode
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة حلقة'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xxl),

          // Episodes list placeholder
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            padding: const EdgeInsets.all(AppSizes.lg),
            child: const Center(
              child: Text('قائمة الحلقات ستظهر هنا'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إدارة المستخدمين',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.xxl),

          // Users list placeholder
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            padding: const EdgeInsets.all(AppSizes.lg),
            child: const Center(
              child: Text('قائمة المستخدمين ستظهر هنا'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الإحصائيات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.xxl),

          // Analytics placeholder
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            padding: const EdgeInsets.all(AppSizes.lg),
            child: const Center(
              child: Text('الرسوم البيانية والإحصائيات ستظهر هنا'),
            ),
          ),
        ],
      ),
    );
  }
}
