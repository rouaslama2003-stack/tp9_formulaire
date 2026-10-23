import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_profile.dart';
import '../utils/validators.dart';
import 'summary_screen.dart';

class StepTwoScreen extends StatefulWidget {
  final UserProfile profil;

  const StepTwoScreen({super.key, required this.profil});

  @override
  State<StepTwoScreen> createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _professionCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _tjmCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  @override
  void dispose() {
    _professionCtrl.dispose();
    _experienceCtrl.dispose();
    _tjmCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _suivant() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final profilComplet = widget.profil.copyWith(
      profession: _professionCtrl.text.trim(),
      experience: int.parse(_experienceCtrl.text.trim()),
      tjm: double.parse(_tjmCtrl.text.trim().replaceAll(',', '.')),
      biographie: _bioCtrl.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SummaryScreen(profil: profilComplet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour à l\'étape 1',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profil Professionnel - Étape 2/3'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: 2 / 3),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Bonjour ${widget.profil.prenom}, parlez-nous de votre activité.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _professionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Profession',
                  hintText: 'Ex. : Développeur mobile',
                  prefixIcon: Icon(Icons.work_outline),
                ),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                validator: Validators.profession,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceCtrl,
                decoration: const InputDecoration(
                  labelText: "Années d'expérience",
                  prefixIcon: Icon(Icons.timeline),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                textInputAction: TextInputAction.next,
                validator: Validators.experience,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tjmCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tarif Journalier Moyen (TJM)',
                  prefixIcon: Icon(Icons.euro),
                  suffixText: '€',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  // chiffres, un seul séparateur (. ou ,), 2 décimales max
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*[.,]?\d{0,2}'),
                  ),
                ],
                textInputAction: TextInputAction.next,
                validator: Validators.tjm,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioCtrl,
                decoration: const InputDecoration(
                  labelText: 'Biographie (facultative)',
                  hintText: 'Présentez votre parcours en quelques lignes',
                  alignLabelWithHint: true,
                ),
                minLines: 3,
                maxLines: 5,
                maxLength: 300,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                validator: Validators.biographie,
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
