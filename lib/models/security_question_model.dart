import '../l10n/generated/app_localizations.dart';

class SecurityQuestion {
  final String id;
  final String Function(AppLocalizations) label;

  const SecurityQuestion({required this.id, required this.label});
}

const kSecurityQuestions = [
  SecurityQuestion(id: 'pet',     label: _sqPet),
  SecurityQuestion(id: 'mother',  label: _sqMother),
  SecurityQuestion(id: 'school',  label: _sqSchool),
  SecurityQuestion(id: 'friend',  label: _sqFriend),
  SecurityQuestion(id: 'city',    label: _sqCity),
  SecurityQuestion(id: 'sibling', label: _sqSibling),
  SecurityQuestion(id: 'car',     label: _sqCar),
  SecurityQuestion(id: 'street',  label: _sqStreet),
];

String _sqPet(AppLocalizations l)     => l.sqPet;
String _sqMother(AppLocalizations l)  => l.sqMother;
String _sqSchool(AppLocalizations l)  => l.sqSchool;
String _sqFriend(AppLocalizations l)  => l.sqFriend;
String _sqCity(AppLocalizations l)    => l.sqCity;
String _sqSibling(AppLocalizations l) => l.sqSibling;
String _sqCar(AppLocalizations l)     => l.sqCar;
String _sqStreet(AppLocalizations l)  => l.sqStreet;

String questionLabel(String id, AppLocalizations l10n) {
  return kSecurityQuestions
      .firstWhere((q) => q.id == id,
          orElse: () => SecurityQuestion(id: id, label: (_) => id))
      .label(l10n);
}
