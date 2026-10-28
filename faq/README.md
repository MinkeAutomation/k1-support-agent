# FAQ der Content-Maschine K1

`k1-faq.csv` ist die Wissensquelle des Support-Agenten. Das Werkzeug `K1_Antwortkatalog` liest die ganze Datei über ihre Raw-Adresse, der Agent sucht darin selbst nach dem passenden Eintrag.

> **Fiktiv-Hinweis:** Beispieldaten für eine Kursübung. Die Einträge beschreiben Funktionen des Kursprojekts K1, sind aber keine Zusagen an echte Kunden. Preise, Laufzeiten, Kündigung und Vertragsfragen stehen bewusst nicht in der Tabelle; fragt jemand danach, soll der Agent ehrlich sagen, dass er dazu keine Information hat, und an einen Menschen verweisen.

## Spalten

| Spalte | Inhalt |
|---|---|
| `id` | feste Kennung, zum Beispiel `K1-FREI-01`, für die Testtabelle |
| `kategorie` | Themengruppe (Hinweis, Auftrag, Ergebnis, Freigabe, Ablage, Gestaltung, Fehler, Datenschutz) |
| `frage` | Hauptformulierung der Frage |
| `stichworte` | Synonyme und Umgangssprache, mit `;` getrennt |
| `antwort` | 1 bis 3 Sätze, in sich verständlich, ohne Zeilenumbruch |
| `eskalation` | `ja`, wenn die Antwort allein nicht reicht und ein Mensch übernehmen sollte |
| `stand` | Datum der letzten Prüfung des Eintrags |

Format: UTF-8 ohne BOM, Komma als Trenner, Felder mit Komma in Anführungszeichen, eine Frage je Zeile.

**Nach jeder Änderung:** GitHub liefert Raw-Dateien mit 5 Minuten Zwischenspeicher aus. Vor dem nächsten Testlauf 5 Minuten warten oder die Raw-Adresse mit Commit-Kennung statt `main` verwenden.
