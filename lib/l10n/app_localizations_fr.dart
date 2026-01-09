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
  String get appName => 'Ate';

  @override
  String viewAllComments(Object count) {
    return 'Voir les $count commentaires';
  }

  @override
  String get loginTitle => 'Bon retour';

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
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get feedTitle => 'Découvrir';

  @override
  String get searchPlaceholder => 'Rechercher des restaurants, des plats...';

  @override
  String get createPostTitle => 'Partagez votre expérience';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profile => 'Profil';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get challengesTitle => 'Défis';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get logout => 'Déconnexion';

  @override
  String get posts => 'Posts';

  @override
  String get followers => 'Abonnés';

  @override
  String get following => 'Abonnements';

  @override
  String get points => 'Points';

  @override
  String get saved => 'Enregistré';

  @override
  String get myPosts => 'Mes Posts';

  @override
  String get savedPosts => 'Posts enregistrés';

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
  String get submit => 'Envoyer';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur est survenue';

  @override
  String get comingSoon => 'Bientôt disponible !';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get logoutSuccess => 'Déconnecté avec succès';

  @override
  String get shareProfile => 'Partager le profil';

  @override
  String shareProfileMessage(Object url, Object username) {
    return 'Découvrez @$username sur Ate ! Suivez ses aventures culinaires ici : $url';
  }

  @override
  String get linkCopied => 'Lien copié dans le presse-papiers !';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get passwordChangedSuccess => 'Mot de passe changé avec succès';

  @override
  String get passwordChangeError => 'Erreur lors du changement de mot de passe';

  @override
  String get incorrectPassword => 'Le mot de passe actuel est incorrect';

  @override
  String get chooseLanguage => 'Choisir la langue';

  @override
  String get helpSupport => 'Aide et Support';

  @override
  String get contactUs => '📞 Nous Contacter';

  @override
  String get emailSupport => ' Email: Contact.ate.app@gmail.com';

  @override
  String get phoneSupport => '';

  @override
  String get liveChat => '';

  @override
  String get supportHours => ' Temps de réponse : Généralement sous 24h';

  @override
  String get frequentlyAsked => ' Questions Fréquentes';

  @override
  String get howToEditProfile => 'Comment modifier mon profil ?';

  @override
  String get howToEditProfileAnswer =>
      'Allez dans Profil > Modifier le profil pour changer vos informations.';

  @override
  String get howToFollowUsers => 'Comment suivre quelqu\'un ?';

  @override
  String get howToFollowUsersAnswer =>
      'Visitez son profil et appuyez sur le bouton \'Suivre\'.';

  @override
  String get howToPostPhoto => 'Comment partager un repas ?';

  @override
  String get howToPostPhotoAnswer =>
      'Appuyez sur l\'icône centrale pour partager votre expérience culinaire.';

  @override
  String get howToReportContent => 'Comment signaler un contenu ?';

  @override
  String get howToReportContentAnswer =>
      'Appuyez sur les trois points sur un post et sélectionnez \'Signaler\'.';

  @override
  String get forgotPasswordHelp => 'Accès perdu ?';

  @override
  String get forgotPasswordHelpAnswer =>
      'Utilisez le lien \'Mot de passe oublié\' sur l\'écran de connexion.';

  @override
  String get mainFeatures => ' Fonctionnalités Principales';

  @override
  String get shareculinaryMoments => '• Partagez vos moments culinaires';

  @override
  String get followFriends =>
      '• Suivez vos amis et découvrez de nouveaux profils';

  @override
  String get likeComment => '• Aimez et commentez les publications';

  @override
  String get savePosts => '• Sauvegardez vos publications préférées';

  @override
  String get pointsSystem => '• Système de points et de niveaux';

  @override
  String get discoverRestaurants => '• Découvrez de nouveaux restaurants';

  @override
  String get darkMode => '• Mode sombre disponible';

  @override
  String get troubleshooting => ' Résolution de Problèmes';

  @override
  String get restartApp =>
      '• Redémarrez l\'appli en cas de comportement étrange';

  @override
  String get checkInternet => '• Vérifiez votre connexion internet';

  @override
  String get updateApp => '• Mettez à jour via le Store';

  @override
  String get clearCache => '• Videz le cache dans les paramètres';

  @override
  String get contactSupport =>
      '• Contactez le support par email si le souci persiste';

  @override
  String get closeDialog => 'Fermer';

  @override
  String get aboutAte => ' À propos d\'Ate';

  @override
  String get appDescription =>
      'Ate est votre compagnon culinaire ultime ! Partagez vos expériences gastronomiques, découvrez de nouveaux restaurants et connectez-vous avec d\'autres passionnés.';

  @override
  String get ourMission => ' Notre Mission';

  @override
  String get missionDescription =>
      'Connecter les amoureux de la gastronomie et rendre chaque repas mémorable.';

  @override
  String get whatWeOffer => ' Ce que nous offrons';

  @override
  String get shareFoodPhotos => '• Partage de photos de vos plats favoris';

  @override
  String get discoverNewRestaurants => '• Découverte de pépites locales';

  @override
  String get personalizedRecommendations => '• Recommandations personnalisées';

  @override
  String get activeCommunity => '• Communauté active';

  @override
  String get intuitiveInterface => '• Interface moderne et intuitive';

  @override
  String get privacyRespect => '• Respect de votre vie privée';

  @override
  String get theTeam => ' L\'équipe';

  @override
  String get teamDescription => 'Développé avec ❤️ par l\'équipe Ate.';

  @override
  String get versionInfo => 'Version 1.0.0';

  @override
  String get buildInfo => 'Build 2026.01.08';

  @override
  String get allRightsReserved => '© 2026 Ate App. Tous droits réservés.';

  @override
  String get madeInAlgeria => 'Fait en Algérie 🇩🇿';

  @override
  String get privacySecurity => 'Confidentialité et sécurité';

  @override
  String get privateAccount => 'Compte privé';

  @override
  String get privateAccountDesc =>
      'Seuls vos abonnés peuvent voir votre profil';

  @override
  String get showOnlineStatus => 'Afficher le statut en ligne';

  @override
  String get showOnlineStatusDesc =>
      'Permettez aux autres de voir quand vous êtes actif';

  @override
  String get close => 'Fermer';

  @override
  String get needHelp => 'Besoin d\'aide ?';

  @override
  String get phone => 'Téléphone';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get termsPrivacy => 'Conditions et confidentialité';

  @override
  String get termsOfUse => 'Conditions d\'utilisation';

  @override
  String get termsOfUseDesc =>
      'En utilisant Ate, vous acceptez nos conditions d\'utilisation.';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privacyPolicyDesc => 'Vos données sont protégées et en sécurité.';

  @override
  String get dataCollection => 'Collecte de données';

  @override
  String get dataCollectionDesc =>
      '• Infos de profil\n• Photos et posts\n• Données d\'interaction';

  @override
  String get accountDeleted => 'Compte supprimé avec succès';

  @override
  String get logoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get deleteAccountConfirm =>
      'Cette action est irréversible. Toutes vos données seront supprimées.';

  @override
  String get account => 'Compte';

  @override
  String get updateYourInfo => 'Mettez à jour vos informations';

  @override
  String get manageAccountSecurity => 'Gérez la sécurité';

  @override
  String get updateYourPassword => 'Mettez à jour votre mot de passe';

  @override
  String get preferences => 'Préférences';

  @override
  String get manageNotifications => 'Gérez vos notifications';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get support => 'Support';

  @override
  String get getHelpWithApp => 'Obtenir de l\'aide';

  @override
  String get learnMoreAboutApp => 'En savoir plus sur Ate';

  @override
  String get legalInfo => 'Informations légales';

  @override
  String get dangerZone => 'Zone de danger';

  @override
  String get logoutFromAccount => 'Se déconnecter';

  @override
  String get deleteAccountPermanently => 'Supprimer définitivement';

  @override
  String get pickImages => 'Choisir (max 3)';

  @override
  String get noPosts => 'Aucun post';

  @override
  String get noPostsDescription =>
      'Soyez le premier à partager votre expérience !';

  @override
  String get selectAtLeastOneImage => 'Sélectionnez au moins une image';

  @override
  String imageSelectionFailed(Object error) {
    return 'Échec sélection : $error';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(Object count) {
    return 'Il y a ${count}m';
  }

  @override
  String hoursAgo(Object count) {
    return 'Il y a ${count}h';
  }

  @override
  String daysAgo(Object count) {
    return 'Il y a ${count}j';
  }

  @override
  String get copyLink => 'Copier le lien';

  @override
  String get report => 'Signaler';

  @override
  String get convertToRestaurant => 'Devenir Restaurant';

  @override
  String get viewRestaurant => 'Voir Mon Restaurant';

  @override
  String get createChallenge => 'Créer un Défi';

  @override
  String get challengeTitle => 'Titre du Défi';

  @override
  String get challengeDescription => 'Description';

  @override
  String get targetCount => 'Objectif';

  @override
  String get rewardBadge => 'Badge';

  @override
  String get joinChallenge => 'Rejoindre';

  @override
  String get leaveChallenge => 'Quitter';

  @override
  String get yourProgress => 'Votre Progression';

  @override
  String get daysRemaining => 'Jours Restants';

  @override
  String get challengeEnded => 'Défi Terminé';

  @override
  String get reward => 'Récompense';

  @override
  String get dateRange => 'Période';

  @override
  String get startDate => 'Date Début';

  @override
  String get endDate => 'Date Fin';

  @override
  String get conversionWarning => 'Cette action est irréversible.';

  @override
  String get confirmConversion => 'Confirmer Conversion';

  @override
  String get conversionSuccessful => 'Conversion réussie !';

  @override
  String get becomeARestaurant => 'Devenir Restaurant';

  @override
  String get fillInRestaurantDetails => 'Remplissez les détails';

  @override
  String get restaurantName => 'Nom du Restaurant';

  @override
  String get cuisineType => 'Type de Cuisine';

  @override
  String get location => 'Localisation';

  @override
  String get phoneNumber => 'Numéro de Tél';

  @override
  String get website => 'Site Web';

  @override
  String get openingHours => 'Horaires';

  @override
  String get description => 'Description';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get restaurantCreated => 'Profil restaurant créé';

  @override
  String get myFeed => 'Mon Flux';

  @override
  String get friendsFeed => 'Amis';

  @override
  String get noFollowing => 'Aucun abonnement';

  @override
  String get search => 'Chercher';

  @override
  String get postDeleted => 'Post supprimé';

  @override
  String failedToDeletePost(Object error) {
    return 'Échec suppression : $error';
  }

  @override
  String failedToAddComment(Object error) {
    return 'Échec ajout commentaire : $error';
  }

  @override
  String get failedToUpdateLike => 'Échec j\'aime';

  @override
  String get failedToUpdateSave => 'Échec enregistrement';

  @override
  String get cannotAddComment => 'Action impossible';

  @override
  String get noCommentsYet => 'Pas de commentaires';

  @override
  String likesCountText(Object count) {
    return '$count j\'aime';
  }

  @override
  String get imageNotFound => 'Image introuvable';

  @override
  String get user => 'Utilisateur';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get unknown => 'Inconnu';

  @override
  String postsCount(Object count) {
    return '$count Posts';
  }

  @override
  String followersCount(Object count) {
    return '$count Abonnés';
  }

  @override
  String followingCount(Object count) {
    return '$count Abonnements';
  }

  @override
  String pointsCount(Object count) {
    return '$count Points';
  }

  @override
  String get likes => 'J\'aime';

  @override
  String get noDishes => 'Aucun plat';

  @override
  String get noPostsYet => 'Aucun post';

  @override
  String get newFollowerTitle => 'Nouvel Abonné';

  @override
  String startedFollowingYou(Object username) {
    return '$username vous suit';
  }

  @override
  String get newLikeTitle => 'Nouveau J\'aime';

  @override
  String likedYourPost(Object username) {
    return '$username a aimé votre post';
  }

  @override
  String get newCommentTitle => 'Nouveau Commentaire';

  @override
  String commentedOnYourPost(Object username) {
    return '$username a commenté votre post';
  }

  @override
  String get allCaughtUp => 'Vous êtes à jour!';

  @override
  String get challengeTypeGeneral => 'Général';

  @override
  String get challengeTypeRestaurant => 'Restaurant';

  @override
  String get challengeTypeDish => 'Plat';

  @override
  String get challengeTypeLocation => 'Lieu';

  @override
  String get pleaseLoginFirst => 'Connectez-vous d\'abord';

  @override
  String get selectStartEndDates => 'Sélectionnez les dates';

  @override
  String get selectChallenge => 'Sélectionnez un défi';

  @override
  String get none => 'Aucun';

  @override
  String get pleaseLoginToJoinChallenges => 'Connectez-vous pour rejoindre';

  @override
  String get writeReview => 'Écrire un avis';

  @override
  String get fieldRequired => 'Champ requis';

  @override
  String get reviews => 'Avis';

  @override
  String get restaurantNotFound => 'Restaurant introuvable';

  @override
  String get restaurantHint => 'Chercher un resto...';

  @override
  String get reviewSuccess => 'Avis envoyé !';

  @override
  String get rateExperience => 'Notez votre expérience';

  @override
  String get yourReview => 'Votre Avis';

  @override
  String get writeReviewHint => 'Partagez des détails...';

  @override
  String get noReviewsRow => 'Pas d\'avis';

  @override
  String get failedToLoadReviews => 'Échec chargement avis';

  @override
  String get onboardingDiscover => 'Découvrez la ';

  @override
  String get onboardingFlavor => 'saveur';

  @override
  String get onboardingOf => ' du ';

  @override
  String get onboardingSharing => 'partage';

  @override
  String get onboardingWith => ' avec ';

  @override
  String get onboardingDescription => 'Ate est votre compagnon food.';

  @override
  String get closeButton => 'Fermer';

  @override
  String memberLevel(Object level) {
    return 'Membre $level ⭐';
  }

  @override
  String get rank => 'Rang';

  @override
  String get userPoints => 'Points';

  @override
  String followedUser(Object username) {
    return 'Vous suivez $username';
  }

  @override
  String unfollowedUser(Object username) {
    return 'Désabonné de $username';
  }

  @override
  String get conversionWarningCompact => 'Irréversible !';

  @override
  String get followed => 'Abonné !';

  @override
  String get manageMenu => 'Gérer le Menu';

  @override
  String get editRestaurant => 'Modifier Restaurant';

  @override
  String get menu => 'Menu';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get rating => 'Note';

  @override
  String get deleteAccountWarning => 'Attention ! Cela supprimera tout.';

  @override
  String get writeCaption => 'Veuillez écrire une légende';

  @override
  String get enterRestaurant => 'Veuillez entrer le nom du restaurant';

  @override
  String get newPost => 'Nouveau Post';

  @override
  String get caption => 'Légende';

  @override
  String get captionPlaceholder => 'Partagez votre expérience culinaire...';

  @override
  String get dishName => 'Nom du Plat';

  @override
  String get dishNameOptional => 'Nom du Plat (Optionnel)';

  @override
  String get dishNamePlaceholder => 'ex: Couscous Royal, Poisson Grillé...';

  @override
  String get yourRating => 'Votre Note';

  @override
  String get disappointing => 'Décevant';

  @override
  String get fair => 'Moyen';

  @override
  String get good => 'Bien';

  @override
  String get veryGood => 'Très Bien';

  @override
  String get excellent => 'Excellent';

  @override
  String get createNewChallenge => 'Créer un Nouveau Défi';

  @override
  String get enterChallengeTitle => 'ex: \'Essayez 5 Plats\'';

  @override
  String get titleRequired => 'Le titre est requis';

  @override
  String get titleTooShort => 'Titre trop court';

  @override
  String get enterDescription => 'Décrivez le défi...';

  @override
  String get descriptionRequired => 'La description est requise';

  @override
  String get challengeType => 'Type de Défi';

  @override
  String get enterTargetCount => 'ex: 5';

  @override
  String get targetCountRequired => 'Objectif requis';

  @override
  String get invalidTargetCount => 'Compte invalide';

  @override
  String get targetCountTooHigh => 'Max 100';

  @override
  String get enterRewardBadge => 'ex: \'Badge Gourmand 🍕\'';

  @override
  String get rewardBadgeRequired => 'Badge requis';

  @override
  String get challengeInfo => 'Les utilisateurs gagnent des points en publiant';

  @override
  String get challengeDetails => 'Détails du Défi';

  @override
  String get fullName => 'Nom Complet';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get email => 'E-mail';

  @override
  String get bio => 'Bio';

  @override
  String get confirm => 'Confirmer';

  @override
  String get errorOccurred => 'Erreur survenue';

  @override
  String get enterRestaurantName => 'Entrez le nom du restaurant';

  @override
  String get restaurantNameRequired => 'Nom requis';

  @override
  String get restaurantNameTooShort => 'Nom trop court';

  @override
  String get enterCuisineType => 'ex: Italien, Chinois';

  @override
  String get cuisineTypeRequired => 'Type de cuisine requis';

  @override
  String get enterLocation => 'Entrez l\'adresse';

  @override
  String get locationRequired => 'Adresse requise';

  @override
  String get hours => 'Horaires';

  @override
  String get enterHours => 'ex: Lun-Ven 9h-22h';

  @override
  String get convertNow => 'Convertir';

  @override
  String get mentions => 'Mentions';

  @override
  String get locationNotSpecified => 'Adresse non spécifiée';

  @override
  String get restaurantUpdatedSuccess => 'Restaurant mis à jour';

  @override
  String get addCoverPhoto => 'Ajouter Photo Couverture';

  @override
  String get deleteDish => 'Supprimer le Plat ?';

  @override
  String deleteDishConfirm(Object name) {
    return 'Supprimer \"$name\" ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get menuEmpty => 'Menu vide';

  @override
  String get addFirstDish => 'Ajouter Premier Plat';

  @override
  String get couldNotLoadMenu => 'Erreur chargement menu';

  @override
  String uploadImageFail(Object error) {
    return 'Échec upload : $error';
  }

  @override
  String get editDish => 'Modifier Plat';

  @override
  String get addDish => 'Ajouter Plat';

  @override
  String get addDishPhoto => 'Ajouter Photo Plat';

  @override
  String get price => 'Prix';

  @override
  String get category => 'Catégorie';

  @override
  String get dishDescription => 'Description';

  @override
  String get doYouWantToContinue => 'Continuer ?';

  @override
  String get trending => 'Tendances';

  @override
  String get allRestaurants => 'Tous les Restaurants';

  @override
  String get results => 'Résultats';

  @override
  String resultsFor(Object query) {
    return 'Résultats pour \"$query\"';
  }

  @override
  String get noRestaurantsAvailable => 'Aucun restaurant';

  @override
  String get noResultsFound => 'Aucun résultat';

  @override
  String get tryOtherKeywords => 'Essayez d\'autres mots';

  @override
  String get noFollowers => 'Aucun abonné';

  @override
  String get resetPassword => 'Réinitialiser';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordSubtitle =>
      'Ne vous inquiétez pas ! Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get rememberPasswordQuestion =>
      'Vous vous souvenez de votre mot de passe ? ';

  @override
  String get signInLink => 'Se connecter';

  @override
  String get loggingIn => 'Connexion en cours...';

  @override
  String get signInButton => 'Se connecter';

  @override
  String get timeToEat => 'C\'est l\'heure de manger !';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour retrouver vos amis, découvrir de nouveaux plats et partager vos moments délicieux.';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get continueWithSocial => 'Ou continuer avec';

  @override
  String get noAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get registeringAccount => 'Inscription en cours...';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get welcomeToCommunity => 'Bienvenue dans la communauté Ate !';

  @override
  String get signupSubtitle =>
      'Créez votre profil et commencez à explorer les plats préférés de vos amis — découvrez, partagez et savourez chaque instant.';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPasswordQuestion => 'Mot de passe oublié ?';

  @override
  String get continueWith => 'Continuer avec';

  @override
  String get alreadyHaveAccountQuestion => 'Vous avez déjà un compte ? ';

  @override
  String get signInNow => 'Se connecter';

  @override
  String get next => 'Suivant';

  @override
  String get markAllAsRead => 'Tout marquer comme lu';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get searchRestaurants => 'Rechercher des restaurants...';

  @override
  String get trendingNearYou => 'Tendances près de chez vous';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get recentSearches => 'Recherches récentes';

  @override
  String maxImagesMessage(Object maxImages) {
    return 'Vous ne pouvez sélectionner que $maxImages images';
  }

  @override
  String imageSelectionError(Object error) {
    return 'Échec sélection image : $error';
  }

  @override
  String get selectAtLeastOne => 'Sélectionnez au moins une image';

  @override
  String get choosePhoto => 'Choisir une photo';

  @override
  String get gallery => 'Galerie';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get addPhotos => 'Ajouter des photos';

  @override
  String get shareYourCulinaryExperience =>
      'Partagez votre expérience culinaire\navec de belles photos';

  @override
  String get selectPhotos => 'Sélectionner des photos';

  @override
  String get add => 'Ajouter';

  @override
  String get activeChallengesLabel => 'Défis en cours';

  @override
  String get allChallengesLabel => 'Tous les défis';

  @override
  String get noChallengesAvailable => 'Aucun défi disponible';

  @override
  String get newChallengesWillAppear => 'De nouveaux défis apparaîtront ici';

  @override
  String get post => 'Post';

  @override
  String get imageLoadFailed => 'Échec chargement image';

  @override
  String get comments => 'Commentaires';

  @override
  String get addComment => 'Ajouter un commentaire...';

  @override
  String get deletePost => 'Supprimer le Post ?';

  @override
  String get deletePostConfirm => 'Cette action ne peut pas être annulée.';

  @override
  String get publish => 'Publier';

  @override
  String get postPublished => 'Post publié avec succès !';

  @override
  String get follow => 'Suivre';

  @override
  String get noSavedPosts => 'Aucun post enregistré !';

  @override
  String get progress => 'Progression';

  @override
  String get joined => 'Rejoint !';

  @override
  String get percentCompleted => '% complété';

  @override
  String get join => 'Rejoindre';

  @override
  String get resetEmailSent => 'E-mail de réinitialisation envoyé !';

  @override
  String postPublishError(Object error) {
    return 'Erreur publication : $error';
  }

  @override
  String get dish => 'Plat';

  @override
  String get loadMore => 'Charger plus';

  @override
  String get activeChallenges => 'Défis actifs';

  @override
  String get allChallenges => 'Tous les défis';

  @override
  String get ok => 'OK';

  @override
  String get sharePost => 'Partager le Post';

  @override
  String shareUserProfile(Object username) {
    return 'Partager le profil de $username';
  }

  @override
  String get copy => 'Copier';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get errorUpdatingFollowStatus => 'Erreur mise à jour statut';

  @override
  String get noPostsAvailable => 'Aucun post disponible';

  @override
  String get validationSuccess => '✅ Validation réussie !';

  @override
  String get signIn => 'Se connecter';

  @override
  String get french => 'Français';

  @override
  String get english => 'Anglais';

  @override
  String get arabic => 'Arabe';

  @override
  String get sharePostDescription =>
      'Vous pouvez partager ce post en prenant une capture ou en copiant le lien. Partage social bientôt disponible !';

  @override
  String get reportAction => 'Signaler';

  @override
  String get dishDetail => 'Détails du plat';

  @override
  String get restaurantPosts => 'Posts du restaurant';

  @override
  String get moreOptions => 'Plus d\'options';

  @override
  String nowFollowing(Object username) {
    return 'Vous suivez maintenant $username';
  }

  @override
  String unfollowed(Object username) {
    return 'Désabonné de $username';
  }

  @override
  String get errorUpdatingFollow => 'Erreur mise à jour statut';

  @override
  String get userNotFound => 'Utilisateur non trouvé';

  @override
  String shareProfileCheck(Object bio, Object username) {
    return 'Découvrez @$username sur Ate !\n\n$bio';
  }

  @override
  String shareUserProfileTitle(Object username) {
    return 'Partager le profil de $username';
  }

  @override
  String shareMyProfile(Object bio, Object username) {
    return 'Découvrez mon profil sur Ate !\n\nNom d\'utilisateur: @$username\nBio: $bio';
  }

  @override
  String get shareProfileTitle => 'Partager le profil';

  @override
  String get appVersion => 'Ate Version 1.0.0';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get postUnsaved => 'Post retiré des enregistrés';

  @override
  String get savedPostsHint =>
      'Appuyez sur l\'icône signet pour enregistrer des posts ici';
}
