// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Ascrollbox';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get close => 'Schließen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get open => 'Öffnen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get next => 'Weiter';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get saving => 'Wird gespeichert…';

  @override
  String get loginTagline => 'Speichere und organisiere deine Lieblingsvideos';

  @override
  String get loginWithGoogle => 'Mit Google fortfahren';

  @override
  String get loginWithMicrosoft => 'Mit Microsoft fortfahren';

  @override
  String get loginWithMeta => 'Mit Meta fortfahren';

  @override
  String get loginTerms =>
      'Mit der Fortsetzung akzeptierst du die Nutzungsbedingungen';

  @override
  String loginError(String error) {
    return 'Anmeldefehler: $error';
  }

  @override
  String get loginCancelled =>
      'Anmeldung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get home => 'Start';

  @override
  String get searchHint => 'Videos suchen…';

  @override
  String get noVideosSaved => 'Verliere nie wieder ein Video! 🎬';

  @override
  String get sharePrompt =>
      'Öffne deine Lieblings-Apps, tippe auf Teilen und wähle Ascrollbox.\nSpeichere sie hier — immer nur einen Klick entfernt.';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get deleteVideo => 'Video löschen';

  @override
  String deleteVideoConfirm(String title) {
    return '„$title“ löschen?';
  }

  @override
  String get addToPack => 'Zu Pack hinzufügen';

  @override
  String addedToPack(String name) {
    return 'Zu „$name“ hinzugefügt';
  }

  @override
  String get createPackFirst => 'Erstelle zuerst einen Pack im Bereich Packs';

  @override
  String get play => 'Abspielen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get labelsTitle => 'Etiketten';

  @override
  String get labelsSectionMostUsed => 'Deine meistgenutzten Etiketten';

  @override
  String get labelsEmpty => 'Noch keine Etiketten';

  @override
  String get labelsEmptySubtitle =>
      'Speichere Videos und weise ihnen Etiketten zu,\ndamit sie hier erscheinen';

  @override
  String get labelsSuggested => 'Vorschläge für dieses Video';

  @override
  String get labelsCustomPlaceholder => 'Eigene Etikette…';

  @override
  String get labelsMaxReached => 'Maximal 5 Etiketten';

  @override
  String labelsRemaining(int count) {
    return '$count verbleibend';
  }

  @override
  String get labelsDetecting => 'Wird erkannt…';

  @override
  String get labelsSectionPopular => 'Beliebt';

  @override
  String get packsTitle => 'Packs';

  @override
  String get newPack => 'Neuer Pack';

  @override
  String get packName => 'Pack-Name';

  @override
  String get createPack => 'Erstellen';

  @override
  String get renamePack => 'Pack umbenennen';

  @override
  String get deletePack => 'Pack löschen';

  @override
  String deletePackConfirm(String name) {
    return 'Pack „$name“ löschen? Die Videos werden dabei nicht gelöscht.';
  }

  @override
  String get packsEmpty => 'Du hast noch keine Packs';

  @override
  String get packsEmptySubtitle => 'Erstelle Sammlungen deiner Lieblingsvideos';

  @override
  String packVideosCount(int count) {
    return '$count Video';
  }

  @override
  String packVideosCountPlural(int count) {
    return '$count Videos';
  }

  @override
  String get packEmpty => 'Dieser Pack ist leer';

  @override
  String get addVideos => 'Videos hinzufügen';

  @override
  String get addVideosToPack => 'Videos zum Pack hinzufügen';

  @override
  String get noAvailableVideos => 'Keine verfügbaren Videos zum Hinzufügen';

  @override
  String get videoAddedToPack => 'Video zum Pack hinzugefügt';

  @override
  String get removeFromPack => 'Aus Pack entfernen';

  @override
  String openInApp(String appName) {
    return 'In $appName öffnen';
  }

  @override
  String get openAppFailed => 'Die App konnte nicht geöffnet werden';

  @override
  String savedOn(String date) {
    return 'Gespeichert am $date';
  }

  @override
  String get sectionEntertainment => 'Unterhaltung';

  @override
  String get sectionEducation => 'Bildung';

  @override
  String get sectionLifestyle => 'Lifestyle';

  @override
  String get sectionFamily => 'Familie';

  @override
  String get sectionSpirituality => 'Spiritualität & Religion';

  @override
  String get sectionPolitics => 'Politik & Gesellschaft';

  @override
  String get sectionBusiness => 'Business & Marke';

  @override
  String get sectionCreativity => 'Kreativität';

  @override
  String get sectionCommunity => 'Community';

  @override
  String get sectionMentalHealth => 'Psychische Gesundheit & Wohlbefinden';

  @override
  String get sectionGaming => 'Gaming & Technologie';

  @override
  String get sectionSports => 'Sport';

  @override
  String get sectionTrending => 'Trends';

  @override
  String get tagHumorComedy => 'Humor & Comedy';

  @override
  String get tagSkitsActing => 'Sketche & Schauspiel';

  @override
  String get tagChallenges => 'Challenges';

  @override
  String get tagReactions => 'Reaktionen';

  @override
  String get tagPranks => 'Streiche';

  @override
  String get tagCompilations => 'Zusammenstellungen';

  @override
  String get tagQuickTips => 'Schnelle Tipps';

  @override
  String get tagTutorials => 'Tutorials';

  @override
  String get tagTechnology => 'Technologie';

  @override
  String get tagFinance => 'Finanzen';

  @override
  String get tagLanguages => 'Sprachen';

  @override
  String get tagScience => 'Wissenschaft';

  @override
  String get tagHistory => 'Geschichte';

  @override
  String get tagFunFacts => 'Wissenswertes';

  @override
  String get tagMythologyCulture => 'Mythologie & Kultur';

  @override
  String get tagBooksReading => 'Bücher & Lesen';

  @override
  String get tagFitnessHealth => 'Fitness & Gesundheit';

  @override
  String get tagFood => 'Essen';

  @override
  String get tagRecipes => 'Rezepte';

  @override
  String get tagRestaurants => 'Restaurants';

  @override
  String get tagDiets => 'Diäten';

  @override
  String get tagTravel => 'Reisen';

  @override
  String get tagFashionBeauty => 'Mode & Beauty';

  @override
  String get tagHomeDecor => 'Wohnen & Deko';

  @override
  String get tagMinimalism => 'Minimalismus';

  @override
  String get tagDailyRoutines => 'Alltagsroutinen';

  @override
  String get tagParenting => 'Elternschaft';

  @override
  String get tagMotherhood => 'Mutterschaft';

  @override
  String get tagRelationships => 'Beziehungen';

  @override
  String get tagPets => 'Haustiere';

  @override
  String get tagFamilyMoments => 'Familienmomente';

  @override
  String get tagPregnancyBabies => 'Schwangerschaft & Babys';

  @override
  String get tagChristianity => 'Christentum';

  @override
  String get tagCatholicism => 'Katholizismus';

  @override
  String get tagIslam => 'Islam';

  @override
  String get tagBuddhism => 'Buddhismus';

  @override
  String get tagJudaism => 'Judentum';

  @override
  String get tagSpirituality => 'Spiritualität';

  @override
  String get tagMeditationMindfulness => 'Meditation & Achtsamkeit';

  @override
  String get tagFaithTestimony => 'Glaube & Zeugnis';

  @override
  String get tagNewsCurrentEvents => 'Nachrichten & Aktuelles';

  @override
  String get tagPoliticalOpinion => 'Politische Meinung';

  @override
  String get tagHumanRights => 'Menschenrechte';

  @override
  String get tagEconomyPolicy => 'Wirtschaft & Politik';

  @override
  String get tagEnvironmentClimate => 'Umwelt & Klima';

  @override
  String get tagFeminismGender => 'Feminismus & Gender';

  @override
  String get tagGeopolitics => 'Geopolitik';

  @override
  String get tagBehindTheScenes => 'Behind the Scenes';

  @override
  String get tagTestimonials => 'Erfahrungsberichte';

  @override
  String get tagLaunchesPromos => 'Launches & Aktionen';

  @override
  String get tagEntrepreneurship => 'Unternehmertum';

  @override
  String get tagDigitalMarketing => 'Digitales Marketing';

  @override
  String get tagPersonalFinance => 'Persönliche Finanzen';

  @override
  String get tagArtIllustration => 'Kunst & Illustration';

  @override
  String get tagMusicCovers => 'Musik & Covers';

  @override
  String get tagDance => 'Tanz';

  @override
  String get tagPhotography => 'Fotografie';

  @override
  String get tagFilmEditing => 'Film & Schnitt';

  @override
  String get tagDiyCrafts => 'DIY & Basteln';

  @override
  String get tagActivism => 'Aktivismus & Anliegen';

  @override
  String get tagOpinionCulture => 'Meinung & Kultur';

  @override
  String get tagQa => 'Fragen & Antworten';

  @override
  String get tagVolunteering => 'Ehrenamt';

  @override
  String get tagDiversityInclusion => 'Vielfalt & Inklusion';

  @override
  String get tagAnxietyStress => 'Angst & Stress';

  @override
  String get tagSelfEsteem => 'Selbstwertgefühl';

  @override
  String get tagTherapyPsychology => 'Therapie & Psychologie';

  @override
  String get tagMotivation => 'Motivation';

  @override
  String get tagGriefLoss => 'Trauer & Verlust';

  @override
  String get tagVideoGames => 'Videospiele';

  @override
  String get tagGadgetReviews => 'Gadget-Tests';

  @override
  String get tagArtificialIntelligence => 'Künstliche Intelligenz';

  @override
  String get tagAppsSoftware => 'Apps & Software';

  @override
  String get tagCybersecurity => 'Cybersicherheit';

  @override
  String get tagSoccer => 'Fußball';

  @override
  String get tagBasketball => 'Basketball';

  @override
  String get tagMartialArts => 'Kampfsport';

  @override
  String get tagExtremeSports => 'Extremsport';

  @override
  String get tagSportsHighlights => 'Highlights & Spielzüge';

  @override
  String get tagViralAudio => 'Virale Audios';

  @override
  String get tagMemesFormats => 'Memes & Formate';

  @override
  String get tagTrendingChallenges => 'Angesagte Challenges';

  @override
  String get tagPov => 'POV';

  @override
  String get tagViralNews => 'Virale Nachrichten';

  @override
  String get filterAll => 'Alle';

  @override
  String get notes => 'Notizen';

  @override
  String get notesHint => 'Notiz hinzufügen…';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortNewest => 'Neueste';

  @override
  String get sortOldest => 'Älteste';

  @override
  String get sortByPlatform => 'Nach Plattform';

  @override
  String get editVideo => 'Bearbeiten';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get privateTitle => 'Privat';

  @override
  String get privateSetupTitle => 'Privaten PIN erstellen';

  @override
  String get privateSetupSubtitle =>
      'Wähle eine 6-stellige PIN, um deine privaten Videos zu schützen';

  @override
  String get privateConfirmTitle => 'Bestätige deine PIN';

  @override
  String get privateConfirmSubtitle => 'Wiederhole die 6 Ziffern';

  @override
  String get privateEnterSubtitle => 'Gib deine 6-stellige PIN ein';

  @override
  String get privatePinMismatch => 'PINs stimmen nicht überein';

  @override
  String get privatePinWrong => 'Falsche PIN';

  @override
  String get privateEmpty => 'Keine privaten Videos';

  @override
  String get privateEmptySubtitle =>
      'Verschiebe Videos hierher oder markiere sie\nbeim Speichern als privat';

  @override
  String get markAsPrivate => 'Privat';

  @override
  String get moveToPrivate => 'Zu Privat verschieben';

  @override
  String get moveToHome => 'Zu Start verschieben';

  @override
  String get movedToPrivate => 'Zu Privat verschoben';

  @override
  String get movedToHome => 'Zu Start verschoben';

  @override
  String get privateForgotPin => 'PIN vergessen?';

  @override
  String get sqTitle => 'Sicherheitsfragen';

  @override
  String get sqSetupSubtitle =>
      'Beantworte 3 Fragen, damit du deine PIN wiederherstellen kannst, falls du sie vergisst.';

  @override
  String get sqVerifySubtitle =>
      'Beantworte deine Sicherheitsfragen, um deine PIN zurückzusetzen.';

  @override
  String get sqSelectHint => 'Wähle eine Frage…';

  @override
  String get sqAnswerHint => 'Deine Antwort…';

  @override
  String get sqSave => 'Fragen speichern';

  @override
  String get sqVerify => 'Bestätigen';

  @override
  String get sqWrong =>
      'Eine oder mehrere Antworten sind falsch. Versuche es erneut.';

  @override
  String get sqSelectAll => 'Bitte wähle und beantworte alle 3 Fragen.';

  @override
  String get sqDuplicate => 'Bitte wähle 3 unterschiedliche Fragen.';

  @override
  String get sqPet => 'Wie hieß dein erstes Haustier?';

  @override
  String get sqMother => 'Wie lautet der Mädchenname deiner Mutter?';

  @override
  String get sqSchool => 'Wie hieß deine erste Schule?';

  @override
  String get sqFriend =>
      'Wie heißt dein bester Freund oder deine beste Freundin aus der Kindheit?';

  @override
  String get sqCity => 'In welcher Stadt wurdest du geboren?';

  @override
  String get sqSibling => 'Wie heißt dein ältestes Geschwister?';

  @override
  String get sqCar => 'Was war die Marke deines ersten Autos?';

  @override
  String get sqStreet => 'In welcher Straße bist du aufgewachsen?';

  @override
  String get myPacks => 'Meine Packs';

  @override
  String get sharedPacks => 'Geteilt';

  @override
  String get packDescription => 'Beschreibung';

  @override
  String get packDescriptionHint => 'Beschreibe deinen Pack…';

  @override
  String get packShare => 'Pack teilen';

  @override
  String get packPublish => 'Veröffentlichen';

  @override
  String get packUnpublish => 'Teilen beenden';

  @override
  String get packPublicLabel => 'Öffentlich';

  @override
  String get packPublicSubtitle => 'Für alle Community-Mitglieder sichtbar';

  @override
  String get packCodeOnlyLabel => 'Nur mit Code';

  @override
  String get packCodeOnlySubtitle => 'Nur über den Freigabecode zugänglich';

  @override
  String get packShareCode => 'Freigabecode';

  @override
  String get packShareCodeCopied => 'Code kopiert!';

  @override
  String packViews(int count) {
    return '$count Aufrufe';
  }

  @override
  String packShares(int count) {
    return '$count Speicherungen';
  }

  @override
  String packRatingCount(int count) {
    return '$count Bewertungen';
  }

  @override
  String get packAddToShared => 'Zu Geteilt hinzufügen';

  @override
  String get packAddedToShared => 'Zu Geteilt hinzugefügt!';

  @override
  String get packRemoveFromShared => 'Aus Geteilt entfernen';

  @override
  String get packRemovedFromShared => 'Aus Geteilt entfernt';

  @override
  String get packRateTitle => 'Bewerte diesen Pack';

  @override
  String get packRated => 'Danke für deine Bewertung!';

  @override
  String get packEnterCode => 'Pack-Code eingeben';

  @override
  String get packCodeHint => '6-stelliger Code (z. B. A3K9F2)';

  @override
  String get packNotFound =>
      'Pack nicht gefunden. Überprüfe den Code und versuche es erneut.';

  @override
  String get packSearch => 'Suchen';

  @override
  String get packExplore => 'Community entdecken';

  @override
  String get sharedEmpty => 'Noch keine gespeicherten Packs';

  @override
  String get sharedEmptySubtitle =>
      'Entdecke die Community oder gib einen Code ein,\num von anderen geteilte Packs zu finden.';

  @override
  String get communityEmpty => 'Noch keine öffentlichen Packs';

  @override
  String get communityEmptySubtitle =>
      'Sei der Erste, der einen Pack mit der Community teilt!';

  @override
  String get packPublished => 'Pack veröffentlicht!';

  @override
  String get packUnpublished => 'Pack aus der Community entfernt';

  @override
  String packBy(String name) {
    return 'Von $name';
  }

  @override
  String get packNoDescription => 'Keine Beschreibung';

  @override
  String get packIsPublic => 'Dieser Pack ist öffentlich';

  @override
  String get packIsCodeOnly => 'Nur über Code zugänglich';

  @override
  String get packShareSettings => 'Freigabeeinstellungen';

  @override
  String get packAlreadySaved => 'Bereits in deinem Bereich Geteilt';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profileSection => 'Profil';

  @override
  String get nickname => 'Benutzername';

  @override
  String get nicknameHint => 'So erscheinst du in geteilten Packs';

  @override
  String get changePhoto => 'Foto ändern';

  @override
  String get profileSaved => 'Profil gespeichert';

  @override
  String get privateSection => 'Privater Bereich';

  @override
  String get changePin => 'PIN ändern';

  @override
  String get accountSection => 'Konto';

  @override
  String get nicknameTaken => 'Dieser Benutzername ist bereits vergeben';

  @override
  String get nicknameInvalid =>
      'Nur Buchstaben, Zahlen, Punkte und Unterstriche erlaubt';

  @override
  String get appearanceSection => 'Darstellung';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';
}
