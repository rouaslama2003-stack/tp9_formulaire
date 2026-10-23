/// Validateurs réutilisables : renvoient null si la valeur est valide,
/// sinon le message d'erreur à afficher sous le champ.
class Validators {
  Validators._(); // classe utilitaire, non instanciable

  static final RegExp _nomRegExp = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ' -]+$");
  static final RegExp _emailRegExp = RegExp(
    r'^[\w.+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$',
  );
  static final RegExp _majuscule = RegExp(r'[A-Z]');
  static final RegExp _chiffre = RegExp(r'[0-9]');

  static String? nom(String? value, {String champ = 'Ce champ'}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return '$champ est obligatoire';
    if (v.length < 2) return '$champ doit contenir au moins 2 caractères';
    if (!_nomRegExp.hasMatch(v)) {
      return '$champ ne doit contenir que des lettres';
    }
    return null;
  }

  static String? prenom(String? value, {String champ = 'Ce champ'}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return '$champ est obligatoire';
    if (v.length < 2) {
      return 'Le prénom doit contenir au moins 2 caractères';
    }
    if (!_nomRegExp.hasMatch(v)) {
      return 'Le prénom ne doit contenir que des lettres';
    }
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "L'e-mail est obligatoire";
    if (!_emailRegExp.hasMatch(v)) return 'Format attendu : nom@domaine.com';
    return null;
  }

  static String? motDePasse(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Le mot de passe est obligatoire';
    if (v.length < 8) return 'Au moins 8 caractères';
    if (!_majuscule.hasMatch(v)) return 'Au moins une lettre majuscule';
    if (!_chiffre.hasMatch(v)) return 'Au moins un chiffre';
    return null;
  }

  static String? confirmation(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != original) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  static String? profession(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'La profession est obligatoire';
    if (v.length < 2) return 'Profession trop courte';
    return null;
  }

  static String? experience(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "Indiquez vos années d'expérience";
    final n = int.tryParse(v);
    if (n == null) return 'Nombre entier attendu';
    if (n < 0 || n > 50) return 'Valeur comprise entre 0 et 50';
    return null;
  }

  static String? tjm(String? value) {
    final v = (value ?? '').trim().replaceAll(',', '.');
    if (v.isEmpty) return 'Le TJM est obligatoire';
    final n = double.tryParse(v);
    if (n == null) return 'Montant invalide';
    if (n < 50 || n > 3000) {
      return 'Le TJM doit être compris entre 50 € et 3000 €';
    }
    return null;
  }

  /// Champ facultatif : vide = valide, sinon au moins 20 caractères.
  static String? biographie(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (v.length < 20) {
      return 'Au moins 20 caractères (${v.length}/20) ou laissez vide';
    }
    if (v.length > 300) {
      return 'Au maximum 300 caractères (${v.length}/300)';
    }
    return null;
  }
}
