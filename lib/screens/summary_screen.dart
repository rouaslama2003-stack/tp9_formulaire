import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import 'step_one_screen.dart';

class SummaryScreen extends StatefulWidget {
  final UserProfile profil;

  const SummaryScreen({super.key, required this.profil});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _formKey = GlobalKey<FormState>();

  void _retourDebut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StepOneScreen()),
      (route) => false,
    );
  }

  Future<void> _reinitialiser() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Réinitialiser ?'),
        content: const Text('Toutes les données saisies seront perdues.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
    if (confirme == true && mounted) _retourDebut();
  }

  Future<void> _confirmer() async {
    if (!_formKey.currentState!.validate()) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Compte créé !'),
        content: Text(
          'Bienvenue ${widget.profil.prenom}.\n'
          'Un e-mail de confirmation a été envoyé à ${widget.profil.email}.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
    if (mounted) _retourDebut();
  }

  Widget _section(String titre, List<Widget> lignes) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                titre,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...lignes,
          ],
        ),
      ),
    );
  }

  Widget _ligne(IconData icone, String libelle, String valeur) {
    return ListTile(
      leading: Icon(icone),
      title: Text(libelle),
      subtitle: Text(valeur.isEmpty ? 'Non renseigné' : valeur),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.profil;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Récapitulatif de votre profil'),
        actions: [
          IconButton(
            tooltip: 'Réinitialiser',
            icon: const Icon(Icons.restart_alt),
            onPressed: _reinitialiser,
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: 1),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section('Identité', [
                _ligne(Icons.person_outline, 'Nom complet', p.nomComplet),
                _ligne(Icons.email_outlined, 'E-mail', p.email),
                _ligne(
                  Icons.lock_outline,
                  'Mot de passe',
                  '•' * p.password.length,
                ),
              ]),
              _section('Profil professionnel', [
                _ligne(Icons.work_outline, 'Profession', p.profession),
                _ligne(Icons.timeline, 'Expérience', '${p.experience} an(s)'),
                _ligne(Icons.euro, 'TJM', '${p.tjm.toStringAsFixed(2)} €'),
                _ligne(Icons.notes, 'Biographie', p.biographie),
              ]),
              FormField<bool>(
                initialValue: false,
                validator: (v) => v == true
                    ? null
                    : "Vous devez accepter les conditions d'utilisation",
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      value: field.value,
                      onChanged: field.didChange,
                      title: const Text(
                        "J'accepte les conditions d'utilisation",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          field.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _confirmer,
                icon: const Icon(Icons.check),
                label: const Text('Confirmer et créer le compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
