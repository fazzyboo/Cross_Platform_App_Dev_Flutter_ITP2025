// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
//
// class ProfileScreen extends ConsumerWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userAsync = ref.watch(currentUserProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.orange,
//         foregroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => context.go('/'),
//         ),
//       ),
//       body: userAsync.when(
//         data: (user) {
//           if (user == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.person_off,
//                     size: 100,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Not logged in',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => context.go('/login'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 32,
//                         vertical: 16,
//                       ),
//                     ),
//                     child: const Text('Login'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Profile Header
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(24),
//                   decoration: const BoxDecoration(
//                     color: Colors.orange,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(30),
//                       bottomRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 3),
//                         ),
//                         child: const Icon(
//                           Icons.person,
//                           size: 60,
//                           color: Colors.orange,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         user.email ?? 'No email',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.3),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'Member since ${_formatDate(user.createdAt)}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // Profile Information Cards
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Account Information',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//
//                       _buildInfoCard(
//                         icon: Icons.email,
//                         title: 'Email',
//                         subtitle: user.email ?? 'No email',
//                       ),
//
//                       _buildInfoCard(
//                         icon: Icons.fingerprint,
//                         title: 'User ID',
//                         subtitle: user.id,
//                       ),
//
//                       _buildInfoCard(
//                         icon: Icons.calendar_today,
//                         title: 'Account Created',
//                         subtitle: _formatDateTime(user.createdAt),
//                       ),
//
//                       _buildInfoCard(
//                         icon: Icons.update,
//                         title: 'Last Updated',
//                         subtitle: _formatDateTime(user.updatedAt),
//                       ),
//
//                       _buildInfoCard(
//                         icon: Icons.phone,
//                         title: 'Phone',
//                         subtitle: user.phone ?? 'Not provided',
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       // Action Buttons
//                       _buildActionButton(
//                         context: context,
//                         icon: Icons.shopping_bag,
//                         title: 'My Orders',
//                         color: Colors.blue,
//                         onTap: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Orders feature coming soon!'),
//                             ),
//                           );
//                         },
//                       ),
//
//                       _buildActionButton(
//                         context: context,
//                         icon: Icons.favorite,
//                         title: 'Wishlist',
//                         color: Colors.pink,
//                         onTap: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Wishlist feature coming soon!'),
//                             ),
//                           );
//                         },
//                       ),
//
//                       _buildActionButton(
//                         context: context,
//                         icon: Icons.settings,
//                         title: 'Settings',
//                         color: Colors.grey,
//                         onTap: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Settings feature coming soon!'),
//                             ),
//                           );
//                         },
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // Logout Button
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton.icon(
//                           onPressed: () async {
//                             final authService = ref.read(authServiceProvider);
//                             await authService.signOut();
//                             if (context.mounted) {
//                               context.go('/');
//                             }
//                           },
//                           icon: const Icon(Icons.logout),
//                           label: const Text(
//                             'Logout',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 32),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error, size: 60, color: Colors.red),
//               const SizedBox(height: 16),
//               Text('Error: $error'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.orange.withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: Colors.orange),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: color),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
//
//   String _formatDate(String? dateString) {
//     if (dateString == null) return 'Unknown';
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.month}/${date.year}';
//     } catch (e) {
//       return 'Unknown';
//     }
//   }
//
//   String _formatDateTime(String? dateString) {
//     if (dateString == null) return 'Unknown';
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return 'Unknown';
//     }
//   }
// }