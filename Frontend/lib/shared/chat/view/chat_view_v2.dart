import 'package:flutter/material.dart';
import '../viewmodel/chat_viewmodel_v2.dart';
import '../../../core/models/chat_message.dart';
import '../../../core/theme/app_colors.dart';

/// Type-safe Chat View with realtime updates
class ChatViewV2 extends StatefulWidget {
  final String contactName;
  final String mitraId;
  final String bumdesId;
  final String currentUserType; // 'mitra' or 'bumdes'

  const ChatViewV2({
    super.key,
    required this.contactName,
    required this.mitraId,
    required this.bumdesId,
    required this.currentUserType,
  });

  @override
  State<ChatViewV2> createState() => _ChatViewV2State();
}

class _ChatViewV2State extends State<ChatViewV2> with WidgetsBindingObserver {
  late ChatViewModelV2 _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _viewModel = ChatViewModelV2(
      mitraId: widget.mitraId,
      bumdesId: widget.bumdesId,
      currentUserType: widget.currentUserType,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh messages when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _viewModel.refreshMessages();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Error banner
          _buildErrorBanner(),
          
          // Messages list
          Expanded(child: _buildMessagesList()),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          _buildAvatar(widget.contactName, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contactName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    return _buildStatusText();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _viewModel.refreshMessages,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildStatusText() {
    if (_viewModel.isOtherUserTyping) {
      return const Text(
        'Mengetik...',
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _viewModel.isConnected ? Colors.greenAccent : Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          _viewModel.isConnected ? 'Online' : 'Offline',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final error = _viewModel.error;
        if (error == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.red.shade100,
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: _viewModel.clearError,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessagesList() {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading && _viewModel.messages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (_viewModel.messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat_bubble_outline, 
                     size: 64, 
                     color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Belum ada pesan',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mulai percakapan dengan mengirim pesan',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _viewModel.scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _viewModel.messages.length + 
                     (_viewModel.isOtherUserTyping ? 1 : 0),
          itemBuilder: (context, index) {
            // Show typing indicator at the end
            if (index == _viewModel.messages.length && 
                _viewModel.isOtherUserTyping) {
              return _buildTypingIndicator();
            }

            final message = _viewModel.messages[index];
            return _buildMessageBubble(message);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessageUI message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isSentByMe 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isSentByMe) ...[
            _buildAvatar(widget.contactName, size: 32),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: message.status == MessageStatus.failed
                  ? () => _showRetryDialog(message)
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, 
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: message.isSentByMe
                      ? _getMessageColor(message.status)
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isSentByMe ? 16 : 4),
                    bottomRight: Radius.circular(message.isSentByMe ? 4 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isSentByMe
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            color: message.isSentByMe
                                ? Colors.white70
                                : Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                        if (message.isSentByMe) ...[
                          const SizedBox(width: 4),
                          _buildStatusIcon(message.status),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMessageColor(MessageStatus status) {
    switch (status) {
      case MessageStatus.failed:
        return Colors.red.shade400;
      case MessageStatus.sending:
        return AppColors.primary.withOpacity(0.7);
      default:
        return AppColors.primary;
    }
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Colors.white70,
          ),
        );
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: Colors.white70);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Colors.white70);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 14, color: Colors.lightBlueAccent);
      case MessageStatus.failed:
        return const Icon(Icons.error_outline, size: 14, color: Colors.white);
    }
  }

  void _showRetryDialog(ChatMessageUI message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pesan gagal terkirim'),
        content: const Text('Apakah Anda ingin mencoba mengirim ulang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _viewModel.retrySendMessage(message.id);
            },
            child: const Text('Kirim Ulang'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name, {double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildAvatar(widget.contactName, size: 32),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const _TypingDots(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _viewModel.messageController,
                  decoration: const InputDecoration(
                    hintText: 'Ketik pesan...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _viewModel.sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return Container(
                  decoration: BoxDecoration(
                    color: _viewModel.isSending 
                        ? AppColors.primary.withOpacity(0.7)
                        : AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: _viewModel.isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _viewModel.isSending 
                        ? null 
                        : _viewModel.sendMessage,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated typing dots
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = (_controller.value + delay) % 1.0;
            final scale = 0.5 + (0.5 * _bounce(value));

            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.4 + (0.6 * scale)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double _bounce(double t) {
    if (t < 0.5) {
      return 4 * t * t * t;
    } else {
      return 1 - ((-2 * t + 2) * (-2 * t + 2) * (-2 * t + 2)) / 2;
    }
  }
}
