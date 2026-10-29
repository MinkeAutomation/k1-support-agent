# ChangeLog K1 Support-Agent

Je Tag, was der Agent kann und was gemessen wurde. Neueste Einträge oben. `v` zählt die Stände des Workflows, `V` die Einträge dieses Logs.

## V4: Tag 4, Do 29.10.2026 (Workflow v05)

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
- Jev-Anweisung `j11`: Die Meldung einer Gefahr für Personen gehört zu K1 und erreicht den Agenten, damit die Eilmeldung ausgelöst wird (vorher meldete Jev auch einen Brand mit Verletztem als fremd). Gemessen: 8 von 8 Gefahrmeldungen lösen die Eilmeldung aus, 3 von 3 Fremdfragen bleiben beim festen Hinweis.
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

## V3: Tag 3, Mi 28.10.2026 (Workflow v04)

**Funktion**
- Werkzeug `K1_Technikwissen`: Supabase Vector Store über die Tabelle `agt_w06_knowledge_chunks` (SQL 004), 22 Stücke aus 3 Dokumenten, Gemini-Vektoren mit 3072 Stellen, die besten 4 Treffer, Metadaten aus, nur lesender Zugang, Wissensstand 30.09.2026 in jeder Quellzeile.
- Werkzeug `Feiertage_nachschlagen`: öffentliche Schnittstelle Nager.Date, Jahr als Eingabe, ohne Schlüssel.
- Systemprompt `w06t03-p8` mit Belegregel, Entscheidungstabelle „Was will die Person?“, Warte-Probe für Ticket und Eilmeldung, Begriff „aktiver Auftrag“, Grenzen der Quellen und dem heutigen Datum; Jev-Anweisung `j9`; Max Tokens 4096; Max Iterations 6.
- Auftragsabfrage `agt_w06_auftrag_abfragen` (SQL 005) und Vormerkung `agt_w06_vormerkung_anlegen` (SQL 006): beide liefern JSON mit festen Feldern (`status` und je Status weitere Felder), was der Agent daraufhin tut, regelt der Systemprompt.
- Werkzeugwahl aus den Zwischenschritten gemessen (`tools_called`, `tool_reason`), Fehlererkennung je Werkzeug.
- Einlese-Workflow der Wissensbasis mit Wissensstand 30.09.2026.

**Messwerte:** Läufe 1447 bis 1467. 14 Fälle plus 2 Zusatzfälle: bei 9 von 10 neuen Fragen die erwartete Quelle, Tool-Recall 8 von 9, Regression 4 von 4 PASS, Gedächtnistest PASS, 2 Testmails. Tabelle: `docs/testtabelle-w06t03-v04.md`.

**Nachtrag Tag 3 (überarbeitet, gleicher Stand v04):** Die Vormerkung (SQL 006) erkennt Dubletten zusätzlich an Auftragsnummer und Kategorie; die Sperre im Code-Knoten wertet Versandbehauptungen satzweise aus (Verneinungen, Bedingungen und Rückfragen zählen nicht); die Prüfregel der Wissensbasis (SQL 004) weist fehlende Modellangaben ab, Vektor, Dokument und Stücknummer sind Pflicht; die FAQ-Antwort zum Laufabbruch nennt die Ausnahmen ohne Protokoll und Hinweis. Zusatzläufe 1468 bis 1476 in der Testtabelle.

## V2: Tag 2, Di 27.10.2026 (Workflow v03)

**Funktion**
- 4 Werkzeuge: `K1_Antwortkatalog`, `Auftragsstand`, `Teamvormerkung`, `Eilmeldung_ans_Team`, jedes mit Zweck, Eingabe, Rückgabe, Fehlerwerten und Grenzen in der Beschreibung.
- Postgres-Dauergedächtnis (Fenster 10), Folgefragen gehen ohne Jev direkt zum Agenten.
- Jev-Wiederholung nur bei 429 und 529, Jev-Anweisung `j5` mit Anliegen-Einschätzung als Vergleichswert.
- Eilmeldung als HTML-Mail mit Knopf zum Ticket; Sperre gegen erfundene Weiterleitungen; Doppelschutz bei Tickets; Systemprompt-Regel für Preis und Kosten (erst FAQ-Abruf, nie „kostenlos“).
- Layout mit 4 Phasenflächen, Datenbankschema für Aufträge, Tickets und Chat-Verlauf.

**Messwerte:** Läufe 1286 bis 1299. 10 von 10 Anfragen mit dem erwarteten Werkzeug, 8 von 8 erwartete Aufrufe, Gedächtnistest PASS, 2 Mails im Test.

## V1: Tag 1, Mo 26.10.2026 (Workflow v02)

**Funktion**
- Agent mit Gratismodell, eigenem Systemprompt und dem Werkzeug `K1_Antwortkatalog` (liest die FAQ-Tabelle).
- Jev-Weiche mit den Schwellen 0,7 und 0,3: Agent, feste Rückfrage oder fester Hinweis ohne Sprachmodell.
- Gemessene Werkzeugwahl aus den Zwischenschritten, Protokollzeile je Lauf in Supabase, Status `tool_error` bei einem Werkzeugfehler, Fehlerwege für jeden Dienst.
- Regeln im Systemprompt: Preis, Vertrag und Laufzeit führen zum K1-Team, eine Weiterleitung wird nicht angeboten.

**Messwerte:** Läufe 1235 bis 1254. 16 von 20 PASS, 18 von 18 gelesene Antworten richtig, Werkzeugaufrufe berechtigt 12 von 12, fremde Frage in 0,33 bis 0,40 s ohne Sprachmodellkosten.
