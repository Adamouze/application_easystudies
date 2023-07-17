import 'utils.dart';

Eleve createEleve() {
  Eleve eleve_exemple = Eleve.basic("H9GZH3", "GAJENDRAN", "Ajanthan", "Term G", "M");
  eleve_exemple.ddn = "03/03/2005";
  eleve_exemple.etat = "Active";
  eleve_exemple.int_ent = "CTEF Admin";
  return eleve_exemple;
}

Bilan createBilan() {
  Bilan bilan_exemple = Bilan(
    "17/07/2023",  // Date
    "1",
    "3",  // Behavior
    "2",  // Assiduity
    "4", // Homeworks
    "Biology, Chemistry, Physics",  // Subjects
    "Focus more on practical examples",  // To improve
    "Good understanding of theory",  // Good
    "Keep up the good work",  // Comment
  );
  return bilan_exemple;
}

List<Eleve> createEleves() {
  // Création du bilan
  Bilan bilan_exemple = createBilan();

  // Création du premier élève
  Eleve eleve1 = Eleve.basic("H9GZH3", "GAJENDRAN", "Ajanthan", "Term G", "M");
  eleve1.ddn = "03/03/2005";
  eleve1.etat = "Active";
  eleve1.int_ent = "CTEF Admin";
  eleve1.bilans = [bilan_exemple, bilan_exemple];

  // Création du deuxième élève
  Eleve eleve2 = Eleve.basic("U5HWT6", "SMITH", "John", "Term G", "M");
  eleve2.ddn = "14/04/2005";
  eleve2.etat = "Active";
  eleve2.int_ent = "CTEF Admin";
  eleve2.bilans = [bilan_exemple];

  // Création du troisième élève
  Eleve eleve3 = Eleve.basic("D4E4ZF", "JOHNSON", "Emma", "Term G", "F");
  eleve3.ddn = "09/02/2005";
  eleve3.etat = "Active";
  eleve3.int_ent = "CTEF Admin";
  eleve3.bilans = [bilan_exemple, bilan_exemple, bilan_exemple];

  return [eleve1, eleve2, eleve3];
}


/*
* final Map<int, List<DataRow>> bilansEleves = {
      1: [
        DataRow(
          cells: <DataCell>[
            const DataCell(Center(child: Text('1'))), // centrage du contenu
            const DataCell(Center(child: Text('12/07/2023'))),
            const DataCell(Center(child: smiley1)),
            const DataCell(Center(child: smiley2)),
            const DataCell(Center(child: smiley3)),
            const DataCell(Center(child: smiley5)),
            DataCell(
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsContent(eleve: widget.eleve, bilan: widget.bilan)),
                    );
                  },
                  child: const Text('Détails'),
                ),
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Center(child: Text('2'))),
            const DataCell(Center(child: Text('13/07/2023'))),
            const DataCell(Center(child: smiley4)),
            const DataCell(Center(child: smiley4)),
            const DataCell(Center(child: smiley4)),
            const DataCell(Center(child: smiley1)),
            DataCell(
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsContent(eleve: widget.eleve, bilan: widget.bilan_ex)),
                    );
                  },
                  child: const Text('Détails'),
                ),
              ),
            ),
          ],
        ),
      ],

      2: [
        DataRow(
          cells: <DataCell>[
            const DataCell(Center(child: Text('1'))), // centrage du contenu
            const DataCell(Center(child: Text('12/07/2023'))),
            const DataCell(Center(child: smiley5)),
            const DataCell(Center(child: smiley4)),
            const DataCell(Center(child: smiley4)),
            const DataCell(Center(child: smiley2)),
            DataCell(
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsContent(eleve: widget.eleve, bilan: widget.bilan_ex)),
                    );
                  },
                  child: const Text('Détails'),
                ),
              ),
            ),
          ],
        ),
      ],
      // Ajoutez plus d'élèves si nécessaire
    };
* */
