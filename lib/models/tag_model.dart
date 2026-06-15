import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

// ── Tag keys (stored in Firestore, English) ────────────────────────────────

// 🎭 Entertainment
const String kTagHumorComedy          = 'Humor & Comedy';
const String kTagSkitsActing          = 'Skits & Acting';
const String kTagChallenges           = 'Challenges';
const String kTagReactions            = 'Reactions';
const String kTagPranks               = 'Pranks';
const String kTagCompilations         = 'Compilations';
// 📚 Education
const String kTagQuickTips            = 'Quick Tips';
const String kTagTutorials            = 'Tutorials';
const String kTagTechnology           = 'Technology';
const String kTagFinance              = 'Finance';
const String kTagLanguages            = 'Languages';
const String kTagScience              = 'Science';
const String kTagHistory              = 'History';
const String kTagFunFacts             = 'Fun Facts';
const String kTagMythologyCulture     = 'Mythology & Culture';
const String kTagBooksReading         = 'Books & Reading';
// 🌿 Lifestyle
const String kTagFitnessHealth        = 'Fitness & Health';
const String kTagFood                 = 'Food';
const String kTagRecipes              = 'Recipes';
const String kTagRestaurants          = 'Restaurants';
const String kTagDiets                = 'Diets';
const String kTagTravel               = 'Travel';
const String kTagFashionBeauty        = 'Fashion & Beauty';
const String kTagHomeDecor            = 'Home & Decor';
const String kTagMinimalism           = 'Minimalism';
const String kTagDailyRoutines        = 'Daily Routines';
// 👨‍👩‍👧 Family
const String kTagParenting            = 'Parenting';
const String kTagMotherhood           = 'Motherhood';
const String kTagRelationships        = 'Relationships';
const String kTagPets                 = 'Pets';
const String kTagFamilyMoments        = 'Family Moments';
const String kTagPregnancyBabies      = 'Pregnancy & Babies';
// ✝️ Spirituality
const String kTagChristianity         = 'Christianity';
const String kTagCatholicism          = 'Catholicism';
const String kTagIslam                = 'Islam';
const String kTagBuddhism             = 'Buddhism';
const String kTagJudaism              = 'Judaism';
const String kTagSpirituality         = 'Spirituality';
const String kTagMeditationMindfulness = 'Meditation & Mindfulness';
const String kTagFaithTestimony       = 'Faith & Testimony';
// 🗳️ Politics & Society
const String kTagNewsCurrentEvents    = 'News & Current Events';
const String kTagPoliticalOpinion     = 'Political Opinion';
const String kTagHumanRights          = 'Human Rights';
const String kTagEconomyPolicy        = 'Economy & Policy';
const String kTagEnvironmentClimate   = 'Environment & Climate';
const String kTagFeminismGender       = 'Feminism & Gender';
const String kTagGeopolitics          = 'Geopolitics';
// 💼 Business & Brand
const String kTagBehindTheScenes      = 'Behind the Scenes';
const String kTagTestimonials         = 'Testimonials';
const String kTagLaunchesPromos       = 'Launches & Promos';
const String kTagEntrepreneurship     = 'Entrepreneurship';
const String kTagDigitalMarketing     = 'Digital Marketing';
const String kTagPersonalFinance      = 'Personal Finance';
// 🎨 Creativity
const String kTagArtIllustration      = 'Art & Illustration';
const String kTagMusicCovers          = 'Music & Covers';
const String kTagDance                = 'Dance';
const String kTagPhotography          = 'Photography';
const String kTagFilmEditing          = 'Film & Editing';
const String kTagDiyCrafts            = 'DIY & Crafts';
// 🤝 Community
const String kTagActivism             = 'Activism & Causes';
const String kTagOpinionCulture       = 'Opinion & Culture';
const String kTagQa                   = 'Q&A';
const String kTagVolunteering         = 'Volunteering';
const String kTagDiversityInclusion   = 'Diversity & Inclusion';
// 🧠 Mental Health
const String kTagAnxietyStress        = 'Anxiety & Stress';
const String kTagSelfEsteem           = 'Self-Esteem';
const String kTagTherapyPsychology    = 'Therapy & Psychology';
const String kTagMotivation           = 'Motivation';
const String kTagGriefLoss            = 'Grief & Loss';
// 🎮 Gaming & Tech
const String kTagVideoGames           = 'Video Games';
const String kTagGadgetReviews        = 'Gadget Reviews';
const String kTagArtificialIntelligence = 'Artificial Intelligence';
const String kTagAppsSoftware         = 'Apps & Software';
const String kTagCybersecurity        = 'Cybersecurity';
// ⚽ Sports
const String kTagSoccer               = 'Soccer';
const String kTagBasketball           = 'Basketball';
const String kTagMartialArts          = 'Martial Arts';
const String kTagExtremeSports        = 'Extreme Sports';
const String kTagSportsHighlights     = 'Highlights & Plays';
// 🔥 Trending
const String kTagViralAudio           = 'Viral Audio';
const String kTagMemesFormats         = 'Memes & Formats';
const String kTagTrendingChallenges   = 'Trending Challenges';
const String kTagPov                  = 'POV';
const String kTagViralNews            = 'Viral News';

// ── Ordered flat list of all predefined tag keys ──────────────────────────

const List<String> kPredefinedTags = [
  kTagHumorComedy, kTagSkitsActing, kTagChallenges, kTagReactions,
  kTagPranks, kTagCompilations,
  kTagQuickTips, kTagTutorials, kTagTechnology, kTagFinance, kTagLanguages,
  kTagScience, kTagHistory, kTagFunFacts, kTagMythologyCulture, kTagBooksReading,
  kTagFitnessHealth, kTagFood, kTagRecipes, kTagRestaurants, kTagDiets,
  kTagTravel, kTagFashionBeauty, kTagHomeDecor, kTagMinimalism, kTagDailyRoutines,
  kTagParenting, kTagMotherhood, kTagRelationships, kTagPets,
  kTagFamilyMoments, kTagPregnancyBabies,
  kTagChristianity, kTagCatholicism, kTagIslam, kTagBuddhism, kTagJudaism,
  kTagSpirituality, kTagMeditationMindfulness, kTagFaithTestimony,
  kTagNewsCurrentEvents, kTagPoliticalOpinion, kTagHumanRights,
  kTagEconomyPolicy, kTagEnvironmentClimate, kTagFeminismGender, kTagGeopolitics,
  kTagBehindTheScenes, kTagTestimonials, kTagLaunchesPromos,
  kTagEntrepreneurship, kTagDigitalMarketing, kTagPersonalFinance,
  kTagArtIllustration, kTagMusicCovers, kTagDance, kTagPhotography,
  kTagFilmEditing, kTagDiyCrafts,
  kTagActivism, kTagOpinionCulture, kTagQa, kTagVolunteering, kTagDiversityInclusion,
  kTagAnxietyStress, kTagSelfEsteem, kTagTherapyPsychology,
  kTagMotivation, kTagGriefLoss,
  kTagVideoGames, kTagGadgetReviews, kTagArtificialIntelligence,
  kTagAppsSoftware, kTagCybersecurity,
  kTagSoccer, kTagBasketball, kTagMartialArts, kTagExtremeSports, kTagSportsHighlights,
  kTagViralAudio, kTagMemesFormats, kTagTrendingChallenges, kTagPov, kTagViralNews,
];

// ── Emoji per tag key ─────────────────────────────────────────────────────

const Map<String, String> kTagEmoji = {
  kTagHumorComedy:           '😂',
  kTagSkitsActing:           '🎭',
  kTagChallenges:            '🏆',
  kTagReactions:             '😱',
  kTagPranks:                '🤡',
  kTagCompilations:          '📋',
  kTagQuickTips:             '💡',
  kTagTutorials:             '📖',
  kTagTechnology:            '💻',
  kTagFinance:               '💰',
  kTagLanguages:             '🌍',
  kTagScience:               '🔬',
  kTagHistory:               '🏛️',
  kTagFunFacts:              '🤔',
  kTagMythologyCulture:      '🏺',
  kTagBooksReading:          '📚',
  kTagFitnessHealth:         '💪',
  kTagFood:                  '🍕',
  kTagRecipes:               '🍳',
  kTagRestaurants:           '🍽️',
  kTagDiets:                 '🥗',
  kTagTravel:                '✈️',
  kTagFashionBeauty:         '👗',
  kTagHomeDecor:             '🏠',
  kTagMinimalism:            '✨',
  kTagDailyRoutines:         '📅',
  kTagParenting:             '👨‍👧',
  kTagMotherhood:            '👩‍👧',
  kTagRelationships:         '💑',
  kTagPets:                  '🐾',
  kTagFamilyMoments:         '👨‍👩‍👧',
  kTagPregnancyBabies:       '👶',
  kTagChristianity:          '✝️',
  kTagCatholicism:           '⛪',
  kTagIslam:                 '☪️',
  kTagBuddhism:              '☸️',
  kTagJudaism:               '✡️',
  kTagSpirituality:          '🙏',
  kTagMeditationMindfulness: '🧘',
  kTagFaithTestimony:        '✨',
  kTagNewsCurrentEvents:     '📰',
  kTagPoliticalOpinion:      '🗳️',
  kTagHumanRights:           '✊',
  kTagEconomyPolicy:         '📊',
  kTagEnvironmentClimate:    '🌱',
  kTagFeminismGender:        '♀️',
  kTagGeopolitics:           '🌐',
  kTagBehindTheScenes:       '🎬',
  kTagTestimonials:          '💬',
  kTagLaunchesPromos:        '🚀',
  kTagEntrepreneurship:      '💼',
  kTagDigitalMarketing:      '📱',
  kTagPersonalFinance:       '💵',
  kTagArtIllustration:       '🎨',
  kTagMusicCovers:           '🎵',
  kTagDance:                 '💃',
  kTagPhotography:           '📸',
  kTagFilmEditing:           '🎬',
  kTagDiyCrafts:             '✂️',
  kTagActivism:              '📣',
  kTagOpinionCulture:        '💭',
  kTagQa:                    '❓',
  kTagVolunteering:          '🤝',
  kTagDiversityInclusion:    '🌈',
  kTagAnxietyStress:         '😰',
  kTagSelfEsteem:            '🪞',
  kTagTherapyPsychology:     '🧠',
  kTagMotivation:            '🚀',
  kTagGriefLoss:             '💔',
  kTagVideoGames:            '🎮',
  kTagGadgetReviews:         '📱',
  kTagArtificialIntelligence:'🤖',
  kTagAppsSoftware:          '💾',
  kTagCybersecurity:         '🔒',
  kTagSoccer:                '⚽',
  kTagBasketball:            '🏀',
  kTagMartialArts:           '🥋',
  kTagExtremeSports:         '🛹',
  kTagSportsHighlights:      '🏅',
  kTagViralAudio:            '🔊',
  kTagMemesFormats:          '😂',
  kTagTrendingChallenges:    '🔥',
  kTagPov:                   '👁️',
  kTagViralNews:             '📡',
};

// ── Sections for the tag picker ───────────────────────────────────────────

typedef TagSection = ({
  String emoji,
  String Function(AppLocalizations) label,
  List<String> tags,
});

final List<TagSection> kTagSections = [
  (emoji: '🎭', label: (l) => l.sectionEntertainment, tags: [
    kTagHumorComedy, kTagSkitsActing, kTagChallenges,
    kTagReactions, kTagPranks, kTagCompilations,
  ]),
  (emoji: '📚', label: (l) => l.sectionEducation, tags: [
    kTagQuickTips, kTagTutorials, kTagTechnology, kTagFinance,
    kTagLanguages, kTagScience, kTagHistory, kTagFunFacts,
    kTagMythologyCulture, kTagBooksReading,
  ]),
  (emoji: '🌿', label: (l) => l.sectionLifestyle, tags: [
    kTagFitnessHealth, kTagFood, kTagRecipes, kTagRestaurants, kTagDiets,
    kTagTravel, kTagFashionBeauty, kTagHomeDecor, kTagMinimalism, kTagDailyRoutines,
  ]),
  (emoji: '👨‍👩‍👧', label: (l) => l.sectionFamily, tags: [
    kTagParenting, kTagMotherhood, kTagRelationships,
    kTagPets, kTagFamilyMoments, kTagPregnancyBabies,
  ]),
  (emoji: '✝️', label: (l) => l.sectionSpirituality, tags: [
    kTagChristianity, kTagCatholicism, kTagIslam, kTagBuddhism,
    kTagJudaism, kTagSpirituality, kTagMeditationMindfulness, kTagFaithTestimony,
  ]),
  (emoji: '🗳️', label: (l) => l.sectionPolitics, tags: [
    kTagNewsCurrentEvents, kTagPoliticalOpinion, kTagHumanRights,
    kTagEconomyPolicy, kTagEnvironmentClimate, kTagFeminismGender, kTagGeopolitics,
  ]),
  (emoji: '💼', label: (l) => l.sectionBusiness, tags: [
    kTagBehindTheScenes, kTagTestimonials, kTagLaunchesPromos,
    kTagEntrepreneurship, kTagDigitalMarketing, kTagPersonalFinance,
  ]),
  (emoji: '🎨', label: (l) => l.sectionCreativity, tags: [
    kTagArtIllustration, kTagMusicCovers, kTagDance,
    kTagPhotography, kTagFilmEditing, kTagDiyCrafts,
  ]),
  (emoji: '🤝', label: (l) => l.sectionCommunity, tags: [
    kTagActivism, kTagOpinionCulture, kTagQa,
    kTagVolunteering, kTagDiversityInclusion,
  ]),
  (emoji: '🧠', label: (l) => l.sectionMentalHealth, tags: [
    kTagAnxietyStress, kTagSelfEsteem, kTagTherapyPsychology,
    kTagMotivation, kTagGriefLoss,
  ]),
  (emoji: '🎮', label: (l) => l.sectionGaming, tags: [
    kTagVideoGames, kTagGadgetReviews, kTagArtificialIntelligence,
    kTagAppsSoftware, kTagCybersecurity,
  ]),
  (emoji: '⚽', label: (l) => l.sectionSports, tags: [
    kTagSoccer, kTagBasketball, kTagMartialArts,
    kTagExtremeSports, kTagSportsHighlights,
  ]),
  (emoji: '🔥', label: (l) => l.sectionTrending, tags: [
    kTagViralAudio, kTagMemesFormats, kTagTrendingChallenges,
    kTagPov, kTagViralNews,
  ]),
];

// ── Localized display name of a tag key ───────────────────────────────────

String localizedTag(String key, AppLocalizations l) {
  return _tagL10n[key]?.call(l) ?? key;
}

/// Helper extension for use in widgets.
extension TagL10nExt on String {
  String localized(BuildContext context) =>
      localizedTag(this, AppLocalizations.of(context));
}

final _tagL10n = <String, String Function(AppLocalizations)>{
  kTagHumorComedy:            (l) => l.tagHumorComedy,
  kTagSkitsActing:            (l) => l.tagSkitsActing,
  kTagChallenges:             (l) => l.tagChallenges,
  kTagReactions:              (l) => l.tagReactions,
  kTagPranks:                 (l) => l.tagPranks,
  kTagCompilations:           (l) => l.tagCompilations,
  kTagQuickTips:              (l) => l.tagQuickTips,
  kTagTutorials:              (l) => l.tagTutorials,
  kTagTechnology:             (l) => l.tagTechnology,
  kTagFinance:                (l) => l.tagFinance,
  kTagLanguages:              (l) => l.tagLanguages,
  kTagScience:                (l) => l.tagScience,
  kTagHistory:                (l) => l.tagHistory,
  kTagFunFacts:               (l) => l.tagFunFacts,
  kTagMythologyCulture:       (l) => l.tagMythologyCulture,
  kTagBooksReading:           (l) => l.tagBooksReading,
  kTagFitnessHealth:          (l) => l.tagFitnessHealth,
  kTagFood:                   (l) => l.tagFood,
  kTagRecipes:                (l) => l.tagRecipes,
  kTagRestaurants:            (l) => l.tagRestaurants,
  kTagDiets:                  (l) => l.tagDiets,
  kTagTravel:                 (l) => l.tagTravel,
  kTagFashionBeauty:          (l) => l.tagFashionBeauty,
  kTagHomeDecor:              (l) => l.tagHomeDecor,
  kTagMinimalism:             (l) => l.tagMinimalism,
  kTagDailyRoutines:          (l) => l.tagDailyRoutines,
  kTagParenting:              (l) => l.tagParenting,
  kTagMotherhood:             (l) => l.tagMotherhood,
  kTagRelationships:          (l) => l.tagRelationships,
  kTagPets:                   (l) => l.tagPets,
  kTagFamilyMoments:          (l) => l.tagFamilyMoments,
  kTagPregnancyBabies:        (l) => l.tagPregnancyBabies,
  kTagChristianity:           (l) => l.tagChristianity,
  kTagCatholicism:            (l) => l.tagCatholicism,
  kTagIslam:                  (l) => l.tagIslam,
  kTagBuddhism:               (l) => l.tagBuddhism,
  kTagJudaism:                (l) => l.tagJudaism,
  kTagSpirituality:           (l) => l.tagSpirituality,
  kTagMeditationMindfulness:  (l) => l.tagMeditationMindfulness,
  kTagFaithTestimony:         (l) => l.tagFaithTestimony,
  kTagNewsCurrentEvents:      (l) => l.tagNewsCurrentEvents,
  kTagPoliticalOpinion:       (l) => l.tagPoliticalOpinion,
  kTagHumanRights:            (l) => l.tagHumanRights,
  kTagEconomyPolicy:          (l) => l.tagEconomyPolicy,
  kTagEnvironmentClimate:     (l) => l.tagEnvironmentClimate,
  kTagFeminismGender:         (l) => l.tagFeminismGender,
  kTagGeopolitics:            (l) => l.tagGeopolitics,
  kTagBehindTheScenes:        (l) => l.tagBehindTheScenes,
  kTagTestimonials:           (l) => l.tagTestimonials,
  kTagLaunchesPromos:         (l) => l.tagLaunchesPromos,
  kTagEntrepreneurship:       (l) => l.tagEntrepreneurship,
  kTagDigitalMarketing:       (l) => l.tagDigitalMarketing,
  kTagPersonalFinance:        (l) => l.tagPersonalFinance,
  kTagArtIllustration:        (l) => l.tagArtIllustration,
  kTagMusicCovers:            (l) => l.tagMusicCovers,
  kTagDance:                  (l) => l.tagDance,
  kTagPhotography:            (l) => l.tagPhotography,
  kTagFilmEditing:            (l) => l.tagFilmEditing,
  kTagDiyCrafts:              (l) => l.tagDiyCrafts,
  kTagActivism:               (l) => l.tagActivism,
  kTagOpinionCulture:         (l) => l.tagOpinionCulture,
  kTagQa:                     (l) => l.tagQa,
  kTagVolunteering:           (l) => l.tagVolunteering,
  kTagDiversityInclusion:     (l) => l.tagDiversityInclusion,
  kTagAnxietyStress:          (l) => l.tagAnxietyStress,
  kTagSelfEsteem:             (l) => l.tagSelfEsteem,
  kTagTherapyPsychology:      (l) => l.tagTherapyPsychology,
  kTagMotivation:             (l) => l.tagMotivation,
  kTagGriefLoss:              (l) => l.tagGriefLoss,
  kTagVideoGames:             (l) => l.tagVideoGames,
  kTagGadgetReviews:          (l) => l.tagGadgetReviews,
  kTagArtificialIntelligence: (l) => l.tagArtificialIntelligence,
  kTagAppsSoftware:           (l) => l.tagAppsSoftware,
  kTagCybersecurity:          (l) => l.tagCybersecurity,
  kTagSoccer:                 (l) => l.tagSoccer,
  kTagBasketball:             (l) => l.tagBasketball,
  kTagMartialArts:            (l) => l.tagMartialArts,
  kTagExtremeSports:          (l) => l.tagExtremeSports,
  kTagSportsHighlights:       (l) => l.tagSportsHighlights,
  kTagViralAudio:             (l) => l.tagViralAudio,
  kTagMemesFormats:           (l) => l.tagMemesFormats,
  kTagTrendingChallenges:     (l) => l.tagTrendingChallenges,
  kTagPov:                    (l) => l.tagPov,
  kTagViralNews:              (l) => l.tagViralNews,
};
