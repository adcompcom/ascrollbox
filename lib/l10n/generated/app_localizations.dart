import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Ascrollbox'**
  String get appName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Save and organize your favorite videos'**
  String get loginTagline;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginWithGoogle;

  /// No description provided for @loginWithMicrosoft.
  ///
  /// In en, this message translates to:
  /// **'Continue with Microsoft'**
  String get loginWithMicrosoft;

  /// No description provided for @loginWithMeta.
  ///
  /// In en, this message translates to:
  /// **'Continue with Meta'**
  String get loginWithMeta;

  /// No description provided for @loginTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing you accept the Terms of Service'**
  String get loginTerms;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Sign-in error: {error}'**
  String loginError(String error);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search videos…'**
  String get searchHint;

  /// No description provided for @addVideo.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addVideo;

  /// No description provided for @addVideoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add video'**
  String get addVideoTitle;

  /// No description provided for @pasteUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the URL here'**
  String get pasteUrlHint;

  /// No description provided for @noVideosSaved.
  ///
  /// In en, this message translates to:
  /// **'You have no saved videos'**
  String get noVideosSaved;

  /// No description provided for @sharePrompt.
  ///
  /// In en, this message translates to:
  /// **'Share a video from YouTube,\nTikTok, Instagram or Facebook'**
  String get sharePrompt;

  /// No description provided for @addByUrl.
  ///
  /// In en, this message translates to:
  /// **'Add by URL'**
  String get addByUrl;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @videoSaved.
  ///
  /// In en, this message translates to:
  /// **'Video saved'**
  String get videoSaved;

  /// No description provided for @deleteVideo.
  ///
  /// In en, this message translates to:
  /// **'Delete video'**
  String get deleteVideo;

  /// No description provided for @deleteVideoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String deleteVideoConfirm(String title);

  /// No description provided for @addToPack.
  ///
  /// In en, this message translates to:
  /// **'Add to Pack'**
  String get addToPack;

  /// No description provided for @addedToPack.
  ///
  /// In en, this message translates to:
  /// **'Added to \"{name}\"'**
  String addedToPack(String name);

  /// No description provided for @createPackFirst.
  ///
  /// In en, this message translates to:
  /// **'Create a pack first in the Packs section'**
  String get createPackFirst;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @labelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labelsTitle;

  /// No description provided for @labelsSectionMostUsed.
  ///
  /// In en, this message translates to:
  /// **'Your most used labels'**
  String get labelsSectionMostUsed;

  /// No description provided for @labelsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No labels yet'**
  String get labelsEmpty;

  /// No description provided for @labelsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save videos and assign labels\nfor them to appear here'**
  String get labelsEmptySubtitle;

  /// No description provided for @labelsSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested for this video'**
  String get labelsSuggested;

  /// No description provided for @labelsCustomPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Custom label…'**
  String get labelsCustomPlaceholder;

  /// No description provided for @labelsMaxReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum 5 labels'**
  String get labelsMaxReached;

  /// No description provided for @labelsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} remaining'**
  String labelsRemaining(int count);

  /// No description provided for @labelsDetecting.
  ///
  /// In en, this message translates to:
  /// **'Detecting…'**
  String get labelsDetecting;

  /// No description provided for @labelsSectionPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get labelsSectionPopular;

  /// No description provided for @packsTitle.
  ///
  /// In en, this message translates to:
  /// **'Packs'**
  String get packsTitle;

  /// No description provided for @newPack.
  ///
  /// In en, this message translates to:
  /// **'New Pack'**
  String get newPack;

  /// No description provided for @packName.
  ///
  /// In en, this message translates to:
  /// **'Pack name'**
  String get packName;

  /// No description provided for @createPack.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createPack;

  /// No description provided for @renamePack.
  ///
  /// In en, this message translates to:
  /// **'Rename Pack'**
  String get renamePack;

  /// No description provided for @deletePack.
  ///
  /// In en, this message translates to:
  /// **'Delete Pack'**
  String get deletePack;

  /// No description provided for @deletePackConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete pack \"{name}\"? Videos will not be deleted.'**
  String deletePackConfirm(String name);

  /// No description provided for @packsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no packs yet'**
  String get packsEmpty;

  /// No description provided for @packsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create collections of your favorite videos'**
  String get packsEmptySubtitle;

  /// No description provided for @packVideosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} video'**
  String packVideosCount(int count);

  /// No description provided for @packVideosCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} videos'**
  String packVideosCountPlural(int count);

  /// No description provided for @packEmpty.
  ///
  /// In en, this message translates to:
  /// **'This pack is empty'**
  String get packEmpty;

  /// No description provided for @addVideos.
  ///
  /// In en, this message translates to:
  /// **'Add videos'**
  String get addVideos;

  /// No description provided for @addVideosToPack.
  ///
  /// In en, this message translates to:
  /// **'Add videos to pack'**
  String get addVideosToPack;

  /// No description provided for @noAvailableVideos.
  ///
  /// In en, this message translates to:
  /// **'No available videos to add'**
  String get noAvailableVideos;

  /// No description provided for @videoAddedToPack.
  ///
  /// In en, this message translates to:
  /// **'Video added to pack'**
  String get videoAddedToPack;

  /// No description provided for @removeFromPack.
  ///
  /// In en, this message translates to:
  /// **'Remove from pack'**
  String get removeFromPack;

  /// No description provided for @openInApp.
  ///
  /// In en, this message translates to:
  /// **'Open in {appName}'**
  String openInApp(String appName);

  /// No description provided for @openAppFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the app'**
  String get openAppFailed;

  /// No description provided for @savedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved on {date}'**
  String savedOn(String date);

  /// No description provided for @sectionEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get sectionEntertainment;

  /// No description provided for @sectionEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get sectionEducation;

  /// No description provided for @sectionLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get sectionLifestyle;

  /// No description provided for @sectionFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get sectionFamily;

  /// No description provided for @sectionSpirituality.
  ///
  /// In en, this message translates to:
  /// **'Spirituality & Religion'**
  String get sectionSpirituality;

  /// No description provided for @sectionPolitics.
  ///
  /// In en, this message translates to:
  /// **'Politics & Society'**
  String get sectionPolitics;

  /// No description provided for @sectionBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business & Brand'**
  String get sectionBusiness;

  /// No description provided for @sectionCreativity.
  ///
  /// In en, this message translates to:
  /// **'Creativity'**
  String get sectionCreativity;

  /// No description provided for @sectionCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get sectionCommunity;

  /// No description provided for @sectionMentalHealth.
  ///
  /// In en, this message translates to:
  /// **'Mental Health & Wellness'**
  String get sectionMentalHealth;

  /// No description provided for @sectionGaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming & Technology'**
  String get sectionGaming;

  /// No description provided for @sectionSports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sectionSports;

  /// No description provided for @sectionTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get sectionTrending;

  /// No description provided for @tagHumorComedy.
  ///
  /// In en, this message translates to:
  /// **'Humor & Comedy'**
  String get tagHumorComedy;

  /// No description provided for @tagSkitsActing.
  ///
  /// In en, this message translates to:
  /// **'Skits & Acting'**
  String get tagSkitsActing;

  /// No description provided for @tagChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get tagChallenges;

  /// No description provided for @tagReactions.
  ///
  /// In en, this message translates to:
  /// **'Reactions'**
  String get tagReactions;

  /// No description provided for @tagPranks.
  ///
  /// In en, this message translates to:
  /// **'Pranks'**
  String get tagPranks;

  /// No description provided for @tagCompilations.
  ///
  /// In en, this message translates to:
  /// **'Compilations'**
  String get tagCompilations;

  /// No description provided for @tagQuickTips.
  ///
  /// In en, this message translates to:
  /// **'Quick Tips'**
  String get tagQuickTips;

  /// No description provided for @tagTutorials.
  ///
  /// In en, this message translates to:
  /// **'Tutorials'**
  String get tagTutorials;

  /// No description provided for @tagTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get tagTechnology;

  /// No description provided for @tagFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get tagFinance;

  /// No description provided for @tagLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get tagLanguages;

  /// No description provided for @tagScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get tagScience;

  /// No description provided for @tagHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tagHistory;

  /// No description provided for @tagFunFacts.
  ///
  /// In en, this message translates to:
  /// **'Fun Facts'**
  String get tagFunFacts;

  /// No description provided for @tagMythologyCulture.
  ///
  /// In en, this message translates to:
  /// **'Mythology & Culture'**
  String get tagMythologyCulture;

  /// No description provided for @tagBooksReading.
  ///
  /// In en, this message translates to:
  /// **'Books & Reading'**
  String get tagBooksReading;

  /// No description provided for @tagFitnessHealth.
  ///
  /// In en, this message translates to:
  /// **'Fitness & Health'**
  String get tagFitnessHealth;

  /// No description provided for @tagFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get tagFood;

  /// No description provided for @tagRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get tagRecipes;

  /// No description provided for @tagRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get tagRestaurants;

  /// No description provided for @tagDiets.
  ///
  /// In en, this message translates to:
  /// **'Diets'**
  String get tagDiets;

  /// No description provided for @tagTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get tagTravel;

  /// No description provided for @tagFashionBeauty.
  ///
  /// In en, this message translates to:
  /// **'Fashion & Beauty'**
  String get tagFashionBeauty;

  /// No description provided for @tagHomeDecor.
  ///
  /// In en, this message translates to:
  /// **'Home & Decor'**
  String get tagHomeDecor;

  /// No description provided for @tagMinimalism.
  ///
  /// In en, this message translates to:
  /// **'Minimalism'**
  String get tagMinimalism;

  /// No description provided for @tagDailyRoutines.
  ///
  /// In en, this message translates to:
  /// **'Daily Routines'**
  String get tagDailyRoutines;

  /// No description provided for @tagParenting.
  ///
  /// In en, this message translates to:
  /// **'Parenting'**
  String get tagParenting;

  /// No description provided for @tagMotherhood.
  ///
  /// In en, this message translates to:
  /// **'Motherhood'**
  String get tagMotherhood;

  /// No description provided for @tagRelationships.
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get tagRelationships;

  /// No description provided for @tagPets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get tagPets;

  /// No description provided for @tagFamilyMoments.
  ///
  /// In en, this message translates to:
  /// **'Family Moments'**
  String get tagFamilyMoments;

  /// No description provided for @tagPregnancyBabies.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy & Babies'**
  String get tagPregnancyBabies;

  /// No description provided for @tagChristianity.
  ///
  /// In en, this message translates to:
  /// **'Christianity'**
  String get tagChristianity;

  /// No description provided for @tagCatholicism.
  ///
  /// In en, this message translates to:
  /// **'Catholicism'**
  String get tagCatholicism;

  /// No description provided for @tagIslam.
  ///
  /// In en, this message translates to:
  /// **'Islam'**
  String get tagIslam;

  /// No description provided for @tagBuddhism.
  ///
  /// In en, this message translates to:
  /// **'Buddhism'**
  String get tagBuddhism;

  /// No description provided for @tagJudaism.
  ///
  /// In en, this message translates to:
  /// **'Judaism'**
  String get tagJudaism;

  /// No description provided for @tagSpirituality.
  ///
  /// In en, this message translates to:
  /// **'Spirituality'**
  String get tagSpirituality;

  /// No description provided for @tagMeditationMindfulness.
  ///
  /// In en, this message translates to:
  /// **'Meditation & Mindfulness'**
  String get tagMeditationMindfulness;

  /// No description provided for @tagFaithTestimony.
  ///
  /// In en, this message translates to:
  /// **'Faith & Testimony'**
  String get tagFaithTestimony;

  /// No description provided for @tagNewsCurrentEvents.
  ///
  /// In en, this message translates to:
  /// **'News & Current Events'**
  String get tagNewsCurrentEvents;

  /// No description provided for @tagPoliticalOpinion.
  ///
  /// In en, this message translates to:
  /// **'Political Opinion'**
  String get tagPoliticalOpinion;

  /// No description provided for @tagHumanRights.
  ///
  /// In en, this message translates to:
  /// **'Human Rights'**
  String get tagHumanRights;

  /// No description provided for @tagEconomyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Economy & Policy'**
  String get tagEconomyPolicy;

  /// No description provided for @tagEnvironmentClimate.
  ///
  /// In en, this message translates to:
  /// **'Environment & Climate'**
  String get tagEnvironmentClimate;

  /// No description provided for @tagFeminismGender.
  ///
  /// In en, this message translates to:
  /// **'Feminism & Gender'**
  String get tagFeminismGender;

  /// No description provided for @tagGeopolitics.
  ///
  /// In en, this message translates to:
  /// **'Geopolitics'**
  String get tagGeopolitics;

  /// No description provided for @tagBehindTheScenes.
  ///
  /// In en, this message translates to:
  /// **'Behind the Scenes'**
  String get tagBehindTheScenes;

  /// No description provided for @tagTestimonials.
  ///
  /// In en, this message translates to:
  /// **'Testimonials'**
  String get tagTestimonials;

  /// No description provided for @tagLaunchesPromos.
  ///
  /// In en, this message translates to:
  /// **'Launches & Promos'**
  String get tagLaunchesPromos;

  /// No description provided for @tagEntrepreneurship.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneurship'**
  String get tagEntrepreneurship;

  /// No description provided for @tagDigitalMarketing.
  ///
  /// In en, this message translates to:
  /// **'Digital Marketing'**
  String get tagDigitalMarketing;

  /// No description provided for @tagPersonalFinance.
  ///
  /// In en, this message translates to:
  /// **'Personal Finance'**
  String get tagPersonalFinance;

  /// No description provided for @tagArtIllustration.
  ///
  /// In en, this message translates to:
  /// **'Art & Illustration'**
  String get tagArtIllustration;

  /// No description provided for @tagMusicCovers.
  ///
  /// In en, this message translates to:
  /// **'Music & Covers'**
  String get tagMusicCovers;

  /// No description provided for @tagDance.
  ///
  /// In en, this message translates to:
  /// **'Dance'**
  String get tagDance;

  /// No description provided for @tagPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get tagPhotography;

  /// No description provided for @tagFilmEditing.
  ///
  /// In en, this message translates to:
  /// **'Film & Editing'**
  String get tagFilmEditing;

  /// No description provided for @tagDiyCrafts.
  ///
  /// In en, this message translates to:
  /// **'DIY & Crafts'**
  String get tagDiyCrafts;

  /// No description provided for @tagActivism.
  ///
  /// In en, this message translates to:
  /// **'Activism & Causes'**
  String get tagActivism;

  /// No description provided for @tagOpinionCulture.
  ///
  /// In en, this message translates to:
  /// **'Opinion & Culture'**
  String get tagOpinionCulture;

  /// No description provided for @tagQa.
  ///
  /// In en, this message translates to:
  /// **'Q&A'**
  String get tagQa;

  /// No description provided for @tagVolunteering.
  ///
  /// In en, this message translates to:
  /// **'Volunteering'**
  String get tagVolunteering;

  /// No description provided for @tagDiversityInclusion.
  ///
  /// In en, this message translates to:
  /// **'Diversity & Inclusion'**
  String get tagDiversityInclusion;

  /// No description provided for @tagAnxietyStress.
  ///
  /// In en, this message translates to:
  /// **'Anxiety & Stress'**
  String get tagAnxietyStress;

  /// No description provided for @tagSelfEsteem.
  ///
  /// In en, this message translates to:
  /// **'Self-Esteem'**
  String get tagSelfEsteem;

  /// No description provided for @tagTherapyPsychology.
  ///
  /// In en, this message translates to:
  /// **'Therapy & Psychology'**
  String get tagTherapyPsychology;

  /// No description provided for @tagMotivation.
  ///
  /// In en, this message translates to:
  /// **'Motivation'**
  String get tagMotivation;

  /// No description provided for @tagGriefLoss.
  ///
  /// In en, this message translates to:
  /// **'Grief & Loss'**
  String get tagGriefLoss;

  /// No description provided for @tagVideoGames.
  ///
  /// In en, this message translates to:
  /// **'Video Games'**
  String get tagVideoGames;

  /// No description provided for @tagGadgetReviews.
  ///
  /// In en, this message translates to:
  /// **'Gadget Reviews'**
  String get tagGadgetReviews;

  /// No description provided for @tagArtificialIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Artificial Intelligence'**
  String get tagArtificialIntelligence;

  /// No description provided for @tagAppsSoftware.
  ///
  /// In en, this message translates to:
  /// **'Apps & Software'**
  String get tagAppsSoftware;

  /// No description provided for @tagCybersecurity.
  ///
  /// In en, this message translates to:
  /// **'Cybersecurity'**
  String get tagCybersecurity;

  /// No description provided for @tagSoccer.
  ///
  /// In en, this message translates to:
  /// **'Soccer'**
  String get tagSoccer;

  /// No description provided for @tagBasketball.
  ///
  /// In en, this message translates to:
  /// **'Basketball'**
  String get tagBasketball;

  /// No description provided for @tagMartialArts.
  ///
  /// In en, this message translates to:
  /// **'Martial Arts'**
  String get tagMartialArts;

  /// No description provided for @tagExtremeSports.
  ///
  /// In en, this message translates to:
  /// **'Extreme Sports'**
  String get tagExtremeSports;

  /// No description provided for @tagSportsHighlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights & Plays'**
  String get tagSportsHighlights;

  /// No description provided for @tagViralAudio.
  ///
  /// In en, this message translates to:
  /// **'Viral Audio'**
  String get tagViralAudio;

  /// No description provided for @tagMemesFormats.
  ///
  /// In en, this message translates to:
  /// **'Memes & Formats'**
  String get tagMemesFormats;

  /// No description provided for @tagTrendingChallenges.
  ///
  /// In en, this message translates to:
  /// **'Trending Challenges'**
  String get tagTrendingChallenges;

  /// No description provided for @tagPov.
  ///
  /// In en, this message translates to:
  /// **'POV'**
  String get tagPov;

  /// No description provided for @tagViralNews.
  ///
  /// In en, this message translates to:
  /// **'Viral News'**
  String get tagViralNews;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note…'**
  String get notesHint;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortOldest;

  /// No description provided for @sortByPlatform.
  ///
  /// In en, this message translates to:
  /// **'By platform'**
  String get sortByPlatform;

  /// No description provided for @editVideo.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editVideo;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
