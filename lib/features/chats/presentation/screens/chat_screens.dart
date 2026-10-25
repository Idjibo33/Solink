import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:so_link/features/chats/domain/repositories/chat_repository.dart';
import 'package:so_link/features/chats/presentation/cubit/chat_cubit.dart';
import 'package:so_link/features/chats/presentation/cubit/conversations_cubit.dart';
import 'package:so_link/features/chats/presentation/widgets/chat_widgets.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthCubit>().state.user;
    if (currentUser == null) {
      return const Scaffold(body: AppLoading());
    }

    return BlocProvider(
      key: ValueKey(currentUser.id),
      create: (context) => ConversationsCubit(
        repository: context.read<AuthRepository>(),
        currentUserId: currentUser.id,
      )..load(),
      child: const _ConversationsView(),
    );
  }
}

class _ConversationsView extends StatelessWidget {
  const _ConversationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discussions')),
      body: BlocBuilder<ConversationsCubit, ConversationsState>(
        builder: (context, state) {
          if (state.status == ConversationsStatus.loading ||
              state.status == ConversationsStatus.initial) {
            return const AppLoading();
          }
          if (state.status == ConversationsStatus.failure) {
            return AppErrorState(
              message:
                  state.errorMessage ?? 'Impossible de charger les profils.',
              onRetry: () => context.read<ConversationsCubit>().load(),
            );
          }
          if (state.isEmpty) {
            return const AppEmptyState(
              message: 'Aucun autre membre pour le moment.',
              icon: Icons.people_outline,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.users.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) =>
                ConversationTile(user: state.users[index]),
          );
        },
      ),
    );
  }
}

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({
    super.key,
    required this.receiverId,
    this.initialReceiver,
  });

  final String receiverId;
  final UserModel? initialReceiver;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthCubit>().state.user;
    if (currentUser == null) {
      return const Scaffold(body: AppLoading());
    }

    return BlocProvider(
      key: ValueKey('${currentUser.id}-$receiverId'),
      create: (context) =>
          ChatCubit(
            chatRepository: context.read<ChatRepository>(),
            authRepository: context.read<AuthRepository>(),
          )..open(
            currentUser: currentUser,
            receiverId: receiverId,
            initialReceiver: initialReceiver,
          ),
      child: _ChatRoomView(currentUser: currentUser),
    );
  }
}

class _ChatRoomView extends StatefulWidget {
  const _ChatRoomView({required this.currentUser});

  final UserModel currentUser;

  @override
  State<_ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<_ChatRoomView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final cubit = context.read<ChatCubit>();
    await cubit.send(
      currentUser: widget.currentUser,
      content: _controller.text,
    );
    if (mounted && cubit.state.errorMessage == null) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        context.read<ChatCubit>().clearError();
      },
      builder: (context, state) {
        final receiver = state.receiver;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              spacing: 8,
              children: [
                UserAvatar(username: receiver?.displayName ?? '?', size: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receiver?.displayName ?? 'Discussion',
                        style: AppTextStyles.title.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (receiver != null)
                        Text(
                          receiver.bio.isEmpty ? 'Membre SoLink' : receiver.bio,
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildMessages(state)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                  child: Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: SimpleTextField(
                          controller: _controller,
                          hint: 'Envoyer un message',
                        ),
                      ),
                      IconButton(
                        onPressed: state.isSending ? null : _send,
                        icon: state.isSending
                            ? const AppLoading(size: 18)
                            : const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessages(ChatState state) {
    if (state.status == ChatStatus.loading ||
        state.status == ChatStatus.initial) {
      return const AppLoading();
    }
    if (state.status == ChatStatus.failure) {
      return AppErrorState(
        message: state.errorMessage ?? 'Impossible de charger la discussion.',
      );
    }
    if (state.messages.isEmpty) {
      return const AppEmptyState(
        message: 'Aucun message pour le moment.',
        icon: Icons.chat_bubble_outline,
      );
    }
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        return ChatBubble(
          message: message,
          isMine: message.senderId == widget.currentUser.id,
        );
      },
    );
  }
}
