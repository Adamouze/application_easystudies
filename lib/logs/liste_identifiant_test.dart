const List<Map<String, String>> listeIdentifiantsEleves = [
  {
    'username': 'eleve1',
    'password': 'password1',
  },
  {
    'username': 'eleve2',
    'password': 'password2',
  },
];

const List<Map<String, String>> listeIdentifiantsProfs = [
  {
    'username': 'prof1',
    'password': 'password1',
  },
  {
    'username': 'prof2',
    'password': 'password2',
  },
];

const List<Map<String, String>> listeIdentifiantsSuperUsers = [
  {
    'username': 'su1',
    'password': 'password1',
  },
  {
    'username': 'su2',
    'password': 'password2',
  },
];

const List<Map<String, String>> listeIdentifiants = [
  ...listeIdentifiantsEleves,
  ...listeIdentifiantsProfs,
  ...listeIdentifiantsSuperUsers,
];
