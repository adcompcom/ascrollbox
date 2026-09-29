// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Ascrollbox';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get close => 'Fechar';

  @override
  String get add => 'Adicionar';

  @override
  String get rename => 'Renomear';

  @override
  String get open => 'Abrir';

  @override
  String get edit => 'Editar';

  @override
  String get next => 'Próximo';

  @override
  String get confirm => 'Confirmar';

  @override
  String get saving => 'Salvando…';

  @override
  String get loginTagline => 'Salve e organize seus vídeos favoritos';

  @override
  String get loginWithGoogle => 'Continuar com o Google';

  @override
  String get loginWithMicrosoft => 'Continuar com a Microsoft';

  @override
  String get loginWithMeta => 'Continuar com a Meta';

  @override
  String get loginTerms => 'Ao continuar, você aceita os Termos de Serviço';

  @override
  String loginError(String error) {
    return 'Erro ao entrar: $error';
  }

  @override
  String get loginCancelled => 'Não foi possível entrar. Tente novamente.';

  @override
  String get home => 'Início';

  @override
  String get searchHint => 'Buscar vídeos…';

  @override
  String get noVideosSaved => 'Nunca mais perca um vídeo! 🎬';

  @override
  String get sharePrompt =>
      'Abra seus apps favoritos, toque em Compartilhar e escolha o Ascrollbox.\nSalve-os aqui — sempre a um toque de distância.';

  @override
  String get noResults => 'Nenhum resultado';

  @override
  String get deleteVideo => 'Excluir vídeo';

  @override
  String deleteVideoConfirm(String title) {
    return 'Excluir \"$title\"?';
  }

  @override
  String get addToPack => 'Adicionar ao Pack';

  @override
  String addedToPack(String name) {
    return 'Adicionado a \"$name\"';
  }

  @override
  String get createPackFirst => 'Crie um pack primeiro na seção Packs';

  @override
  String get play => 'Reproduzir';

  @override
  String get signOut => 'Sair';

  @override
  String get labelsTitle => 'Etiquetas';

  @override
  String get labelsSectionMostUsed => 'Suas etiquetas mais usadas';

  @override
  String get labelsEmpty => 'Ainda sem etiquetas';

  @override
  String get labelsEmptySubtitle =>
      'Salve vídeos e atribua etiquetas\npara que apareçam aqui';

  @override
  String get labelsSuggested => 'Sugeridas para este vídeo';

  @override
  String get labelsCustomPlaceholder => 'Etiqueta personalizada…';

  @override
  String get labelsMaxReached => 'Máximo de 5 etiquetas';

  @override
  String labelsRemaining(int count) {
    return '$count restantes';
  }

  @override
  String get labelsDetecting => 'Detectando…';

  @override
  String get labelsSectionPopular => 'Populares';

  @override
  String get packsTitle => 'Packs';

  @override
  String get newPack => 'Novo Pack';

  @override
  String get packName => 'Nome do pack';

  @override
  String get createPack => 'Criar';

  @override
  String get renamePack => 'Renomear Pack';

  @override
  String get deletePack => 'Excluir Pack';

  @override
  String deletePackConfirm(String name) {
    return 'Excluir o pack \"$name\"? Os vídeos não serão excluídos.';
  }

  @override
  String get packsEmpty => 'Você ainda não tem packs';

  @override
  String get packsEmptySubtitle => 'Crie coleções dos seus vídeos favoritos';

  @override
  String packVideosCount(int count) {
    return '$count vídeo';
  }

  @override
  String packVideosCountPlural(int count) {
    return '$count vídeos';
  }

  @override
  String get packEmpty => 'Este pack está vazio';

  @override
  String get addVideos => 'Adicionar vídeos';

  @override
  String get addVideosToPack => 'Adicionar vídeos ao pack';

  @override
  String get noAvailableVideos => 'Nenhum vídeo disponível para adicionar';

  @override
  String get videoAddedToPack => 'Vídeo adicionado ao pack';

  @override
  String get removeFromPack => 'Remover do pack';

  @override
  String openInApp(String appName) {
    return 'Abrir no $appName';
  }

  @override
  String get openAppFailed => 'Não foi possível abrir o app';

  @override
  String savedOn(String date) {
    return 'Salvo em $date';
  }

  @override
  String get sectionEntertainment => 'Entretenimento';

  @override
  String get sectionEducation => 'Educação';

  @override
  String get sectionLifestyle => 'Lifestyle';

  @override
  String get sectionFamily => 'Família';

  @override
  String get sectionSpirituality => 'Espiritualidade e religião';

  @override
  String get sectionPolitics => 'Política e sociedade';

  @override
  String get sectionBusiness => 'Negócios e marca';

  @override
  String get sectionCreativity => 'Criatividade';

  @override
  String get sectionCommunity => 'Comunidade';

  @override
  String get sectionMentalHealth => 'Saúde mental e bem-estar';

  @override
  String get sectionGaming => 'Games e tecnologia';

  @override
  String get sectionSports => 'Esportes';

  @override
  String get sectionTrending => 'Tendências';

  @override
  String get tagHumorComedy => 'Humor e comédia';

  @override
  String get tagSkitsActing => 'Esquetes e atuação';

  @override
  String get tagChallenges => 'Desafios';

  @override
  String get tagReactions => 'Reações';

  @override
  String get tagPranks => 'Pegadinhas';

  @override
  String get tagCompilations => 'Compilações';

  @override
  String get tagQuickTips => 'Dicas rápidas';

  @override
  String get tagTutorials => 'Tutoriais';

  @override
  String get tagTechnology => 'Tecnologia';

  @override
  String get tagFinance => 'Finanças';

  @override
  String get tagLanguages => 'Idiomas';

  @override
  String get tagScience => 'Ciência';

  @override
  String get tagHistory => 'História';

  @override
  String get tagFunFacts => 'Curiosidades';

  @override
  String get tagMythologyCulture => 'Mitologia e cultura geral';

  @override
  String get tagBooksReading => 'Livros e leitura';

  @override
  String get tagFitnessHealth => 'Fitness e saúde';

  @override
  String get tagFood => 'Comida';

  @override
  String get tagRecipes => 'Receitas';

  @override
  String get tagRestaurants => 'Restaurantes';

  @override
  String get tagDiets => 'Dietas';

  @override
  String get tagTravel => 'Viagens';

  @override
  String get tagFashionBeauty => 'Moda e beleza';

  @override
  String get tagHomeDecor => 'Casa e decoração';

  @override
  String get tagMinimalism => 'Minimalismo';

  @override
  String get tagDailyRoutines => 'Rotinas do dia a dia';

  @override
  String get tagParenting => 'Parentalidade';

  @override
  String get tagMotherhood => 'Maternidade';

  @override
  String get tagRelationships => 'Relacionamentos';

  @override
  String get tagPets => 'Animais de estimação';

  @override
  String get tagFamilyMoments => 'Momentos em família';

  @override
  String get tagPregnancyBabies => 'Gravidez e bebês';

  @override
  String get tagChristianity => 'Cristianismo';

  @override
  String get tagCatholicism => 'Catolicismo';

  @override
  String get tagIslam => 'Islã';

  @override
  String get tagBuddhism => 'Budismo';

  @override
  String get tagJudaism => 'Judaísmo';

  @override
  String get tagSpirituality => 'Espiritualidade geral';

  @override
  String get tagMeditationMindfulness => 'Meditação e mindfulness';

  @override
  String get tagFaithTestimony => 'Fé e testemunho';

  @override
  String get tagNewsCurrentEvents => 'Notícias e atualidades';

  @override
  String get tagPoliticalOpinion => 'Opinião política';

  @override
  String get tagHumanRights => 'Direitos humanos';

  @override
  String get tagEconomyPolicy => 'Economia e política pública';

  @override
  String get tagEnvironmentClimate => 'Meio ambiente e clima';

  @override
  String get tagFeminismGender => 'Feminismo e gênero';

  @override
  String get tagGeopolitics => 'Geopolítica';

  @override
  String get tagBehindTheScenes => 'Bastidores';

  @override
  String get tagTestimonials => 'Depoimentos';

  @override
  String get tagLaunchesPromos => 'Lançamentos e promoções';

  @override
  String get tagEntrepreneurship => 'Empreendedorismo';

  @override
  String get tagDigitalMarketing => 'Marketing digital';

  @override
  String get tagPersonalFinance => 'Finanças pessoais';

  @override
  String get tagArtIllustration => 'Arte e ilustração';

  @override
  String get tagMusicCovers => 'Música e covers';

  @override
  String get tagDance => 'Dança';

  @override
  String get tagPhotography => 'Fotografia';

  @override
  String get tagFilmEditing => 'Cinema e edição';

  @override
  String get tagDiyCrafts => 'Faça você mesmo';

  @override
  String get tagActivism => 'Ativismo e causas';

  @override
  String get tagOpinionCulture => 'Opinião e cultura';

  @override
  String get tagQa => 'Perguntas e respostas';

  @override
  String get tagVolunteering => 'Voluntariado';

  @override
  String get tagDiversityInclusion => 'Diversidade e inclusão';

  @override
  String get tagAnxietyStress => 'Ansiedade e estresse';

  @override
  String get tagSelfEsteem => 'Autoestima';

  @override
  String get tagTherapyPsychology => 'Terapia e psicologia';

  @override
  String get tagMotivation => 'Motivação';

  @override
  String get tagGriefLoss => 'Luto e perda';

  @override
  String get tagVideoGames => 'Video games';

  @override
  String get tagGadgetReviews => 'Análises de gadgets';

  @override
  String get tagArtificialIntelligence => 'Inteligência artificial';

  @override
  String get tagAppsSoftware => 'Apps e software';

  @override
  String get tagCybersecurity => 'Segurança cibernética';

  @override
  String get tagSoccer => 'Futebol';

  @override
  String get tagBasketball => 'Basquete';

  @override
  String get tagMartialArts => 'Artes marciais';

  @override
  String get tagExtremeSports => 'Esportes radicais';

  @override
  String get tagSportsHighlights => 'Melhores momentos';

  @override
  String get tagViralAudio => 'Áudios virais';

  @override
  String get tagMemesFormats => 'Memes e formatos';

  @override
  String get tagTrendingChallenges => 'Desafios em alta';

  @override
  String get tagPov => 'POV';

  @override
  String get tagViralNews => 'Notícias virais';

  @override
  String get filterAll => 'Todas';

  @override
  String get notes => 'Notas';

  @override
  String get notesHint => 'Adicionar uma nota…';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortNewest => 'Mais recentes';

  @override
  String get sortOldest => 'Mais antigos';

  @override
  String get sortByPlatform => 'Por plataforma';

  @override
  String get editVideo => 'Editar';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get privateTitle => 'Privado';

  @override
  String get privateSetupTitle => 'Criar PIN privado';

  @override
  String get privateSetupSubtitle =>
      'Escolha um PIN de 6 dígitos para proteger seus vídeos privados';

  @override
  String get privateConfirmTitle => 'Confirme seu PIN';

  @override
  String get privateConfirmSubtitle => 'Repita os 6 dígitos';

  @override
  String get privateEnterSubtitle => 'Digite seu PIN de 6 dígitos';

  @override
  String get privatePinMismatch => 'Os PINs não coincidem';

  @override
  String get privatePinWrong => 'PIN incorreto';

  @override
  String get privateEmpty => 'Nenhum vídeo privado';

  @override
  String get privateEmptySubtitle =>
      'Mova vídeos para cá ou marque-os como\nprivados ao salvar';

  @override
  String get markAsPrivate => 'Privado';

  @override
  String get moveToPrivate => 'Mover para Privado';

  @override
  String get moveToHome => 'Mover para Início';

  @override
  String get movedToPrivate => 'Movido para Privado';

  @override
  String get movedToHome => 'Movido para Início';

  @override
  String get privateForgotPin => 'Esqueceu seu PIN?';

  @override
  String get sqTitle => 'Perguntas de segurança';

  @override
  String get sqSetupSubtitle =>
      'Responda 3 perguntas para poder recuperar seu PIN caso o esqueça.';

  @override
  String get sqVerifySubtitle =>
      'Responda suas perguntas de segurança para redefinir seu PIN.';

  @override
  String get sqSelectHint => 'Selecione uma pergunta…';

  @override
  String get sqAnswerHint => 'Sua resposta…';

  @override
  String get sqSave => 'Salvar perguntas';

  @override
  String get sqVerify => 'Verificar';

  @override
  String get sqWrong =>
      'Uma ou mais respostas estão incorretas. Tente novamente.';

  @override
  String get sqSelectAll => 'Selecione e responda as 3 perguntas.';

  @override
  String get sqDuplicate => 'Escolha 3 perguntas diferentes.';

  @override
  String get sqPet => 'Qual era o nome do seu primeiro animal de estimação?';

  @override
  String get sqMother => 'Qual é o nome de solteira da sua mãe?';

  @override
  String get sqSchool => 'Qual era o nome da sua primeira escola?';

  @override
  String get sqFriend => 'Qual é o nome do seu melhor amigo de infância?';

  @override
  String get sqCity => 'Em que cidade você nasceu?';

  @override
  String get sqSibling => 'Qual é o primeiro nome do seu irmão mais velho?';

  @override
  String get sqCar => 'Qual era a marca do seu primeiro carro?';

  @override
  String get sqStreet => 'Em que rua você cresceu?';

  @override
  String get myPacks => 'Meus Packs';

  @override
  String get sharedPacks => 'Compartilhados';

  @override
  String get packDescription => 'Descrição';

  @override
  String get packDescriptionHint => 'Descreva seu pack…';

  @override
  String get packShare => 'Compartilhar pack';

  @override
  String get packPublish => 'Publicar';

  @override
  String get packUnpublish => 'Parar de compartilhar';

  @override
  String get packPublicLabel => 'Público';

  @override
  String get packPublicSubtitle =>
      'Visível para todos os usuários da comunidade';

  @override
  String get packCodeOnlyLabel => 'Somente por código';

  @override
  String get packCodeOnlySubtitle =>
      'Acessível apenas com o código de compartilhamento';

  @override
  String get packShareCode => 'Código de compartilhamento';

  @override
  String get packShareCodeCopied => 'Código copiado!';

  @override
  String packViews(int count) {
    return '$count visualizações';
  }

  @override
  String packShares(int count) {
    return '$count salvamentos';
  }

  @override
  String packRatingCount(int count) {
    return '$count avaliações';
  }

  @override
  String get packAddToShared => 'Adicionar a Compartilhados';

  @override
  String get packAddedToShared => 'Adicionado a Compartilhados!';

  @override
  String get packRemoveFromShared => 'Remover de Compartilhados';

  @override
  String get packRemovedFromShared => 'Removido de Compartilhados';

  @override
  String get packRateTitle => 'Avalie este pack';

  @override
  String get packRated => 'Obrigado por avaliar!';

  @override
  String get packEnterCode => 'Digite o código do pack';

  @override
  String get packCodeHint => 'Código de 6 caracteres (ex.: A3K9F2)';

  @override
  String get packNotFound =>
      'Pack não encontrado. Verifique o código e tente novamente.';

  @override
  String get packSearch => 'Buscar';

  @override
  String get packExplore => 'Explorar comunidade';

  @override
  String get sharedEmpty => 'Nenhum pack salvo ainda';

  @override
  String get sharedEmptySubtitle =>
      'Explore a comunidade ou digite um código\npara encontrar packs compartilhados por outras pessoas.';

  @override
  String get communityEmpty => 'Nenhum pack público ainda';

  @override
  String get communityEmptySubtitle =>
      'Seja o primeiro a compartilhar um pack com a comunidade!';

  @override
  String get packPublished => 'Pack publicado!';

  @override
  String get packUnpublished => 'Pack removido da comunidade';

  @override
  String packBy(String name) {
    return 'Por $name';
  }

  @override
  String get packNoDescription => 'Sem descrição';

  @override
  String get packIsPublic => 'Este pack é público';

  @override
  String get packIsCodeOnly => 'Acessível por código';

  @override
  String get packShareSettings => 'Configurações de compartilhamento';

  @override
  String get packAlreadySaved => 'Já está na sua seção Compartilhados';

  @override
  String get settings => 'Configurações';

  @override
  String get profileSection => 'Perfil';

  @override
  String get nickname => 'Apelido';

  @override
  String get nicknameHint => 'Como você aparece em packs compartilhados';

  @override
  String get changePhoto => 'Alterar foto';

  @override
  String get profileSaved => 'Perfil salvo';

  @override
  String get privateSection => 'Seção privada';

  @override
  String get changePin => 'Alterar PIN';

  @override
  String get accountSection => 'Conta';

  @override
  String get nicknameTaken => 'Este apelido já está em uso';

  @override
  String get nicknameInvalid =>
      'Somente letras, números, pontos e sublinhados são permitidos';

  @override
  String get appearanceSection => 'Aparência';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get timeJustNow => 'agora';

  @override
  String timeMinutesAgo(int count) {
    return 'há $count min';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count horas',
      one: 'há 1 hora',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count dias',
      one: 'há 1 dia',
    );
    return '$_temp0';
  }

  @override
  String timeWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count semanas',
      one: 'há 1 semana',
    );
    return '$_temp0';
  }

  @override
  String timeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count meses',
      one: 'há 1 mês',
    );
    return '$_temp0';
  }

  @override
  String timeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count anos',
      one: 'há 1 ano',
    );
    return '$_temp0';
  }
}
