import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/help_topics.dart';

/// Centro de ayuda con forma de conversación.
///
/// La ayuda clásica —una lista de artículos— obliga a leer de más para
/// encontrar una frase. Aquí se toca la pregunta y la respuesta aparece al
/// momento, como un chat: lo que se busca es resolver la duda en un toque, no
/// navegar por un manual.
///
/// No hay nada remoto detrás. Las respuestas están en la app y salen
/// traducidas, así que funcionan sin conexión y sin esperar a nadie.
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

/// Un turno de la conversación.
class _Turn {
  final bool fromUser;
  final String text;
  const _Turn({required this.fromUser, required this.text});
}

class _HelpScreenState extends State<HelpScreen> {
  final _scroll = ScrollController();
  final _searchController = TextEditingController();

  final List<_Turn> _turns = [];

  /// Preguntas sugeridas ahora mismo. Vacío significa mostrar las categorías.
  List<String> _suggested = [];
  String _query = '';

  @override
  void dispose() {
    _scroll.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    // Tras el frame: la burbuja nueva todavía no está medida cuando se pide.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  void _ask(HelpTopic topic) {
    setState(() {
      _turns.add(_Turn(fromUser: true, text: topic.question));
      _turns.add(_Turn(fromUser: false, text: topic.answer));
      _suggested = topic.related;
      _query = '';
      _searchController.clear();
    });
    FocusScope.of(context).unfocus();
    _scrollToEnd();
  }

  void _reset() {
    setState(() {
      _suggested = [];
      _query = '';
      _searchController.clear();
    });
    _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final topics = helpTopics(context);
    final byId = {for (final t in topics) t.id: t};

    final matches = _query.trim().isEmpty
        ? const <HelpTopic>[]
        : topics.where((t) {
            final q = _query.toLowerCase();
            return t.question.toLowerCase().contains(q) ||
                t.answer.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l.helpTitle,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          _SearchBar(
            controller: _searchController,
            hint: l.helpSearchHint,
            onChanged: (v) => setState(() => _query = v),
          ),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
              children: [
                _Bubble(text: l.helpGreeting, fromUser: false),
                for (final turn in _turns)
                  _Bubble(text: turn.text, fromUser: turn.fromUser),
                const SizedBox(height: 6),

                if (_query.trim().isNotEmpty)
                  ..._searchResults(l, matches)
                else if (_suggested.isNotEmpty)
                  ..._followUps(l, byId)
                else
                  ..._allCategories(l, byId),

                const SizedBox(height: 18),
                _StillStuck(title: l.helpStillStuck, body: l.helpContact),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _searchResults(AppLocalizations l, List<HelpTopic> matches) {
    if (matches.isEmpty) {
      return [_Hint(l.helpNoResults)];
    }
    return [
      for (final t in matches) _QuestionChip(text: t.question, onTap: () => _ask(t)),
    ];
  }

  List<Widget> _followUps(AppLocalizations l, Map<String, HelpTopic> byId) {
    return [
      _Hint(l.helpRelated),
      for (final id in _suggested)
        if (byId[id] != null)
          _QuestionChip(text: byId[id]!.question, onTap: () => _ask(byId[id]!)),
      const SizedBox(height: 4),
      Center(
        child: TextButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.list_rounded, size: 18),
          label: Text(l.helpBackToTopics),
          style: TextButton.styleFrom(foregroundColor: AppColors.primaryDark),
        ),
      ),
    ];
  }

  List<Widget> _allCategories(AppLocalizations l, Map<String, HelpTopic> byId) {
    final widgets = <Widget>[
      if (_turns.isNotEmpty) _Hint(l.helpMoreQuestions),
    ];
    for (final cat in helpCategories(context)) {
      widgets.add(_CategoryLabel(cat.title));
      for (final id in cat.topicIds) {
        final t = byId[id];
        if (t == null) continue;
        widgets.add(_QuestionChip(text: t.question, onTap: () => _ask(t)));
      }
    }
    return widgets;
  }
}

// ── piezas ──────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool fromUser;

  const _Bubble({required this.text, required this.fromUser});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(fromUser ? 16 : 4),
      bottomRight: Radius.circular(fromUser ? 4 : 16),
    );

    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: fromUser ? const Color(0xFFDCF3C9) : Colors.white,
          borderRadius: radius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.5,
            height: 1.42,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _QuestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _QuestionChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.82,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3EC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFC9E0D0)),
              ),
              child: Text(
                text,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  final String text;
  const _CategoryLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE3E8E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  final String text;
  const _Hint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _StillStuck extends StatelessWidget {
  final String title;
  final String body;

  const _StillStuck({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E7E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.support_agent_rounded,
                  size: 18, color: AppColors.primaryDark),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
