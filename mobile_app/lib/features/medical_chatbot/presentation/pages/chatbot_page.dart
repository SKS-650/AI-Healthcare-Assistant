import 'package:flutter/material.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});
  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Nepali', 'Hindi', 'Bhojpuri'];

  final List<String> _quickReplies = [
    'What is diabetes?',
    'Symptoms of malaria',
    'How to prevent cholera?',
    'First aid for snake bite',
    'Signs of a heart attack',
    'Home remedies for fever',
  ];

  @override
  void initState() {
    super.initState();
    _addBotMessage(
        'Hello! I am your AI Healthcare Assistant. I can help you with '
        'symptom information, disease prevention, nutrition advice, and '
        'emergency guidance.\n\nHow can I help you today?');
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: false));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _textCtrl.clear();
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate AI response delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final response = _generateResponse(text);
    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(text: response, isUser: false));
    });
    _scrollToBottom();
  }

  String _generateResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('diabetes')) {
      return 'Diabetes is a chronic condition where the body cannot properly '
          'regulate blood sugar levels.\n\n'
          '🔹 Type 1: Immune system attacks insulin-producing cells\n'
          '🔹 Type 2: Body becomes resistant to insulin\n\n'
          'Common symptoms: Frequent urination, excessive thirst, '
          'unexplained weight loss, blurred vision.\n\n'
          '⚕️ Please consult an endocrinologist for proper diagnosis.';
    }
    if (lower.contains('malaria')) {
      return 'Malaria is a mosquito-borne infectious disease.\n\n'
          '🔹 Symptoms: Fever, chills, headache, nausea, vomiting\n'
          '🔹 Prevention: Use mosquito nets, repellents, wear protective clothing\n'
          '🔹 Treatment: Antimalarial medications prescribed by doctor\n\n'
          '⚠️ Seek immediate medical care if symptoms appear.';
    }
    if (lower.contains('cholera')) {
      return 'Cholera prevention tips:\n\n'
          '✅ Drink only safe, treated water\n'
          '✅ Wash hands with soap regularly\n'
          '✅ Eat properly cooked food\n'
          '✅ Avoid raw seafood\n'
          '✅ Use sanitary toilet facilities\n\n'
          '🚨 If you experience severe diarrhea, seek medical help immediately.';
    }
    if (lower.contains('snake')) {
      return '🚨 Snake Bite First Aid:\n\n'
          '1. Keep the victim calm and still\n'
          '2. Remove jewelry/tight clothing near bite\n'
          '3. Keep bitten limb below heart level\n'
          '4. Do NOT suck venom or apply tourniquet\n'
          '5. Transport to hospital IMMEDIATELY\n\n'
          '⚕️ Antivenom must be administered by medical professionals.';
    }
    if (lower.contains('heart attack')) {
      return '🚨 Heart Attack Warning Signs:\n\n'
          '• Chest pain or pressure\n'
          '• Pain spreading to arm, jaw, neck\n'
          '• Shortness of breath\n'
          '• Cold sweats, nausea\n'
          '• Dizziness or fainting\n\n'
          '📞 CALL EMERGENCY SERVICES IMMEDIATELY!\n'
          'Chew aspirin if available and not allergic.';
    }
    if (lower.contains('fever')) {
      return 'Home remedies for fever:\n\n'
          '💧 Stay well hydrated\n'
          '🛏️ Rest as much as possible\n'
          '🌡️ Take paracetamol if temp > 38.5°C\n'
          '🧊 Cool compress on forehead\n'
          '🍲 Light, nutritious meals\n\n'
          '⚠️ Seek medical care if fever exceeds 39.5°C or lasts more than 3 days.';
    }
    if (lower.contains('hello') || lower.contains('hi')) {
      return 'Hello! How can I assist with your health today? '
          'You can ask me about:\n'
          '• Disease symptoms\n'
          '• Preventive care\n'
          '• First aid\n'
          '• Nutrition advice\n'
          '• Emergency guidance';
    }
    return 'Thank you for your question about "$input".\n\n'
        'For accurate medical advice, I recommend:\n'
        '1. Consulting a licensed healthcare provider\n'
        '2. Using our Symptom Checker for AI analysis\n'
        '3. Visiting a nearby hospital for serious concerns\n\n'
        'Is there anything specific I can help you with today?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_rounded,
                size: 18, color: AppColors.textPrimary),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                gradient: AppColors.gradientPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Health Assistant',
                    style: AppTextStyles.titleMedium),
                Row(
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text('Online', style: AppTextStyles.caption
                        .copyWith(color: AppColors.accent)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _languageSelector(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _messages.length +
                  (_isTyping ? 1 : 0) +
                  (_messages.length == 1 ? 1 : 0),
              itemBuilder: (context, index) {
                // Quick replies after welcome message
                if (_messages.length == 1 && index == 1) {
                  return _quickRepliesRow();
                }
                final msgIdx =
                    (_messages.length == 1 && index > 1) ? index - 1 : index;
                if (_isTyping && msgIdx == _messages.length) {
                  return _typingIndicator();
                }
                if (msgIdx < _messages.length) {
                  return _MessageBubble(message: _messages[msgIdx]);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _languageSelector() => GestureDetector(
        onTap: () => _showLanguageSheet(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(_selectedLanguage.substring(0, 2).toUpperCase(),
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      );

  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Language', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 16),
            ..._languages.map((lang) => ListTile(
                  title: Text(lang, style: AppTextStyles.titleMedium),
                  trailing: _selectedLanguage == lang
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedLanguage = lang);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _quickRepliesRow() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Suggested Questions',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.primary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickReplies
                  .map((q) => GestureDetector(
                        onTap: () => _sendMessage(q),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.primary
                                .withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusFull),
                            border: Border.all(
                                color: AppColors.primary
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Text(q,
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary)),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      );

  Widget _typingIndicator() => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              bottomLeft: Radius.circular(4),
            ),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dot(0),
              const SizedBox(width: 4),
              _dot(150),
              const SizedBox(width: 4),
              _dot(300),
            ],
          ),
        ),
      );

  Widget _dot(int delayMs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (_, v, __) => Opacity(
        opacity: v,
        child: Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
              color: AppColors.textTertiary, shape: BoxShape.circle),
        ),
      ),
    );
  }

  Widget _inputBar() => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
              top: BorderSide(color: AppColors.border, width: 1)),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(
                        AppSpacing.radiusFull),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _textCtrl,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Ask a health question...',
                      hintStyle: AppTextStyles.bodySmall,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: _sendMessage,
                    textInputAction: TextInputAction.send,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AnimatedPress(
                onTap: () => _sendMessage(_textCtrl.text),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: AppColors.shadowPrimary,
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      );
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: message.isUser ? AppColors.gradientPrimary : null,
          color: message.isUser ? null : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 18),
          ),
          border: message.isUser
              ? null
              : Border.all(color: AppColors.border),
          boxShadow: AppColors.shadowCard,
        ),
        child: Text(
          message.text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: message.isUser
                ? Colors.white
                : AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
