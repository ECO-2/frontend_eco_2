// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'AI-powered plant care';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInAction => 'Sign in';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'email@example.com';

  @override
  String get password => 'Password';

  @override
  String get passwordMinChars => 'min. 8 characters';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get username => 'Username';

  @override
  String get register => 'Sign up';

  @override
  String get noAccountYet => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get enterYourEmail => 'Please enter your email';

  @override
  String get enterYourPassword => 'Please enter your password';

  @override
  String get termsNotice =>
      'By signing up you accept ECO2\'s Terms of Use and Privacy Policy.';

  @override
  String get navStore => 'Store';

  @override
  String get navGarden => 'Garden';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navScanner => 'Scanner';

  @override
  String get navProfile => 'Profile';

  @override
  String get myGarden => 'My Garden';

  @override
  String get viewAll => 'view all';

  @override
  String get addPlant => 'Add Plant';

  @override
  String get gardenEmpty => 'Your garden is empty';

  @override
  String get needsWater => 'Water';

  @override
  String get upToDate => 'Up to date';

  @override
  String get noWateringYet => 'Not watered yet';

  @override
  String get wateringToday => 'Water today';

  @override
  String get wateringOverdue => 'Watering overdue';

  @override
  String get daysWithoutWater => 'days without water';

  @override
  String get daysInYourGarden => 'days in your garden';

  @override
  String get frequency => 'frequency';

  @override
  String get remaining => 'remaining';

  @override
  String get overdue => 'overdue';

  @override
  String get careStatus => 'Care status';

  @override
  String get urgentWatering => 'Needs Water';

  @override
  String get deletePlantTitle => 'Delete plant?';

  @override
  String deletePlantBody(String plantName) {
    return '\"$plantName\" will be removed from your garden. This action cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String lastWateredQuestion(String plantName) {
    return 'When did you last water $plantName?';
  }

  @override
  String get lastWateredHelp =>
      'This is how we work out when the next watering is due. If you\'re not sure, we\'ll start counting from today.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get someDaysAgo => 'A few days ago…';

  @override
  String get neverOrDontRemember => 'Never / can\'t remember';

  @override
  String get lastWatering => 'Last watering';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'ACCOUNT';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editProfileSubtitle => 'Username';

  @override
  String get changePassword => 'Change password';

  @override
  String get biometricAuth => 'Biometric authentication';

  @override
  String get notifications => 'NOTIFICATIONS';

  @override
  String get pushNotifications => 'Push notifications';

  @override
  String get wateringReminders => 'Watering reminders';

  @override
  String get achievementsAndMissions => 'Achievements and missions';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get systemLanguage => 'System language';

  @override
  String get language => 'Language';

  @override
  String get themeAndColors => 'Theme and colours';

  @override
  String get privacyAndData => 'PRIVACY AND DATA';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacySubtitle => 'What ECO2 stores';

  @override
  String get exportMyData => 'Export my data';

  @override
  String get application => 'APP';

  @override
  String get helpAndSupport => 'Help and support';

  @override
  String get aboutEco2 => 'About ECO2';

  @override
  String get dangerZone => 'DANGER ZONE';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSubtitle => 'This cannot be undone';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get profile => 'Profile';

  @override
  String get plants => 'Plants';

  @override
  String get seeds => 'Seeds';

  @override
  String get co2Total => 'Total CO₂';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String levelWithName(int level, String name) {
    return 'Level $level · $name';
  }

  @override
  String get myTrophies => 'My Trophies';

  @override
  String get trophies => 'Trophies';

  @override
  String get missions => 'Missions';

  @override
  String get achievements => 'Achievements';

  @override
  String get obtained => 'Earned';

  @override
  String get available => 'Available';

  @override
  String get completedPercent => 'Completed';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak',
      one: '1 day streak',
    );
    return '$_temp0';
  }

  @override
  String xpPoints(int xp) {
    return '$xp XP';
  }

  @override
  String seedsCount(int count) {
    return '$count seeds';
  }

  @override
  String get greenFootprint => 'My Green Footprint';

  @override
  String get co2AbsorbedToday => 'CO₂ absorbed today';

  @override
  String get gramsPerDay => 'grams / day';

  @override
  String get contributionPerPlant => 'Contribution per plant';

  @override
  String get weeklyEvolution => 'Weekly evolution';

  @override
  String get weeklyEvolutionHelp =>
      'Reflects when each plant joined your garden.';

  @override
  String get copyMyFootprint => 'Copy my green footprint';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String accumulated(String kg) {
    return 'Accumulated: $kg kg';
  }

  @override
  String get noPlantsYet => 'You don\'t have any plants yet';

  @override
  String get footprintError => 'We couldn\'t work out your green footprint.';

  @override
  String get retry => 'Try again';

  @override
  String get scannerPointAtPlant => 'Point at a plant';

  @override
  String get scannerAnalyzing => 'Analysing...';

  @override
  String get scannerNotInCatalog =>
      'We recognised it, but it\'s not in the ECO2 catalogue yet — we can\'t add it to your garden for now.';

  @override
  String get scannerLowConfidence =>
      'We couldn\'t recognise it confidently. Try again with more light or from closer up.';

  @override
  String get connectionError => 'Connection error. Check your internet.';

  @override
  String get wrongCredentials => 'Incorrect email or password.';

  @override
  String get emailAlreadyUsed => 'This email already has an account.';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get greeting => 'Namaste';

  @override
  String get yourSeeds => 'Your seeds';

  @override
  String get activeMission => 'Active Mission';

  @override
  String get searchSpecies => 'Search species...';

  @override
  String get searchMyPlant => 'Search my plant...';

  @override
  String get exploreSpecies => 'Explore species';

  @override
  String get trendingThisWeek => 'Trending this week';

  @override
  String get allCategory => 'All';

  @override
  String plantsCount(int count) {
    return '$count plants';
  }

  @override
  String needsAttentionToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plants need attention today',
      one: '1 plant needs attention today',
    );
    return '$_temp0';
  }

  @override
  String get view => 'View';

  @override
  String get add => 'Add';

  @override
  String get allUpToDate => 'All up to date!';

  @override
  String get wateringStatus => 'Watering status';

  @override
  String get logEveryCare => 'Log every care action';

  @override
  String get viewHistory => 'View history';

  @override
  String get latestCare => 'Latest care';

  @override
  String get careType => 'Care type';

  @override
  String get suggestedNextWatering => 'Suggested next watering';

  @override
  String get inMyCollectionSince => 'In my collection since';

  @override
  String get howToCareTitle => 'How to care for your plant';

  @override
  String everyNDays(int days) {
    return 'Every $days days';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get noCareLogged => 'No care logged yet.';

  @override
  String get scannerHint => 'Point at a plant';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get notIdentified => 'Not confidently identified';

  @override
  String potsRemaining(int count) {
    return 'Pots remaining: $count';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get todayLabel => 'TODAY';

  @override
  String get thatsAllForNow => 'That\'s all for now';

  @override
  String get noNotifications => 'You have no notifications';

  @override
  String get wateringPending => 'Watering due';

  @override
  String achievementUnlocked(String title) {
    return 'Achievement unlocked: $title';
  }

  @override
  String newPlantAdded(String name) {
    return 'New plant added: you added $name to your collection.';
  }

  @override
  String get seedbed => 'Seedbed';

  @override
  String get redeemSeeds => 'Redeem your seeds for rewards';

  @override
  String get search => 'Search...';

  @override
  String get communityFavorites => 'Community favourites';

  @override
  String get newBadge => 'New';

  @override
  String get yourImpactEquals => 'Your impact is equivalent to:';

  @override
  String treesEquivalent(int count) {
    return '$count Trees';
  }

  @override
  String kilometersEquivalent(int count) {
    return '$count Kilometres';
  }

  @override
  String levelAndTrophies(int level, int trophies) {
    return 'Level $level · $trophies trophies';
  }

  @override
  String get noAchievementsYet =>
      'You haven\'t completed any achievements yet.';

  @override
  String get allAchievementsDone =>
      'You completed every available achievement!';

  @override
  String get noAchievementsConfigured => 'No achievements configured yet.';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get reward => 'Reward';

  @override
  String get achievementUnlockedLabel => 'Achievement unlocked';

  @override
  String get achievementLockedLabel => 'Achievement locked';

  @override
  String get activeMissions => 'Active missions';

  @override
  String get plantCatalog => 'Plant catalog';

  @override
  String get seedStore => 'Seed store';

  @override
  String get freePlanActive => 'Free plan active';

  @override
  String get user => 'User';

  @override
  String get loading => 'Loading...';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get catTropical => 'Tropical';

  @override
  String get catSucculent => 'Succulent';

  @override
  String get catCactus => 'Cactus';

  @override
  String get catFern => 'Fern';

  @override
  String get catFlowering => 'Flowering';

  @override
  String get catHerb => 'Herb';

  @override
  String get catTree => 'Tree';

  @override
  String get catOther => 'Plant';

  @override
  String get lightLow => 'Low';

  @override
  String get lightMedium => 'Medium';

  @override
  String get lightHigh => 'High';

  @override
  String get lightIndirect => 'Indirect';

  @override
  String lightPrefix(String level) {
    return '$level light';
  }

  @override
  String get difficultyVeryEasy => 'Very easy';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String wateringEveryDays(int days) {
    return 'Water every ${days}d';
  }

  @override
  String get humidityLow => 'Low';

  @override
  String get humidityMedium => 'Medium';

  @override
  String get humidityHigh => 'High';

  @override
  String impactCarTitle(String km) {
    return '$km km by car';
  }

  @override
  String get impactCarSubtitle =>
      'That wouldn\'t need to be driven to emit that CO₂.';

  @override
  String impactBulbTitle(String hours) {
    return '$hours h of LED bulb';
  }

  @override
  String get impactBulbSubtitle => 'Of equivalent electricity use.';

  @override
  String impactTreeTitle(String days) {
    return '$days days of one tree';
  }

  @override
  String get impactTreeSubtitle =>
      'How long a mature tree takes to absorb the same.';

  @override
  String get impactApproxNote =>
      'Approximate equivalences, calculated from your garden\'s CO₂.';

  @override
  String get impactTooSmall =>
      'Your garden hasn\'t yet absorbed enough CO₂ for a useful equivalence.';

  @override
  String accumulatedGrams(String grams) {
    return 'Accumulated: $grams g';
  }

  @override
  String get category => 'Category';

  @override
  String get gallery => 'Gallery';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get cameraPermissionError =>
      'Couldn\'t access the camera or gallery. Check the app permissions.';

  @override
  String get flashAutoHint =>
      'The flash turns on automatically only when taking the photo.';

  @override
  String get showThisGuide => 'Show this guide.';

  @override
  String get upcomingAchievements => 'Upcoming achievements';

  @override
  String get closest => '• CLOSEST';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get quickPay => 'Quick pay';

  @override
  String get oneYearPlus => '1 year of ECO2 Plus';

  @override
  String get whatToDoNow => 'What to do now';

  @override
  String get uploadFromGallery => 'Upload from Gallery';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String careEveryNDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Every day',
    );
    return '$_temp0';
  }

  @override
  String timeAgoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String achievementUnlockedNamed(String name) {
    return 'Achievement unlocked: $name';
  }

  @override
  String purchaseSuccess(String item) {
    return 'Purchase successful: $item';
  }

  @override
  String plantAddedToGarden(String name) {
    return '$name added to your garden! 🌿';
  }

  @override
  String get couldNotAddPlant => 'Couldn\'t add the plant.';

  @override
  String get addNewPlant => 'Add a new plant';

  @override
  String get yourPlantName => 'Your plant\'s name';

  @override
  String gramsPerDayShort(String grams) {
    return '$grams g/day';
  }

  @override
  String get difficultyAll => 'All';

  @override
  String get lightHintLow => 'Low-light corners';

  @override
  String get lightHintHigh => 'Near a window';

  @override
  String get lightHintIndirect => 'No direct sun';

  @override
  String get lightHintDefault => 'Filtered light';

  @override
  String get filterByCategory => 'Filter by category';

  @override
  String get speciesNotFound => 'Species not found';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordBody =>
      'Enter your email and we\'ll send you a code to reset your password.';

  @override
  String get forgotPasswordSent =>
      'If an account exists with that email, we\'ve sent you a code.';

  @override
  String get send => 'Send';

  @override
  String get emailRequired => 'Enter your email first';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get resetPasswordIntro =>
      'Paste the code we emailed you and choose your new password.';

  @override
  String get resetCodeLabel => 'Recovery code';

  @override
  String get resetCodeHint => 'ABCD-2345';

  @override
  String get resetCodeRequired => 'Enter the code you received';

  @override
  String get newPassword => 'New password';

  @override
  String get passwordsDoNotMatch => 'Passwords don\'t match';

  @override
  String get resetPasswordSubmit => 'Change password';

  @override
  String get resetPasswordSuccess => 'Password updated. You can sign in now.';

  @override
  String get resetCodeExpiredHint =>
      'The code expires after 30 minutes. Request a new one if it lapsed.';

  @override
  String get changePasswordIntro =>
      'Enter your current password and pick a new one.';

  @override
  String get changePasswordSubmit => 'Save password';

  @override
  String get changePasswordSuccess => 'Password updated.';

  @override
  String get currentPassword => 'Current password';

  @override
  String get currentPasswordRequired => 'Enter your current password';

  @override
  String get passwordMustDiffer =>
      'The new password must differ from the current one';

  @override
  String get biometricLock => 'Fingerprint lock';

  @override
  String get biometricLockSubtitle =>
      'Ask for your fingerprint when opening the app';

  @override
  String get biometricUnavailable => 'This device has no fingerprint enrolled';

  @override
  String get biometricPromptReason => 'Confirm your identity to open ECO2';

  @override
  String get biometricEnabled => 'Fingerprint lock enabled';

  @override
  String get biometricDisabled => 'Fingerprint lock disabled';

  @override
  String get appLockTitle => 'ECO2 is locked';

  @override
  String get appLockSubtitle => 'Use your fingerprint to continue.';

  @override
  String get appLockFailed => 'We could not confirm your identity.';

  @override
  String get appLockRetry => 'Try again';

  @override
  String get appLockSignOut => 'Sign out';

  @override
  String get managePlus => 'Manage ECO2 Plus';

  @override
  String get managePlusFree => 'Free plan active';

  @override
  String get pushNotificationsSubtitle => 'Watering and achievement alerts';

  @override
  String get reminderWindow => 'Reminder hours';

  @override
  String reminderWindowValue(int start, int end) {
    return 'From $start:00 to $end:00';
  }

  @override
  String get reminderWindowSheetTitle => 'When should we remind you?';

  @override
  String get reminderWindowIntro =>
      'Reminders are only sent within this window.';

  @override
  String get reminderStart => 'From';

  @override
  String get reminderEnd => 'To';

  @override
  String get reminderWindowInvalid =>
      'The start hour must be before the end hour';

  @override
  String get reminderWindowSaved => 'Reminder hours updated';

  @override
  String get privacySheetTitle => 'Your data in ECO2';

  @override
  String get privacySheetBody =>
      'ECO2 stores your email, your username, the plants in your garden and their care history. Photos you take stay on this device only. You can export everything or delete your account at any time.';

  @override
  String get exportDataSubtitle => 'Copy a summary to the clipboard';

  @override
  String get exportDataCopied => 'Data copied to the clipboard';

  @override
  String get exportDataFailed => 'We could not gather your data';

  @override
  String get helpSupportSubtitle => 'Write to us if something breaks';

  @override
  String get helpSheetTitle => 'Need a hand?';

  @override
  String get helpSheetBody =>
      'Tell us what happened and which screen you were on. Copy the address and send us a message.';

  @override
  String get copyEmail => 'Copy email';

  @override
  String get emailCopied => 'Email copied';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutSheetBody =>
      'ECO2 helps you care for your plants and see how much CO2 they absorb.';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountBody =>
      'Your profile, your plants and all their care history will be erased. This cannot be undone.';

  @override
  String get deleteAccountConfirmHint => 'Type DELETE to confirm';

  @override
  String get deleteAccountConfirmWord => 'DELETE';

  @override
  String get deleteAccountSuccess => 'Your account has been deleted.';

  @override
  String get usernameTaken => 'That username is already taken.';

  @override
  String get currentPasswordWrong => 'That is not your current password.';

  @override
  String get profileUpdateFailed =>
      'We could not update your profile. Try again.';

  @override
  String get plantsLoadFailed => 'We could not load your plants.';

  @override
  String get plantAddFailed => 'We could not add the plant.';

  @override
  String get plantDeleteFailed => 'We could not delete the plant.';

  @override
  String get nicknameEmpty => 'The nickname cannot be empty.';

  @override
  String get nicknameUpdateFailed => 'We could not update the nickname.';

  @override
  String get missionsLoadFailed => 'We could not load the missions.';

  @override
  String get careLogFailed => 'We could not log the care action.';

  @override
  String get nicknameUpdated => 'Nickname updated.';

  @override
  String get noSpeciesMatchFilters => 'No species match these filters';

  @override
  String get noPlantsInCategory => 'You have no plants in this category yet';

  @override
  String daysOverdueLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String noWateringLoggedEvery(int days) {
    return 'No log / every ${days}d';
  }

  @override
  String daysWithoutWaterEvery(int days, int freq) {
    return '${days}d dry / every ${freq}d';
  }

  @override
  String get identifyConnectionError =>
      'We could not connect to identify the plant. Check your connection and try again.';

  @override
  String get plantAlreadyRegistered => 'Plant already registered';

  @override
  String get plantAlreadyRegisteredBody =>
      'You already have this plant in your garden. Give it a nickname so you can tell them apart.';

  @override
  String get addThisPlantQuestion => 'Add this plant to your garden?';

  @override
  String get addThisPlantBody => 'It will be added to your plant collection.';

  @override
  String get redeemMore => 'Redeem more';

  @override
  String get plantAddedSuccess => 'Plant added successfully';

  @override
  String get historyLoadFailed => 'We could not load the history.';

  @override
  String get noScansYet => 'You have not scanned any plants yet.';

  @override
  String get toMyGarden => 'To my garden';

  @override
  String get aiNotAvailable =>
      'AI identification is not available in this version yet.';

  @override
  String get tourGalleryDescription =>
      'Upload a photo from your gallery to analyse.';

  @override
  String get shutter => 'Shutter';

  @override
  String get tourShutterDescription => 'Tap here to scan a plant and continue.';

  @override
  String get enterUsername => 'Please enter your username';

  @override
  String get usernameTooShort => 'The username must be at least 3 characters';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get confirmYourPassword => 'Please confirm your password';

  @override
  String estimatedValueNote(int measured, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      measured,
      locale: localeName,
      other:
          'Estimated value: $measured of $total plants rely on a published measurement.',
    );
    return '$_temp0';
  }

  @override
  String get footprintShareEmpty =>
      'I don\'t have any plants in my ECO2 garden yet.';

  @override
  String footprintShareSummary(int plants, String perDay, String total) {
    return 'My ECO2 garden: $plants plants and $perDay g of CO₂ per day ($total g accumulated).';
  }

  @override
  String get addPlantsToSeeContribution =>
      'Add plants to your garden to see what each one contributes.';

  @override
  String get storeBestsellers => 'Bestsellers';

  @override
  String get storeAvatars => 'Avatars';

  @override
  String get storePots => 'Pots';

  @override
  String get storeO2Plus2wTitle => 'Grow your garden pro';

  @override
  String get storeO2Plus2wSubtitle => '2 weeks of O2 Plus';

  @override
  String get storePotRentalTitle => 'Rent a pot';

  @override
  String get storePotRentalSubtitle => 'Temporary slot · 2 weeks';

  @override
  String get storeAvatarExplorerTitle => 'Green Explorer avatar';

  @override
  String get storeAvatarGuardianTitle => 'Forest Guardian avatar';

  @override
  String get storePermanentUnlock => 'Permanent unlock';

  @override
  String get storePotPack3Title => 'Pack of 3 pots';

  @override
  String get storePotPack3Subtitle => '+3 permanent slots';

  @override
  String get storeO2Plus4wTitle => 'O2 Plus monthly';

  @override
  String get storeO2Plus4wSubtitle => '4 weeks of O2 Plus';

  @override
  String get newBadgeLabel => 'New';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get confirmPurchaseTitle => 'Confirm purchase?';

  @override
  String confirmPurchaseBody(String item, int cost) {
    return 'Redeem \"$item\" for $cost seeds?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get purchaseFailed => 'We could not complete the purchase.';

  @override
  String get boostGardenPremium => 'Boost your garden with premium perks';

  @override
  String get moreSpaceForPlants => 'Get more space for your plants';

  @override
  String get customizeYourProfile => 'Customize your profile';

  @override
  String speciesDescription(
    String category,
    String light,
    String humidity,
    int days,
    int minTemp,
    int maxTemp,
  ) {
    return 'A $category species that prefers $light light and $humidity humidity. Water it roughly every $days days, letting the soil dry between waterings, and it does well between $minTemp°C and $maxTemp°C.';
  }

  @override
  String get purifierExcellent => 'It is an excellent air purifier.';

  @override
  String get purifierGood => 'It helps improve the air quality in your home.';

  @override
  String get humidityRangeLow => '30-40%';

  @override
  String get humidityRangeMedium => '40-60%';

  @override
  String get humidityRangeHigh => '60-80%';

  @override
  String get airPurification => 'Air purification';

  @override
  String get purificationLevel => 'Purification level';

  @override
  String get idealRequirements => 'Ideal requirements for this species';

  @override
  String everyNDaysShort(int days) {
    return 'every $days days';
  }

  @override
  String absorbsPerDay(String grams) {
    return 'Absorbs ~${grams}g of CO₂/day';
  }

  @override
  String get addToMyGarden => 'Add to my garden';

  @override
  String gramsPerDayValue(String grams) {
    return '$grams g/day';
  }

  @override
  String get noNotesYet => 'You haven\'t added notes for this plant yet.';

  @override
  String get airPurifierTag => 'Air purifier';

  @override
  String humidityWithPrefix(String level) {
    return '$level humidity';
  }

  @override
  String get watering => 'Watering';

  @override
  String get lightLabelShort => 'Light';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidityLabelShort => 'Humidity';

  @override
  String get whenSoilDry => 'When the soil is dry';

  @override
  String get redeemSeedsOrSubscribe => 'Redeem your seeds or subscribe to O₂₊';

  @override
  String get viewMyAchievements => 'See my achievements and missions';

  @override
  String get exploreBotanicalSpecies => 'See species';

  @override
  String get appTour => 'App tour';

  @override
  String get appTourSubtitle => 'Replay';

  @override
  String get rewardDiscountTitle => '15% off at Vivero El Helecho';

  @override
  String get rewardDiscountDesc => 'Coupon valid on your next purchase.';

  @override
  String get rewardBadgeTitle => '\"Earth Guardian\" badge';

  @override
  String get rewardBadgeDesc => 'Show your commitment on your profile.';

  @override
  String get rewardPotsTitle => 'Custom pots (3D)';

  @override
  String get rewardPotsDesc => 'Unlock interactive designs.';

  @override
  String get redeemRewardTitle => 'Redeem reward?';

  @override
  String redeemRewardBody(String reward, int cost) {
    return 'Are you sure you want to redeem \"$reward\" for $cost seeds?';
  }

  @override
  String redeemSuccess(String reward) {
    return 'Redeemed: $reward 🎁';
  }

  @override
  String get tourWateringStatusDesc =>
      'Here you can see whether it\'s due for watering, how many days it has gone without water, and how many days are left (or how overdue it is) for its species.';

  @override
  String get tourLogCareDesc =>
      'Every time you water, fertilise, prune or repot it, log it here — that keeps the watering status and your history truthful.';

  @override
  String get speciesCare => 'Species care';

  @override
  String get speciesSpecSheet => 'Species spec sheet';

  @override
  String get tourSpeciesGridDesc =>
      'Ideal watering, light, temperature and humidity for this particular species.';

  @override
  String get howToCareForThisPlant => 'How to care for this plant';

  @override
  String get plantNicknameHint => 'Plant nickname';

  @override
  String get howToCareForYourPlant => 'How to care for your plant';

  @override
  String get careCalendar => 'Care calendar';

  @override
  String get tourCareCalendarDesc =>
      'The watering frequency is real, taken from the species. Fertilising, pruning and repotting are general good practice — the app does not compute an exact frequency for those yet.';

  @override
  String get whenToDoEachCare => 'When to do each task?';

  @override
  String get scheduleFertilizing => 'Every 4-6 weeks, in spring and summer';

  @override
  String get schedulePruning =>
      'Remove dry, yellow or damaged leaves as soon as you spot them';

  @override
  String get scheduleRepotting =>
      'Every 1-2 years, or when the roots fill the pot';

  @override
  String get tourStoreDesc =>
      'Redeem your seeds for extra pots and special features.';

  @override
  String get yourGarden => 'Your garden';

  @override
  String get tourGardenDesc =>
      'Browse the species catalog or manage the plants you already have.';

  @override
  String get aiScanner => 'AI scanner';

  @override
  String get tourScannerDesc =>
      'Identify a plant by pointing the camera at it — the AI recognises the species.';

  @override
  String get yourProfile => 'Your profile';

  @override
  String get tourProfileDesc =>
      'Check your progress, account settings and more.';

  @override
  String get premiumTitle => 'Supercharge your garden';

  @override
  String get premiumSubtitle =>
      'Unlock the full potential of ECO2 and take your botanical experience further.';

  @override
  String get premiumIncludes => 'Everything included';

  @override
  String get premiumUnlimitedPots => 'Unlimited pots';

  @override
  String get premiumUnlimitedPotsDesc =>
      'Add as many plants as you like, with no limits.';

  @override
  String get premiumBetterSearch => 'Improved search by description';

  @override
  String get premiumBetterSearchDesc =>
      'Find plants by describing how they look, with AI.';

  @override
  String get premiumUnlimitedScans => 'Unlimited scans';

  @override
  String get premiumUnlimitedScansDesc =>
      'Identify any plant, whenever you want.';

  @override
  String get premiumAiTreatment => 'AI-assisted treatment';

  @override
  String get premiumAiTreatmentDesc =>
      'Personalised diagnosis of pests and care.';

  @override
  String get premiumNurseryDiscounts => 'Discounts at partner nurseries';

  @override
  String get premiumNurseryDiscountsDesc =>
      'Up to 20% off species from selected partners.';

  @override
  String get noCompletedAchievements => 'No completed achievements yet';

  @override
  String get noLockedAchievements => 'No locked achievements right now';

  @override
  String get lockedAchievementsNote =>
      'These achievements depend on features that are not available in the app yet.';

  @override
  String get plantIdentification => 'Plant identification';

  @override
  String get scannerTabHint =>
      'Point the camera at the plant, or upload a photo from your gallery.';

  @override
  String get recentAnalyses => 'Recent analyses';

  @override
  String get careTypeWatering => 'Watering';

  @override
  String get careTypeFertilizing => 'Fertilising';

  @override
  String get careTypePruning => 'Pruning';

  @override
  String get careTypeRepotting => 'Repotting';

  @override
  String careLoggedToast(String type) {
    return 'Care logged: $type 🌿';
  }

  @override
  String get inOneDay => 'in 1 day';

  @override
  String daysAgoShort(int count) {
    return '$count days ago';
  }

  @override
  String inNDays(int count) {
    return 'in $count days';
  }

  @override
  String get noCareLoggedForPlant =>
      'You haven\'t logged any care for this plant yet.';

  @override
  String get noEventsForFilter => 'No events for this filter.';

  @override
  String get featureComingSoon => 'This feature will be available soon.';

  @override
  String get thisPlant => 'this plant';

  @override
  String get careTypeGeneric => 'Care';

  @override
  String get changePhotoComingSoon =>
      'Changing your profile photo will be available soon 📸';

  @override
  String get changeProfilePhoto => 'Change profile photo';

  @override
  String get personalInformation => 'Personal information';

  @override
  String get pickSpeciesToContinue =>
      'Pick a species from the list to continue.';

  @override
  String get nameYourPlantToContinue => 'Give your plant a name to continue.';

  @override
  String get noSpeciesAvailable => 'No species available yet.';

  @override
  String noSpeciesFoundFor(String query) {
    return 'No species found for \"$query\".';
  }

  @override
  String get tellUsAboutYou => 'Tell us about you';

  @override
  String get usernameRequired => 'The username is required';

  @override
  String get minThreeChars => 'At least 3 characters';

  @override
  String get gender => 'Gender';

  @override
  String get activeMissionCard => 'Active mission';

  @override
  String get redeemSeedsOrSubscribeShort => 'Redeem your seeds or subscribe';

  @override
  String get welcomeToEco2Plus => 'Welcome to ECO2\nPlus!';

  @override
  String get subscriptionActive =>
      'Your annual subscription is active. Enjoy every Plus feature from now on.';

  @override
  String get addPlantsWithoutLimit => 'Add plants without limits';

  @override
  String get gardenCanGrow => 'Your garden can grow as much as you want';

  @override
  String get sessionExpired => 'Your session expired. Please sign in again.';

  @override
  String get noNotificationsYet => 'You have no notifications right now.';

  @override
  String get needsAttention => 'Needs attention';

  @override
  String overdueByDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String get passwordMinSixChars =>
      'The password must be at least 6 characters';

  @override
  String get achievementUnlockedTitle => 'Achievement unlocked!';

  @override
  String get newPlantAddedTitle => 'New plant added';

  @override
  String newPlantAddedBody(String name) {
    return 'You added $name to your collection.';
  }

  @override
  String get lastWateredHelpShort =>
      'That\'s how we work out the next watering. If you don\'t know, we start counting from today.';

  @override
  String get conditionNotTracked =>
      'This condition is not tracked in the app yet.';

  @override
  String get tourSeedsDesc =>
      'You earn seeds by caring for your plants and completing missions. Spend them in the Store.';

  @override
  String get achievementsAndMissionsTitle => 'Achievements and missions';

  @override
  String get tourTrophyDesc =>
      'Here you can see your trophies, your mission progress and how much XP you have.';

  @override
  String get allNotificationsRead => 'All notifications marked as read.';

  @override
  String get aiSearch => 'AI search';

  @override
  String achievementUnlockedToast(String name, String reward) {
    return '🏆 Achievement unlocked! $name ($reward)';
  }

  @override
  String xpAndSeedsReward(int xp, int seeds) {
    return '+$xp XP · +$seeds seeds';
  }

  @override
  String xpReward(int xp) {
    return '+$xp XP';
  }

  @override
  String progressOfPlants(int current, int total) {
    return '$current of $total plants';
  }

  @override
  String progressOfCares(int current, int total) {
    return '$current of $total care actions';
  }

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String get gotIt => 'Got it';

  @override
  String get accept => 'Accept';

  @override
  String get viewSpecSheet => 'View sheet';

  @override
  String get history => 'History';

  @override
  String get tourHistoryDesc => 'Check your previous scans.';

  @override
  String get plantNotFound => 'Plant not found';

  @override
  String get editNickname => 'Edit nickname';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get photoRemoved => 'Photo removed.';

  @override
  String get photoUpdated => 'Photo updated.';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get genderPreferNotToSay => 'Prefer not to say';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get tempShort => 'Temp.';

  @override
  String get o2co2 => 'O₂ CO₂';

  @override
  String get confirmPayment => 'Confirm payment';

  @override
  String get card => 'Card';

  @override
  String get tourScanFavourite => 'Scan your favourite plant';

  @override
  String get tourScanFavouriteDesc => 'Identify any species with AI';

  @override
  String get exploreDiscounts => 'Explore exclusive discounts';

  @override
  String get exploreDiscountsDesc => 'Up to 20% off at partner nurseries';

  @override
  String redeemSeedsCount(int count) {
    return 'Redeem $count seeds';
  }

  @override
  String get waterings => 'Waterings';

  @override
  String get prunings => 'Prunings';

  @override
  String routeNotFound(String route) {
    return 'Route not found: $route';
  }

  @override
  String get careNoteHint => 'Lukewarm water · ~200ml · soil was already dry';

  @override
  String get tourNotificationsDesc =>
      'Real alerts: watering due, achievements unlocked and new plants.';

  @override
  String wateringDueNotification(String name) {
    return 'Watering due: $name needs water now.';
  }

  @override
  String get fullName => 'Full name';

  @override
  String plantWatered(String name) {
    return '$name watered 💧';
  }

  @override
  String get nicknameExample => 'e.g. green_gardener';

  @override
  String get plantNameExample => 'e.g. My Monstera';

  @override
  String unlockedOn(String date) {
    return 'Unlocked on $date';
  }

  @override
  String agoMinutes(int n) {
    return '${n}m ago';
  }

  @override
  String agoHours(int n) {
    return '${n}h ago';
  }

  @override
  String agoDays(int n) {
    return '${n}d ago';
  }

  @override
  String get wateringDueTitle => 'Watering due';

  @override
  String get muteReminders => 'Mute reminders';

  @override
  String get muteRemindersOn => 'You won\'t get watering alerts for this plant';

  @override
  String get muteRemindersOff => 'You\'ll get alerts when it needs watering';

  @override
  String remindersMuted(String name) {
    return 'Reminders muted for $name';
  }

  @override
  String remindersUnmuted(String name) {
    return 'Reminders back on for $name';
  }

  @override
  String get logCare => 'Log care';

  @override
  String get achFirstSteps => 'First Steps';

  @override
  String get achBotanicalEye => 'Botanical Eye';

  @override
  String get achFirstRoom => 'My First Room';

  @override
  String get achHandsOn => 'Hands On';

  @override
  String get achSteadyCarer => 'Steady Carer';

  @override
  String get achGreenGuardian => 'Green Guardian';

  @override
  String get achCareMaster => 'Care Master';

  @override
  String get achBotanicalLegend => 'Botanical Legend';

  @override
  String get achMyLittleGarden => 'My Little Garden';

  @override
  String get achCollector => 'Collector';

  @override
  String get achDescOnboarding => 'Complete the ECO2 onboarding';

  @override
  String get achDescFirstScan => 'Scan your first plant with AI';

  @override
  String get achDescFirstRoom => 'Create your first room';

  @override
  String get achDescFirstCare => 'Log your first care action';

  @override
  String achDescNCares(int count) {
    return 'Log $count care actions';
  }

  @override
  String achDescNPlants(int count) {
    return 'Add $count plants to your collection';
  }

  @override
  String get aboutThisPlant => 'About this plant';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get beginner => 'Beginner';

  @override
  String get expert => 'Expert';

  @override
  String get care => 'Care';

  @override
  String carEquivalent(String meters) {
    return 'Same as a car driving ${meters}m';
  }

  @override
  String get securePayments => 'Secure payments with 256-bit SSL encryption';

  @override
  String get selectedPlan => '★ SELECTED PLAN';

  @override
  String get eco2PlusAnnual => 'ECO2 Plus Annual';

  @override
  String get cancelAnytime => 'Cancel any time';

  @override
  String get totalToPay => 'Total to pay';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String perMonthPrice(String amount) {
    return '$amount/month';
  }

  @override
  String get filters => 'Filters';

  @override
  String get clear => 'Clear';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get unlockO2Features => 'Unlock O₂₊ features';

  @override
  String get done => 'Done';

  @override
  String get customizeYourEco2 => 'Personalise your ECO2 experience';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get optional => '(optional)';

  @override
  String get continueAction => 'Continue';

  @override
  String get newScan => 'New scan';

  @override
  String matchPercent(int pct) {
    return '$pct% match';
  }

  @override
  String get takePhotoAction => 'Take photo';

  @override
  String get date => 'Date';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get scanHistory => 'Scan history';

  @override
  String get otherPossibilities => 'Other possibilities';

  @override
  String get viewO2Plus => 'See O₂₊';

  @override
  String get exportToCalendar => 'Export to calendar';

  @override
  String eventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '1 event',
    );
    return '$_temp0';
  }

  @override
  String get viewFullSheet => 'view full sheet';

  @override
  String get myPersonalNote => 'My personal note';

  @override
  String get noPlantNeedsWater => 'No plant needs watering right now.';

  @override
  String get waterAction => 'Water';

  @override
  String get o2PlusLabel => 'O₂ PLUS';

  @override
  String get subscribeToO2Plus => 'Subscribe to O₂₊';

  @override
  String get minCharsSuffix => ' · min. 8 characters';

  @override
  String get startUsingPlus => 'Start using Plus';

  @override
  String seedsCost(int count) {
    return '$count seeds';
  }

  @override
  String seedsShort(int count) {
    return '$count sd.';
  }

  @override
  String get species => 'Species';

  @override
  String get gramsPerDayUnit => 'g/day';

  @override
  String everyNDaysCompact(int days) {
    return '${days}d';
  }

  @override
  String pendingMissionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending',
      one: '1 pending',
      zero: 'All done',
    );
    return '$_temp0';
  }

  @override
  String seedsCountShort(int count) {
    return '$count seeds';
  }

  @override
  String get unitCares => 'care actions';

  @override
  String get unitPlants => 'plants';

  @override
  String get filterAll => 'All';

  @override
  String get fertilizings => 'Feedings';

  @override
  String get tabActive => 'Active';

  @override
  String get tabCompleted => 'Completed';

  @override
  String get tabLocked => 'Locked';

  @override
  String get plantLimitReached =>
      'You\'ve reached your pot limit. With O₂₊ they\'re unlimited.';

  @override
  String get scanLimitReached =>
      'You\'ve used your 5 scans for today. With O₂₊ they\'re unlimited.';

  @override
  String get plusMember => 'O₂₊ member';

  @override
  String plusActiveUntil(String date) {
    return 'Active until $date';
  }

  @override
  String potsUsedOfLimit(int used, int limit) {
    return '$used of $limit pots';
  }

  @override
  String get potsUnlimited => 'Unlimited pots';

  @override
  String legacyPotsKept(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You keep $count pots from your previous O₂₊',
      one: 'You keep 1 pot from your previous O₂₊',
    );
    return '$_temp0';
  }

  @override
  String get legacyPotsExplainer =>
      'When O₂₊ ends no plant is deleted: you keep the ones you were caring for, and the limit only applies to new ones.';

  @override
  String rentalPotsActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rented pots',
      one: '1 rented pot',
    );
    return '$_temp0';
  }

  @override
  String rentalPotsExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Expires in $days days',
      one: 'Expires tomorrow',
      zero: 'Expires today',
    );
    return '$_temp0';
  }

  @override
  String rentalPotsFreeSlot(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You have $count free slots in your garden',
      one: 'You have 1 free slot in your garden',
    );
    return '$_temp0';
  }

  @override
  String get rentalPotsAllUsed => 'All your pots are in use';

  @override
  String get avatarAlreadyOwned => 'You already own this avatar.';

  @override
  String get avatarNotOwned => 'You need to buy this avatar first.';

  @override
  String avatarPurchased(String name) {
    return '$name unlocked!';
  }

  @override
  String buyForSeeds(int cost) {
    return 'Buy for $cost seeds';
  }

  @override
  String get earlierLabel => 'Earlier';

  @override
  String get noNotificationsBody =>
      'Watering reminders, achievements you unlock and plants you add will show up here.';

  @override
  String get noNotificationsTitle => 'All caught up';

  @override
  String get notEnoughSeeds => 'You don\'t have enough seeds.';

  @override
  String get owned => 'Owned';

  @override
  String get storeAvatarSubtitle => 'Permanent unlock';

  @override
  String get storeCriadoraTitle => 'Poultry keeper avatar';

  @override
  String get storeExploradorTitle => 'Explorer avatar';

  @override
  String get storeJardineraTitle => 'Gardener avatar';

  @override
  String get storeNoctilanaTitle => 'Noctilana avatar';

  @override
  String get thisWeekLabel => 'This week';

  @override
  String unreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread',
      one: '1 unread',
    );
    return '$_temp0';
  }

  @override
  String rentalPotsExpiresInHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'Expires in $hours hours',
      one: 'Expires in 1 hour',
    );
    return '$_temp0';
  }

  @override
  String rentalPotsExpiresInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Expires in $minutes minutes',
      one: 'Expires in 1 minute',
    );
    return '$_temp0';
  }

  @override
  String get rentalExpiredTitle => 'Your rented pot expired';

  @override
  String rentalExpiredOverLimit(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plants are over your current pot limit: $names.',
      one: '$names is over your current pot limit.',
    );
    return '$_temp0';
  }

  @override
  String rentalExpiredNothingHeld(int used, int limit) {
    return 'No plant depended on it: you are still at $used of $limit pots.';
  }

  @override
  String get rentalExpiredNothingDeleted =>
      'No plant has been deleted. You can keep caring for all of them; the limit only applies to new ones.';

  @override
  String get rentalExpiredRentAgain => 'Rent another';

  @override
  String get freePlanLabel => 'Free plan';

  @override
  String potsUsage(int used, int limit) {
    return '$used of $limit pots';
  }

  @override
  String scansUsage(int used, int limit) {
    return '$used of $limit scans today';
  }

  @override
  String get unlimited => 'Unlimited';

  @override
  String get activatePlus => 'Activate O₂₊';

  @override
  String get plusActivated => 'O₂₊ activated! Unlimited pots and scans.';

  @override
  String get cancelPlus => 'Cancel O₂₊';

  @override
  String get plusCancelled => 'You\'re back on the free plan.';

  @override
  String get simulatedPayment =>
      'Simulated payment: this app is a university project and takes no money.';

  @override
  String get nurseryDiscount => 'Nursery discount';

  @override
  String get nurseryDiscountIntro =>
      'Show this code at partner nurseries to get your discount.';

  @override
  String get yourCode => 'Your code';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get plusOnlyFeature => 'Available with O₂₊';

  @override
  String get copyCode => 'Copy code';

  @override
  String get plusUnlimitedSummary => 'Unlimited pots and scans';

  @override
  String get manage => 'Manage';

  @override
  String get chooseAvatar => 'Choose your avatar';

  @override
  String get avatarUpdated => 'Avatar updated';

  @override
  String get noAvatar => 'No avatar';

  @override
  String get avatarAgronomist => 'Agronomist';

  @override
  String get avatarFarmer => 'Farmer';

  @override
  String get avatarGardener => 'Gardener';

  @override
  String get avatarTechnologist => 'Technologist';

  @override
  String get avatarBreeder => 'Poultry keeper';

  @override
  String get avatarExplorer => 'Explorer';

  @override
  String get avatarScientist => 'Scientist';

  @override
  String get avatarFlorist => 'Florist';

  @override
  String get airQuality => 'Air Quality';

  @override
  String get currentCo2Level => 'Current CO2 level';

  @override
  String get airQualityGood => 'Good';

  @override
  String get airQualityModerate => 'Moderate — consider ventilating';

  @override
  String get airQualityPoor => 'Poor — ventilate now';

  @override
  String get co2SummaryError => 'Couldn\'t load your air quality data.';

  @override
  String get co2WeeklyEvolutionHelp => 'Daily average over the last 7 days';

  @override
  String get noReadingsYet => 'No readings yet';

  @override
  String get viewAirQuality => 'View air quality';
}
