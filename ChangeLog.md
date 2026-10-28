# ChangeLog K1 Support-Agent

Je Tag, was der Agent kann und was gemessen wurde. Neueste Einträge oben. `v` zählt die Stände des Workflows, `V` die Einträge dieses Logs.

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
