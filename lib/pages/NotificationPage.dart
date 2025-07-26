import 'package:flutter/material.dart';
import 'package:spicebite/pages/GlobalState.dart';
import 'package:intl/intl.dart';
import 'package:spicebite/pages/OrderHistory.dart';
import 'package:spicebite/pages/navigationBar.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);

  final GlobalState globalState = GlobalState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        actions: [
          if (globalState.notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                globalState.markAllNotificationsRead();
                (context as Element).markNeedsBuild();
              },
              child: const Text('Mark all as read', style: TextStyle(color: Colors.orange)),
            ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
      body: ValueListenableBuilder<int>(
        valueListenable: globalState.notificationCount,
        builder: (context, count, _) {
          final notifications = globalState.notifications;
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.orange[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'No notifications yet!',
                    style: TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final isUnread = notification['read'] == false;
              final time = notification['timestamp'] as DateTime;
              return Container(
                decoration: BoxDecoration(
                  color: isUnread ? Colors.orange[100] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    isUnread ? Icons.notifications_active : Icons.notifications,
                    color: Colors.orange,
                    size: 32,
                  ),
                  title: Text(
                    notification['message'],
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('MMM d, h:mm a').format(time),
                    style: TextStyle(color: Colors.orange[700], fontSize: 13),
                  ),
                  trailing: isUnread
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                  onTap: () {
                    if (globalState.notifications[index]['read'] == false) {
                      globalState.notifications[index]['read'] = true;
                      globalState.notificationCount.value--;
                    }
                    (context as Element).markNeedsBuild();
                    globalState.setSelectedOrderId(globalState.notifications[index]['orderId']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Navigation(selectedIndex: 1),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      
    );
  }
} 