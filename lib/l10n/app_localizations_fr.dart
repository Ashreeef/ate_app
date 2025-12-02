// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Ate';

  @override
  String get loginTitle => 'Bienvenue';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get signupButton => 'S\'inscrire';

  @override
  String get emailLabel => 'Adresse e-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte?';

  @override
  String get feedTitle => 'Découvrir';

  @override
  String get searchPlaceholder => 'Rechercher des restaurants, des plats...';

  @override
  String get createPostTitle => 'Partagez votre expérience';

  @override
  String get profileTitle => 'Profil';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get challengesTitle => 'Défis';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get posts => 'Publications';

  @override
  String get followers => 'Abonnés';

  @override
  String get following => 'Abonnements';

  @override
  String get saved => 'Enregistrés';

  @override
  String get myPosts => 'Mes publications';

  @override
  String get savedPosts => 'Publications enregistrées';

  @override
  String get like => 'J\'aime';

  @override
  String get comment => 'Commenter';

  @override
  String get share => 'Partager';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get submit => 'Soumettre';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur s\'est produite';

  @override
  String get pickImages => 'Choisir des images (max 3)';

  @override
  String get noPosts => 'Pas encore de publications';

  @override
  String get noPostsDescription =>
      'Soyez le premier à partager votre expérience culinaire!';

  @override
  String get selectAtLeastOneImage => 'Sélectionnez au moins une image';

  @override
  String imageSelectionFailed(Object error) {
    return 'Échec de la sélection d\'image: $error';
  }

  @override
  String get postPublished => 'Publication réussie!';

  @override
  String postPublishError(Object error) {
    return 'Erreur lors de la publication: $error';
  }

  @override
  String get writeCaption => 'Veuillez écrire une légende';

  @override
  String get enterRestaurant => 'Veuillez saisir un restaurant';

  @override
  String get rateExperience => 'Veuillez évaluer votre expérience';

  @override
  String get caption => 'Légende';

  @override
  String get captionPlaceholder => 'Partagez votre expérience culinaire...';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get restaurantPlaceholder => 'Nom du restaurant...';

  @override
  String get restaurantHint => 'Tapez le nom du restaurant';

  @override
  String get dishName => 'Nom du plat';

  @override
  String get dishNamePlaceholder => 'ex: Couscous Royal, Poisson Grillé...';

  @override
  String get dishNameOptional => '(Optionnel)';

  @override
  String get yourRating => 'Votre évaluation';

  @override
  String get newPost => 'Nouveau post';

  @override
  String get publish => 'Publier';

  @override
  String get disappointing => 'Décevant';

  @override
  String get fair => 'Moyen';

  @override
  String get good => 'Bien';

  @override
  String get veryGood => 'Très bien';

  @override
  String get excellent => 'Excellent!';

  @override
  String get myFeed => 'Mon fil';

  @override
  String get friendsFeed => 'Fil des amis';

  @override
  String get loadMore => 'Charger plus';
}
