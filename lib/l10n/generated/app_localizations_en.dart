// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Ascrollbox';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get add => 'Add';

  @override
  String get rename => 'Rename';

  @override
  String get open => 'Open';

  @override
  String get edit => 'Edit';

  @override
  String get next => 'Next';

  @override
  String get confirm => 'Confirm';

  @override
  String get loginTagline => 'Save and organize your favorite videos';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get loginWithMicrosoft => 'Continue with Microsoft';

  @override
  String get loginWithMeta => 'Continue with Meta';

  @override
  String get loginTerms => 'By continuing you accept the Terms of Service';

  @override
  String loginError(String error) {
    return 'Sign-in error: $error';
  }

  @override
  String get home => 'Home';

  @override
  String get searchHint => 'Search videos…';

  @override
  String get addVideo => 'Add';

  @override
  String get addVideoTitle => 'Add video';

  @override
  String get pasteUrlHint => 'Paste the URL here';

  @override
  String get noVideosSaved => 'You have no saved videos';

  @override
  String get sharePrompt =>
      'Share a video from YouTube,\nTikTok, Instagram or Facebook';

  @override
  String get addByUrl => 'Add by URL';

  @override
  String get noResults => 'No results';

  @override
  String get videoSaved => 'Video saved';

  @override
  String get deleteVideo => 'Delete video';

  @override
  String deleteVideoConfirm(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get addToPack => 'Add to Pack';

  @override
  String addedToPack(String name) {
    return 'Added to \"$name\"';
  }

  @override
  String get createPackFirst => 'Create a pack first in the Packs section';

  @override
  String get play => 'Play';

  @override
  String get signOut => 'Sign out';

  @override
  String get labelsTitle => 'Labels';

  @override
  String get labelsSectionMostUsed => 'Your most used labels';

  @override
  String get labelsEmpty => 'No labels yet';

  @override
  String get labelsEmptySubtitle =>
      'Save videos and assign labels\nfor them to appear here';

  @override
  String get labelsSuggested => 'Suggested for this video';

  @override
  String get labelsCustomPlaceholder => 'Custom label…';

  @override
  String get labelsMaxReached => 'Maximum 5 labels';

  @override
  String labelsRemaining(int count) {
    return '$count remaining';
  }

  @override
  String get labelsDetecting => 'Detecting…';

  @override
  String get labelsSectionPopular => 'Popular';

  @override
  String get packsTitle => 'Packs';

  @override
  String get newPack => 'New Pack';

  @override
  String get packName => 'Pack name';

  @override
  String get createPack => 'Create';

  @override
  String get renamePack => 'Rename Pack';

  @override
  String get deletePack => 'Delete Pack';

  @override
  String deletePackConfirm(String name) {
    return 'Delete pack \"$name\"? Videos will not be deleted.';
  }

  @override
  String get packsEmpty => 'You have no packs yet';

  @override
  String get packsEmptySubtitle => 'Create collections of your favorite videos';

  @override
  String packVideosCount(int count) {
    return '$count video';
  }

  @override
  String packVideosCountPlural(int count) {
    return '$count videos';
  }

  @override
  String get packEmpty => 'This pack is empty';

  @override
  String get addVideos => 'Add videos';

  @override
  String get addVideosToPack => 'Add videos to pack';

  @override
  String get noAvailableVideos => 'No available videos to add';

  @override
  String get videoAddedToPack => 'Video added to pack';

  @override
  String get removeFromPack => 'Remove from pack';

  @override
  String openInApp(String appName) {
    return 'Open in $appName';
  }

  @override
  String get openAppFailed => 'Could not open the app';

  @override
  String savedOn(String date) {
    return 'Saved on $date';
  }

  @override
  String get sectionEntertainment => 'Entertainment';

  @override
  String get sectionEducation => 'Education';

  @override
  String get sectionLifestyle => 'Lifestyle';

  @override
  String get sectionFamily => 'Family';

  @override
  String get sectionSpirituality => 'Spirituality & Religion';

  @override
  String get sectionPolitics => 'Politics & Society';

  @override
  String get sectionBusiness => 'Business & Brand';

  @override
  String get sectionCreativity => 'Creativity';

  @override
  String get sectionCommunity => 'Community';

  @override
  String get sectionMentalHealth => 'Mental Health & Wellness';

  @override
  String get sectionGaming => 'Gaming & Technology';

  @override
  String get sectionSports => 'Sports';

  @override
  String get sectionTrending => 'Trending';

  @override
  String get tagHumorComedy => 'Humor & Comedy';

  @override
  String get tagSkitsActing => 'Skits & Acting';

  @override
  String get tagChallenges => 'Challenges';

  @override
  String get tagReactions => 'Reactions';

  @override
  String get tagPranks => 'Pranks';

  @override
  String get tagCompilations => 'Compilations';

  @override
  String get tagQuickTips => 'Quick Tips';

  @override
  String get tagTutorials => 'Tutorials';

  @override
  String get tagTechnology => 'Technology';

  @override
  String get tagFinance => 'Finance';

  @override
  String get tagLanguages => 'Languages';

  @override
  String get tagScience => 'Science';

  @override
  String get tagHistory => 'History';

  @override
  String get tagFunFacts => 'Fun Facts';

  @override
  String get tagMythologyCulture => 'Mythology & Culture';

  @override
  String get tagBooksReading => 'Books & Reading';

  @override
  String get tagFitnessHealth => 'Fitness & Health';

  @override
  String get tagFood => 'Food';

  @override
  String get tagRecipes => 'Recipes';

  @override
  String get tagRestaurants => 'Restaurants';

  @override
  String get tagDiets => 'Diets';

  @override
  String get tagTravel => 'Travel';

  @override
  String get tagFashionBeauty => 'Fashion & Beauty';

  @override
  String get tagHomeDecor => 'Home & Decor';

  @override
  String get tagMinimalism => 'Minimalism';

  @override
  String get tagDailyRoutines => 'Daily Routines';

  @override
  String get tagParenting => 'Parenting';

  @override
  String get tagMotherhood => 'Motherhood';

  @override
  String get tagRelationships => 'Relationships';

  @override
  String get tagPets => 'Pets';

  @override
  String get tagFamilyMoments => 'Family Moments';

  @override
  String get tagPregnancyBabies => 'Pregnancy & Babies';

  @override
  String get tagChristianity => 'Christianity';

  @override
  String get tagCatholicism => 'Catholicism';

  @override
  String get tagIslam => 'Islam';

  @override
  String get tagBuddhism => 'Buddhism';

  @override
  String get tagJudaism => 'Judaism';

  @override
  String get tagSpirituality => 'Spirituality';

  @override
  String get tagMeditationMindfulness => 'Meditation & Mindfulness';

  @override
  String get tagFaithTestimony => 'Faith & Testimony';

  @override
  String get tagNewsCurrentEvents => 'News & Current Events';

  @override
  String get tagPoliticalOpinion => 'Political Opinion';

  @override
  String get tagHumanRights => 'Human Rights';

  @override
  String get tagEconomyPolicy => 'Economy & Policy';

  @override
  String get tagEnvironmentClimate => 'Environment & Climate';

  @override
  String get tagFeminismGender => 'Feminism & Gender';

  @override
  String get tagGeopolitics => 'Geopolitics';

  @override
  String get tagBehindTheScenes => 'Behind the Scenes';

  @override
  String get tagTestimonials => 'Testimonials';

  @override
  String get tagLaunchesPromos => 'Launches & Promos';

  @override
  String get tagEntrepreneurship => 'Entrepreneurship';

  @override
  String get tagDigitalMarketing => 'Digital Marketing';

  @override
  String get tagPersonalFinance => 'Personal Finance';

  @override
  String get tagArtIllustration => 'Art & Illustration';

  @override
  String get tagMusicCovers => 'Music & Covers';

  @override
  String get tagDance => 'Dance';

  @override
  String get tagPhotography => 'Photography';

  @override
  String get tagFilmEditing => 'Film & Editing';

  @override
  String get tagDiyCrafts => 'DIY & Crafts';

  @override
  String get tagActivism => 'Activism & Causes';

  @override
  String get tagOpinionCulture => 'Opinion & Culture';

  @override
  String get tagQa => 'Q&A';

  @override
  String get tagVolunteering => 'Volunteering';

  @override
  String get tagDiversityInclusion => 'Diversity & Inclusion';

  @override
  String get tagAnxietyStress => 'Anxiety & Stress';

  @override
  String get tagSelfEsteem => 'Self-Esteem';

  @override
  String get tagTherapyPsychology => 'Therapy & Psychology';

  @override
  String get tagMotivation => 'Motivation';

  @override
  String get tagGriefLoss => 'Grief & Loss';

  @override
  String get tagVideoGames => 'Video Games';

  @override
  String get tagGadgetReviews => 'Gadget Reviews';

  @override
  String get tagArtificialIntelligence => 'Artificial Intelligence';

  @override
  String get tagAppsSoftware => 'Apps & Software';

  @override
  String get tagCybersecurity => 'Cybersecurity';

  @override
  String get tagSoccer => 'Soccer';

  @override
  String get tagBasketball => 'Basketball';

  @override
  String get tagMartialArts => 'Martial Arts';

  @override
  String get tagExtremeSports => 'Extreme Sports';

  @override
  String get tagSportsHighlights => 'Highlights & Plays';

  @override
  String get tagViralAudio => 'Viral Audio';

  @override
  String get tagMemesFormats => 'Memes & Formats';

  @override
  String get tagTrendingChallenges => 'Trending Challenges';

  @override
  String get tagPov => 'POV';

  @override
  String get tagViralNews => 'Viral News';

  @override
  String get filterAll => 'All';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Add a note…';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortOldest => 'Oldest';

  @override
  String get sortByPlatform => 'By platform';

  @override
  String get editVideo => 'Edit';

  @override
  String get saveChanges => 'Save changes';
}
