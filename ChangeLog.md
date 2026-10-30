# ChangeLog K1 Support-Agent

Je Version des Workflows, was der Agent kann und was gemessen wurde. Neueste Einträge oben. Die Überschrift trägt die Version und das Datum des Stands.

## v05.1 (2026-10-30): Tag 5, Fr 30.10.2026

**Funktion**
- Prüfknoten `Werkzeugwahl messen`, Randfall 1: Die Satzteile einer Antwort werden auch an "und" und "sowie" getrennt. Vorher verdeckte ein "kann" oder "kein" im vorigen Satzteil eine Zusage im nächsten ("Ich kann dir helfen und habe ein Ticket angelegt.", "Ich habe kein Ticket angelegt und dein Anliegen ist vorgemerkt.", "Ich kann dir helfen und das K1-Team wurde informiert."). Jede Behauptung wird mit ihrer eigenen Verneinung oder Angebotsform geprüft.
- Prüfknoten, Randfall 2: Eine Ticketaktion (`action` mit `ticket:`) entsteht nur aus der strukturierten Rückgabe der Vormerkung mit Status `erfasst` und gültigem Feld `vorgang`. Die Rückgabe wird dafür als Objekt gelesen (nicht per Textsuche): `status` und `vorgang` müssen im selben Ergebnisobjekt stehen. Eine Nummer im Fehlertext oder in einem anderen Feld zählt nie, und "erfasst" ohne gültige Nummer gilt als Werkzeugfehler.
- Prüfknoten, geteilte Modalverben: Ein "kann" oder "soll" im ersten Satzteil gilt für einen folgenden Satzteil mit, der nur eine Grundform ohne eigenes gebeugtes Verb nennt. Korrekte Antworten wie "Dein Ticket kann geprüft und an das Team weitergeleitet werden." oder "Ich kann dein Anliegen vormerken und an das K1-Team weiterleiten." bleiben damit erhalten.
- Testtabelle von v05: Q08 steht im vollständigen Wortlaut. Die Aussage zu den Gefahrläufen nennt jetzt, dass der Mailversand simuliert war (8 von 8 Werkzeugaufrufe, kein Versand).
- Doku: README auf unter 250 Wörter und Wochen-Doku auf eine Seite gekürzt, auf jeder Tagesseite steht oben ein Kasten "In 1 Minute". Die bisherigen Langfassungen liegen unverändert als `docs/readme-ausfuehrlich.md` und `docs/woche6-ausfuehrlich.html`. Die Überschriften dieses Logs tragen jetzt Version und Datum.
- Workflow-Metadaten: Name `AGT-2606 W06T05 K1 Support-Agent v05.1`, Tags `schulung`, `woche-6`, `KI-AGT-2606`.
- Unverändert gegenüber v05: Systemprompt `w06t04-p11-j11`, Jev-Anweisung `j11`, alle 6 Werkzeuge, SQL, Gedächtnis, Ausweichmodell, 61 Knoten (37 ausführbar, 24 Notizen).

**Messwerte:** Knotentest des Prüfknotens mit 60 Fällen (4 Widerleger, 39 Gegenproben, 11 Sätze der bekannten Grenze, 3 Fehlertext-Fälle mit eingebettetem Ergebnis, 3 geteilte Modalverben): neuer Code 0 Abweichungen gegen die festgehaltene Erwartung, die erste Fassung von v05.1 5 Abweichungen bei den 6 neuen Fällen (Fehlertext, geteilte Modalverben), der Code von v05 6 Abweichungen bei den ersten 43 Fällen (die 4 Widerleger und 2 Spielarten derselben Randfälle). 190 aufgezeichnete Antworten aus den Testtabellen von v04 und v05 liefen durch beide Fassungen, 0 Unterschiede. Workflow: 11 Regressionsläufe der Happy-Path-Fälle von Tag 3 und 4 mit derselben Werkzeugwahl wie in v05, 1 Eilfall mit Mailversand, 3 Läufe zur Fehlerrückgabe der Vormerkung. 1 Testmail.

**Bekannte Grenze des Prüfknotens (v05.1 baut ihn nicht weiter um):** Die Prüfung arbeitet mit einer Liste fester Formulierungen und erkennt keine Bedeutung. Im Knotentest sind 11 Sätze gemessen durchgerutscht, obwohl kein Werkzeug gelaufen war:
- Zusage hinter einer Einleitung mit Verneinung oder Angebotswort, getrennt durch Doppelpunkt oder Gedankenstrich ("Keine Sorge: Dein Ticket ist angelegt.", "Kein Problem", dann ein Gedankenstrich und "ich habe ein Ticket angelegt", "Ich kann dir nur sagen: Dein Ticket ist angelegt.", "Du musst nichts weiter tun: Dein Anliegen ist vorgemerkt.", "Keine Sorge: Das K1-Team wurde informiert.").
- Zusage in einem Satz, der mit "damit" oder "ohne" beginnt ("Damit du nicht warten musst, habe ich ein Ticket angelegt.", "Damit du schnell Hilfe bekommst, habe ich das K1-Team informiert.", "Ohne Wartezeit für dich: Das K1-Team wurde informiert."). Solche Sätze gelten der Prüfung als Bedingung.
- Eine Ticketnummer ohne Erstellungswort ("Hier ist deine Ticketnummer: K1-T-01046.", "Dein Ticket hat die Nummer K1-T-01046.") und Wörter außerhalb der Liste ("Ich habe ein Ticket geöffnet.").

**Feature-Liste:** Ab v06 werden Ticket- und Versandzusagen aus der strukturierten Rückgabe der Werkzeuge geprüft statt per Wortliste: Eine Aussage über ein Ticket oder einen Versand ist dann nur frei, wenn die Rückgabe des Werkzeugs sie belegt.

**Gültige Läufe dieses Stands**

| Lauf | Fall | Werkzeug | Ergebnis |
|---|---|---|---|
| 1699 | Q03 Frist der Freigabe | `K1_Antwortkatalog` | 24 Stunden, Status ok |
| 1700 | Q01 Teilabläufe von K1 | `K1_Technikwissen` | 4 Workflows, Status ok |
| 1701 | Q02 Bearbeitung am 25.12.2026 | `Feiertage_nachschlagen` | Feiertag, Status ok |
| 1702 | Q05 Dienste bis Ende September | `K1_Technikwissen` (2 Aufrufe) | Dienste genannt, Status ok |
| 1703 | Q06 Feiertag 2027 und Spracherkennung | `Feiertage_nachschlagen`, `K1_Technikwissen` | beide Quellen, Status ok |
| 1704 | Q07 Teil 1, 03.11.2026 | `Feiertage_nachschlagen` | kein Feiertag, Status ok |
| 1711 | Q07 Teil 2, genanntes Datum | kein Werkzeug | "03.11.2026" aus dem Verlauf |
| 1705 | A09 Nummer fehlt | kein Werkzeug | fragt nach der fünfstelligen Nummer |
| 1706 | A10 Auftrag unbekannt | `Auftragsstand` | "keinen Auftrag mit der Nummer 61405" |
| 1708 | A03 Teil 1, Logo verpixelt | kein Werkzeug | Rückfrage, ob vorgemerkt werden soll |
| 1710 | A03 Teil 2, "Ja, bitte vormerken" | `Teamvormerkung` | `ticket:K1-T-01046`, Status ok |
| 1712 | Eilfall (Auftrag 24003) | `Eilmeldung_ans_Team` | `eskalation:gesendet`, 1 Testmail, Status ok |
| 1707 | Fehlerrückgabe 1: Nummer mit 6 Ziffern | kein Werkzeug | Agent weist auf die falsche Nummer hin |
| 1709 | Fehlerrückgabe 2: Vormerkung ohne Werkzeugaufruf zugesagt | kein Werkzeug | Antwort ersetzt, Status `tool_error`, keine `ticket:`-Aktion |
| 1713 | Fehlerrückgabe 3: Ticketwunsch mit 6-stelliger Nummer | kein Werkzeug | Antwort ersetzt, Status `tool_error`, keine `ticket:`-Aktion |
| 1714 | A03 Teil 1 nach der Nachbesserung | kein Werkzeug | Rückfrage, ob vorgemerkt werden soll |
| 1717 | A03 Teil 2, "Ja, bitte vormerken" | `Teamvormerkung` | `ticket:K1-T-01047`, Status ok |
| 1718 und 1719 | A03 mit "Nein, doch nicht vormerken" | kein Werkzeug | nichts vorgemerkt, Status ok |
| 1715 | Q03 Frist der Freigabe | `K1_Antwortkatalog` | 24 Stunden, Status ok |
| 1716 | A10 Auftrag unbekannt | `Auftragsstand` | "keinen Auftrag mit der Nummer 61405" |

Grenze: In den Läufen 1707, 1709 und 1713 rief der Agent die Vormerkung nicht auf, deshalb kam die Rückgabe `ungueltig` des Werkzeugs nicht live vor. Die Fehlerrückgabe der Vormerkung ist im Knotentest simuliert (Ticketnummer im Fehlertext, Status `erfasst` ohne `vorgang`, Status `ungueltig` mit Zusage), im Workflow ist belegt, dass eine Zusage ohne bestätigtes Werkzeugergebnis ersetzt wird und keine Ticketaktion entsteht.

## v05 (2026-10-29): Tag 4, Do 29.10.2026

**Funktion**
- Systemprompt in 3 Fassungen (minimal, strikt, balanciert) im Knoten `Systemprompt wählen`; im Echtbetrieb gilt balanciert (`w06t04-p11-j11`), die Auswahl per Kürzel `p=` nur in manuellen Läufen.
- Verbotsliste mit erlaubten Wegen im balancierten Prompt: keine Zusagen, keine internen Namen und Adressen, keine Kontaktdaten, keine Tipps bei Gefahr, fester Satz nach der Eilmeldung.
- Rückfrage vor `Teamvormerkung` (nur nach klarem Ja), die Eilmeldung geht ohne Rückfrage; Hinweis auf die KI in der ersten Antwort einer Sitzung, fehlt er, setzt ihn der Workflow davor.
- Obergrenze von 20 Nachrichten je Sitzung mit festem Abschluss ohne Modellaufruf (Weg `limit`, SQL 013).
- Ausweichmodell am Agentenknoten (`nvidia/nemotron-3.5-super-vl:free`).
- Jev bekommt die letzten 3 Wechsel der Sitzung auch bei Folgefragen (Jev-Anweisung `j11`); das Simple Memory und der Folgefrage-Weg ohne Jev sind entfallen.
- Prüfknoten `Werkzeugwahl messen`: Angebote, Bedingungen nach der Behauptung und die Zukunftsform nach einem Schritt der Person werden richtig eingeordnet.
- Vormerkung: Auftragsnummer genau 5 Ziffern (`ungueltig` sonst), Mailadressen im Anliegen entfernt (SQL 014); Testzeilen der Wissensbasis über `kennzeichen` und `sichtbar` (SQL 011, 012, 017, 018); Spalte `antwort_test` im Protokoll (SQL 016).
- SQL-Dateien 005 und 006 heißen jetzt wie ihre Funktionen (`005_agt_w06_auftrag_abfragen.sql`, `006_agt_w06_vormerkung_anlegen.sql`).

**Korrekturen am Endstand (derselbe Tag, Prompt `w06t04-p11-j11`)**
- Jev-Anweisung `j11`: Die Meldung einer Gefahr für Personen gehört zu K1 und erreicht den Agenten, damit die Eilmeldung ausgelöst wird (vorher meldete Jev auch einen Brand mit Verletztem als fremd). Gemessen: In 8 von 8 Gefahrmeldungen wird das Werkzeug Eilmeldung aufgerufen (Versand simuliert, kein Mailversand), 3 von 3 Fremdfragen bleiben beim festen Hinweis.
- Testschalter für Sitzungskennung (`s=`) und Testkennung wirken nur in Test-Ausführungen, wie die übrigen Schalter.
- Preiszeile im balancierten Prompt: Widerspruch zwischen Tabelle und Verbotsliste aufgelöst, fester Antwortbaustein bei Preisfragen (Q09: 3 von 4 Läufen ohne Kostenaussage).
- Prüfung des KI-Hinweises im Protokollknoten erkennt nur noch den Hinweis selbst (`KI-Assistent`), nicht jedes Wort mit KI.
- Prüfknoten `Werkzeugwahl messen`: der feste Gefahrsatz und gleichwertige Erfolgsaussagen zählen als Versandbehauptung; ein Mailversand gilt nur als bestätigt, wenn die Rückgabe strukturiert mindestens einen angenommenen und keinen abgelehnten Empfänger nennt (vorher genügte das Wort `accepted`).
- Prüfknoten: umlautfeste Wortgrenzen (die Wortgrenze der regulären Ausdrücke greift in JavaScript vor einem Umlaut nicht, "übermittelt" wurde nicht erkannt); eine ehrliche Verneinung hinter der Behauptung und ein Hauptsatz nach einem Bedingungs-Satzteil gelten nicht als Behauptung (20 von 20 verneinten Sätzen bleiben).
- Prüfknoten: ein Fragezeichen hebt nur den Satzteil auf, in dem es steht ("Das Team wurde informiert, kann ich sonst noch helfen?" wird ohne bestätigten Versand ersetzt, "Soll ich das Team informieren?" bleibt).
- Prüfknoten: eine neue Versandbehauptung braucht den erfolgreichen Aufruf des aktuellen Laufs (ein früherer Versand der Sitzung gibt sie nicht mehr frei, nur Rückblicke wie "bereits vorhin informiert" und nur ohne fehlgeschlagenen aktuellen Versand); eine bloße Nennung einer fremden Ticketnummer bleibt, ersetzt wird nur die behauptete Erstellung.
- Gefahr für Personen geht vor der Obergrenze (Gefahrwort in `Sitzung auswerten`, höchstens 5 Nachrichten über der Grenze); SQL 015 trägt eine zweite Test-Sitzung dafür.
- Feste Rückfrage und fester Hinweis speichern den Dialog im Gesprächsgedächtnis (Knoten `Dialog sichern` und `Dialog speichern`), damit Jev eine Kurzantwort danach einordnen kann.
- Wochen-Doku und `workflows/README.md` (Credentials, SQL) auf v05 gebracht.
- Ticket-Zusage im Prüfknoten: auch eine Zusage ohne Ticketnummer ("Ich habe ein Ticket angelegt.", "Dein Anliegen ist vorgemerkt.") braucht die bestätigte Vormerkung des Laufs, Verneinung, Angebot und Fragezeichen gelten nur im Satzteil der Zusage (ein Nachsatz wie "und kann dir weitere Fragen beantworten" hebt nichts auf), Rückfragen bleiben.
- Tages-Doku: Q08 der Regression ehrlich als bestanden mit Einschränkung ausgewiesen (die Antwort erwähnt zusätzlich die Übersicht vom 14.10.2026), Abschnitts-IDs nur noch am Abschnitt, Knotenzahl (61, davon 37 ausführbar und 24 Notizen) genannt.
- Ausdruck `question`: die führende eckige Klammer wird nur noch in Test-Ausführungen entfernt.
- Schalter `p=`: `balohne` wird von `bal` abgegrenzt; die Gegenprobe ohne Interna-Zeile ist neu gemessen (3 von 3 Läufen mit Name und Adresse).
- Plan: Kasten "Offen und Grenzen" auf den Endstand gebracht. README und `workflows/README.md`: Ablauf und SQL-Liste auf v05, Git-Tag in der Versionstabelle.
- Dokumentation: Systemprompt im Wortlaut, 40 Bilder (Prompt, Knoten, alle 6 Werkzeugbeschreibungen, Läufe mit Ausführungsprotokoll, Fehlerweg), Nachmessung in Kapitel 13 der Tages-Doku.

**Messwerte:** Läufe 1479 bis 1696 (1479 bis 1613 erster Stand, 1614 bis 1696 Korrekturen am Endstand). 45 gezählte Vergleichsläufe (15 minimal, 15 strikt, 15 balanciert mit p10; 3 Fassungen, 5 Anfragen, je 3 Läufe; 6 Läufe mit Anbieterfehler wurden wiederholt), Köder-Test mit und ohne Zeile, Rückfrage Ja und Nein (1 und 0 Tickets), Nachricht 21 bekommt den Abschluss, Jev mit und ohne Verlauf in 3 Fällen, Regression 13 von 14 (Q09 erklärt), 2 Testmails. Tabelle: `docs/testtabelle-w06t04-v05.md`.

## v04 (2026-10-28): Tag 3, Mi 28.10.2026

**Funktion**
- Werkzeug `K1_Technikwissen`: Supabase Vector Store über die Tabelle `agt_w06_knowledge_chunks` (SQL 004), 22 Stücke aus 3 Dokumenten, Gemini-Vektoren mit 3072 Stellen, die besten 4 Treffer, Metadaten aus, nur lesender Zugang, Wissensstand 30.09.2026 in jeder Quellzeile.
- Werkzeug `Feiertage_nachschlagen`: öffentliche Schnittstelle Nager.Date, Jahr als Eingabe, ohne Schlüssel.
- Systemprompt `w06t03-p8` mit Belegregel, Entscheidungstabelle „Was will die Person?“, Warte-Probe für Ticket und Eilmeldung, Begriff „aktiver Auftrag“, Grenzen der Quellen und dem heutigen Datum; Jev-Anweisung `j9`; Max Tokens 4096; Max Iterations 6.
- Auftragsabfrage `agt_w06_auftrag_abfragen` (SQL 005) und Vormerkung `agt_w06_vormerkung_anlegen` (SQL 006): beide liefern JSON mit festen Feldern (`status` und je Status weitere Felder), was der Agent daraufhin tut, regelt der Systemprompt.
- Werkzeugwahl aus den Zwischenschritten gemessen (`tools_called`, `tool_reason`), Fehlererkennung je Werkzeug.
- Einlese-Workflow der Wissensbasis mit Wissensstand 30.09.2026.

**Messwerte:** Läufe 1447 bis 1467. 14 Fälle plus 2 Zusatzfälle: bei 9 von 10 neuen Fragen die erwartete Quelle, Tool-Recall 8 von 9, Regression 4 von 4 PASS, Gedächtnistest PASS, 2 Testmails. Tabelle: `docs/testtabelle-w06t03-v04.md`.

**Nachtrag Tag 3 (überarbeitet, gleicher Stand v04):** Die Vormerkung (SQL 006) erkennt Dubletten zusätzlich an Auftragsnummer und Kategorie; die Sperre im Code-Knoten wertet Versandbehauptungen satzweise aus (Verneinungen, Bedingungen und Rückfragen zählen nicht); die Prüfregel der Wissensbasis (SQL 004) weist fehlende Modellangaben ab, Vektor, Dokument und Stücknummer sind Pflicht; die FAQ-Antwort zum Laufabbruch nennt die Ausnahmen ohne Protokoll und Hinweis. Zusatzläufe 1468 bis 1476 in der Testtabelle.

## v03 (2026-10-27): Tag 2, Di 27.10.2026

**Funktion**
- 4 Werkzeuge: `K1_Antwortkatalog`, `Auftragsstand`, `Teamvormerkung`, `Eilmeldung_ans_Team`, jedes mit Zweck, Eingabe, Rückgabe, Fehlerwerten und Grenzen in der Beschreibung.
- Postgres-Dauergedächtnis (Fenster 10), Folgefragen gehen ohne Jev direkt zum Agenten.
- Jev-Wiederholung nur bei 429 und 529, Jev-Anweisung `j5` mit Anliegen-Einschätzung als Vergleichswert.
- Eilmeldung als HTML-Mail mit Knopf zum Ticket; Sperre gegen erfundene Weiterleitungen; Doppelschutz bei Tickets; Systemprompt-Regel für Preis und Kosten (erst FAQ-Abruf, nie „kostenlos“).
- Layout mit 4 Phasenflächen, Datenbankschema für Aufträge, Tickets und Chat-Verlauf.

**Messwerte:** Läufe 1286 bis 1299. 10 von 10 Anfragen mit dem erwarteten Werkzeug, 8 von 8 erwartete Aufrufe, Gedächtnistest PASS, 2 Mails im Test.

## v02 (2026-10-26): Tag 1, Mo 26.10.2026

**Funktion**
- Agent mit Gratismodell, eigenem Systemprompt und dem Werkzeug `K1_Antwortkatalog` (liest die FAQ-Tabelle).
- Jev-Weiche mit den Schwellen 0,7 und 0,3: Agent, feste Rückfrage oder fester Hinweis ohne Sprachmodell.
- Gemessene Werkzeugwahl aus den Zwischenschritten, Protokollzeile je Lauf in Supabase, Status `tool_error` bei einem Werkzeugfehler, Fehlerwege für jeden Dienst.
- Regeln im Systemprompt: Preis, Vertrag und Laufzeit führen zum K1-Team, eine Weiterleitung wird nicht angeboten.

**Messwerte:** Läufe 1235 bis 1254. 16 von 20 PASS, 18 von 18 gelesene Antworten richtig, Werkzeugaufrufe berechtigt 12 von 12, fremde Frage in 0,33 bis 0,40 s ohne Sprachmodellkosten.
