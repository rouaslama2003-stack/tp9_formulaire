import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../utils/validators.dart';
import 'step_two_screen.dart';

class StepOneScreen extends StatefulWidget {
  const StepOneScreen({super.key});

  @override
  State<StepOneScreen> createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _confirmKey = GlobalKey<FormFieldState<String>>();

  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _masquerMdp = true;
  bool _masquerConfirm = true;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _suivant() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez corriger les champs en rouge')),
      );
      return;
    }
    final profil = UserProfile(
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StepTwoScreen(profil: profil)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription - Étape 1/3'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: 1 / 3),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.nom(v, champ: 'Le nom'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prenomCtrl,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.prenom(v, champ: 'Le prénom'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'nom@domaine.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _masquerMdp,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  helperText: '8 caractères min., 1 majuscule, 1 chiffre',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _masquerMdp ? 'Afficher' : 'Masquer',
                    icon: Icon(
                      _masquerMdp ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _masquerMdp = !_masquerMdp),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: Validators.motDePasse,
                onChanged: (_) {
                  // Revalide la confirmation si elle est déjà remplie
                  if (_confirmCtrl.text.isNotEmpty) {
                    _confirmKey.currentState?.validate();
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: _confirmKey,
                controller: _confirmCtrl,
                obscureText: _masquerConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    tooltip: _masquerConfirm ? 'Afficher' : 'Masquer',
                    icon: Icon(
                      _masquerConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _masquerConfirm = !_masquerConfirm),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _suivant(),
                validator: (v) =>
                    Validators.confirmation(v, _passwordCtrl.text),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _suivant,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Suivant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
