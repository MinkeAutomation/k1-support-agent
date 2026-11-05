# K1 Support-Agent

n8n-Agent für Fragen zur Content-Maschine K1: ein Orchestrator verteilt jede Anfrage an 2 Agenten (Auskunft, Aktion), davor eine Jev-Weiche, dazu Gesprächsgedächtnis und ein Prüfknoten für Zusagen. Übung aus dem Kurs „KI-Automatisierung“, Woche 6 und 7, Oktober und November 2026. Die FAQ-Einträge sind Beispieldaten ohne Zusagen an echte Kunden.

## Stand

**v10 vom 05.11.2026.** Neuer, eigenständiger Workflow `k1-antwort-kette` neben dem Support-Agenten: Stufe 1 entwirft zu einem ausgedachten K1-Ticket eine Antwort, Stufe 2 prüft und verbessert sie gegen FAQ und Wissensbasis über den unveränderten MCP-Server (nur die 2 lesenden Werkzeuge). Der Prompt der Prüfstufe wird als A/B-Test in 2 Varianten verglichen, ein Judge (anderes Modell) bewertet jede Antwort in 4 Dimensionen, 5 Antworten sind zusätzlich von Hand bewertet. 10 Tickets in 3 Läufen ergeben 60 Zeilen in der Tabelle `agt_w07_answer_chain_results`: Entwurf 11,90, Variante A 18,80, Variante B 18,14 (Summe der 4 Dimensionen, 4 bis 20); B ist nicht besser, A bleibt ([Testtabelle v10](docs/testtabelle-w07t04-v10.md), alle 60 Zeilen mit Antwort, Werten, PASS oder FAIL je Lauf, Werkzeugaufrufen, Code-Flags, Dauer und Schattenkosten in [ergebnisse-w07t04-v10.csv](docs/ergebnisse-w07t04-v10.csv)). Der Support-Agent v09 bleibt unverändert.

**v09 vom 04.11.2026.** Die 6 Werkzeuge der beiden Agenten liegen jetzt einmal an einem gemeinsamen MCP-Server (MCP Server Trigger mit Bearer-Anmeldung, eigener Workflow). Jeder Agent hat statt seiner einzelnen Werkzeug-Knoten einen MCP Client und wählt dort seine Auswahl: der Auskunfts-Agent 4 lesende Werkzeuge, der Aktions-Agent die 2 schreibenden. Der Client erreicht den Server über die interne Adresse der Instanz, weil die öffentliche Adresse ihm eine Prüfseite liefert. Der Hauptworkflow bleibt in Logik und Prompt unverändert, nur die Verweise auf die Agenten und die Notizen sind angepasst. Gesamttest 17 Läufe in 7 Fällen, alle bestanden; dazu 5 Nachläufe nach Notizkorrekturen (einer mit Abweichung vom erwarteten Fall, in der Testtabelle benannt), 8 Einzeltests am Server (ohne Token 403) und 10 an den Agenten ([Testtabelle v09](docs/testtabelle-w07t03-v09.md)). Beim Aktions-Agenten ist der Kontext im Fehlerweg leer; ein Beleg mit Ticketnummer entfällt dort, der Hauptworkflow hängt den vorsichtigen Hinweis an. Die Konfiguration im Workflow zählt weiter `v16`, nach außen heißt der Stand v09 ([Versionsmatrix](docs/versionsmatrix.md)).

**v08 vom 03.11.2026.** Übergabefelder und Umgang mit Ausfällen: der Orchestrator übergibt dem Aktions-Agenten feste Felder (`query`, `zustimmung`, neu `prioritaet`), dem Auskunfts-Agenten nur `query`. Fällt ein Agent aus oder antwortet er nicht brauchbar, kommt ein fester Satz; bestätigte Aktionen stehen in einem festen Absatz aus den Belegen. Schlussreihe 9 Läufe, 7 bestanden, 2 nicht bestanden (L1, A1); nach der Änderung für L1 6 Läufe, alle bestanden; Kontrolle am Endstand 6 Läufe, alle bestanden, darunter F4b und der Bonus B1 (Orchestrator einmal mit Max Iterations 1, sonst 5, Agenten 4) mit überarbeiteter Eingabe. In den Testreihen ist der Ticketpfad nicht live gemessen; live belegt ist das Testticket K1-T-01056 aus Lauf 1936. Die Konfiguration im Workflow zählt die Baurunden des Tages intern bis `v16`; die letzte Runde `v17` fasste nur Texte neu und ließ das Feld bei `v16`. Nach außen heißt der Stand v08 ([Versionsmatrix](docs/versionsmatrix.md)).

**v07 vom 02.11.2026.** Der Agent ist in einen Orchestrator und 2 Agenten geteilt: der Auskunfts-Agent hat nur die 4 lesenden Werkzeuge, der Aktions-Agent nur Vormerkung und Eilmeldung. Orchestrierungsmodell hierarchisch, in den Tests nacheinander abgearbeitet.

## Links

- [Wochen-Doku](https://minkeautomation.github.io/k1-support-agent/) mit allen Tagen
- [Tages-Doku Woche 7 Tag 4 (v10)](https://minkeautomation.github.io/k1-support-agent/w07t04.html)
- [Tages-Doku Woche 7 Tag 3 (v09)](https://minkeautomation.github.io/k1-support-agent/w07t03.html)
- [Tages-Doku Woche 7 Tag 2 (v08)](https://minkeautomation.github.io/k1-support-agent/w07t02.html)
- [Tages-Doku Woche 7 Tag 1 (v07)](https://minkeautomation.github.io/k1-support-agent/w07t01.html)
- [ChangeLog](ChangeLog.md)
- [Versionsmatrix](docs/versionsmatrix.md): je Version Plan, Testtabelle, Tages-Doku und Export, Lücken ausdrücklich als „gab es nicht“
- [Einrichten und Nachbauen](workflows/README.md)
- [Ausführliche Fassung des README, Archiv, Stand v05 (nicht auf v07 bis v10 nachgezogen)](docs/readme-ausfuehrlich.md); für v10 und v09 gelten dieses README, [Einrichten und Nachbauen](workflows/README.md) und die Tages-Doku ([v10](https://minkeautomation.github.io/k1-support-agent/w07t04.html), [v09](https://minkeautomation.github.io/k1-support-agent/w07t03.html))

## Versionen

Je Version Plan, Tests, Workflow-Export und Tages-Doku. Ein Strich heißt: für diese Version gibt es das nicht als eigene Datei.

| Version | Datum | Plan | Tests | Workflow | Tages-Doku | Git-Tag |
|---|---|---|---|---|---|---|
| v10 | 05.11.2026 | [Plan v10](docs/plan/plan-w07t04-v10.png) | [Testtabelle v10](docs/testtabelle-w07t04-v10.md) (60 Zeilen aus 10 Tickets, 2 Varianten und 3 Läufen, 5 Antworten von Hand bewertet) | [Export](workflows/k1-antwort-kette_2026-11-05_v10.json) (eigener Workflow Antwort-Kette; der Support-Agent bleibt auf v09) | [Woche 7 Tag 4](https://minkeautomation.github.io/k1-support-agent/w07t04.html) | `v10` |
| v09 | 04.11.2026 | [Plan v09](docs/plan/plan-w07t03-v09.png) | [Testtabelle v09](docs/testtabelle-w07t03-v09.md) (gesamt 17 Läufe, Nachläufe 6, Einzeltests Server 8, Agenten 10) | [Export](workflows/k1-support-agent_2026-11-04_v09.json), [Server](workflows/k1-mcp-server_2026-11-04_v09.json), [Auskunft](workflows/subs/sub-auskunfts-agent-k1.json), [Aktion](workflows/subs/sub-aktions-agent-k1.json) | [Woche 7 Tag 3](https://minkeautomation.github.io/k1-support-agent/w07t03.html) | `v09` |
| v08 | 03.11.2026 | [Plan v08](docs/plan/plan-w07t02-v08.png) | [Testtabelle v08](docs/testtabelle-w07t02-v08.md) (Schlussreihe 9 Läufe, Nachtrag 6, Kontrolle 6) | [Export](workflows/k1-support-agent_2026-11-03_v08.json), Agenten v08 über Tag `v08` | [Woche 7 Tag 2](https://minkeautomation.github.io/k1-support-agent/w07t02.html) | `v08` |
| v07 | 02.11.2026 | [Plan v07](docs/plan/plan-w07t01-v07.png) | [Testtabelle v07](docs/testtabelle-w07t01-v07.md) (10 Testfälle), [Knotentest](docs/knotentest-pruefknoten.md) | [Export](workflows/k1-support-agent_2026-11-02_v07.json), Agenten v07 über Tag `v07` | [Woche 7 Tag 1](https://minkeautomation.github.io/k1-support-agent/w07t01.html) | `v07` |
| v06 | 30.10.2026 | gab es nicht, siehe [Versionsmatrix](docs/versionsmatrix.md) | [Testtabelle v06](docs/testtabelle-w06t05-v06.md) (4 Testfälle), [Knotentest](docs/knotentest-pruefknoten.md) | [Export](workflows/k1-support-agent_2026-10-30_v06.json), [Subs](workflows/subs/) | [Woche 6 Tag 5](https://minkeautomation.github.io/k1-support-agent/w06t05.html) | `v06` |
| v05.1 | 30.10.2026 | gab es nicht, siehe [Versionsmatrix](docs/versionsmatrix.md) | keine eigene Testtabelle, [Knotentest](docs/knotentest-pruefknoten.md) | [Export](workflows/k1-support-agent_2026-10-30_v05.1.json) | [Woche 6 Tag 5](https://minkeautomation.github.io/k1-support-agent/w06t05.html) | `v05.1` |
| v05 | 29.10.2026 | [Plan v05](docs/plan/plan-w06t04-v05.png) | [Testtabelle v05](docs/testtabelle-w06t04-v05.md) | [Export](workflows/k1-support-agent_2026-10-29_v05.json) | [Tag 4](https://minkeautomation.github.io/k1-support-agent/w06t04.html) | `v05` |
| v04 | 28.10.2026 | [Plan v04](docs/plan/plan-w06t03-v04.png) | [Testtabelle v04](docs/testtabelle-w06t03-v04.md), [Testfragen](docs/testfragen-w06t03.md) | [Export](workflows/k1-support-agent_2026-10-28_v04.json) | [Tag 3](https://minkeautomation.github.io/k1-support-agent/w06t03.html) | `v04` |
| v03 | 27.10.2026 | [Plan v03](docs/plan/plan-w06t02-v03.png) | in der Tages-Doku | - | [Tag 2](https://minkeautomation.github.io/k1-support-agent/w06t02.html) | - |
| v02 | 26.10.2026 | [Plan v02](docs/plan/plan-w06t01-v02.png) | in der Tages-Doku | - | [Tag 1](https://minkeautomation.github.io/k1-support-agent/w06t01.html) | - |

## Tests

Zwei Arten, bewusst getrennt benannt:

- **Testfälle** sind Läufe am ganzen Agenten, mit der Chat-Antwort, die die Person bekommt.
- **Knotentest** ist eine Liste von Prüffällen (vorgegebenen Antworttexten) für einen einzelnen Knoten, den Prüfknoten `Werkzeugwahl messen`. Der Prüfknoten ersetzt Zusagen wie „Ticket angelegt“, wenn kein Werkzeug sie belegt. Der Knotentest läuft ohne Modell, nur gegen den Code des Knotens.

| Datei | Version | Was drin steht | Zahl |
|---|---|---|---|
| [docs/testtabelle-w07t04-v10.md](docs/testtabelle-w07t04-v10.md) | v10 | A/B-Test der Prüfstufe: die 10 Tickets im Wortlaut (Variante A, Lauf 1) mit 4 Bewertungsspalten, Mittel je Dimension, Bewertung je Ticket, Fehlerfälle, 5 von Hand bewertete Antworten im Wortlaut, PASS oder FAIL je Lauf; die Antworten aller 60 Zeilen stehen im Wortlaut in [docs/ergebnisse-w07t04-v10.csv](docs/ergebnisse-w07t04-v10.csv), dazu je Zeile Werkzeugaufrufe, Werkzeuge, Code-Flags, Dauer und Schattenkosten | 60 Zeilen (10 Tickets, 2 Varianten, 3 Läufe), davon 58 mit gültiger Wertung |
| [docs/testtabelle-w07t03-v09.md](docs/testtabelle-w07t03-v09.md) | v09 | Gesamttest über den Hauptworkflow mit MCP-Server, Chat-Antwort ungekürzt, Werkzeug aus dem Ausführungsprotokoll; Nachläufe, Einzeltests am Server und an den Agenten in eigenen Tabellen | Gesamttest 17 Läufe, 17 bestanden; Nachläufe 6, alle PASS (N5 mit Abweichung vom Fall E1, siehe Datei); Einzeltests Server 8 und Agenten 10 |
| [docs/testtabelle-w07t02-v08.md](docs/testtabelle-w07t02-v08.md) | v08 | Handoff und Fehlerbehandlung, Chat-Antwort ungekürzt, Messart live oder nur Knotentest je Aussage | Schlussreihe 9 Läufe, 7 bestanden; Nachtrag 6 Läufe, 6 bestanden; Kontrolle am Endstand 6 Läufe, 6 bestanden |
| [docs/testtabelle-w07t01-v07.md](docs/testtabelle-w07t01-v07.md) | v07 | Testfälle Orchestrator mit Agenten, Chat-Antwort ungekürzt, Startzeiten der Unterläufe | Testreihe 10 Testfälle, 10 bestanden; Kontrolle 14 Läufe, 12 bestanden |
| [docs/knotentest-pruefknoten.md](docs/knotentest-pruefknoten.md) | v05.1, v06, v07 | Knotentest Prüfknoten, je Eingabesatz Kennung, Eingabe, Erwartung, Ergebnis | 289 Prüffälle (198 ersetzt, 91 bleiben stehen), 0 Abweichungen |
| [docs/testtabelle-w06t05-v06.md](docs/testtabelle-w06t05-v06.md) | v06 | Testfälle Jev-Weiche und Protokollzeile als Subs, Chat-Antwort dort nicht im Wortlaut festgehalten, Einzeltests der Subs | 4 Testfälle, 4 bestanden |
| [docs/testtabelle-w06t04-v05.md](docs/testtabelle-w06t04-v05.md) | v05 | Vergleich von 3 Prompt-Fassungen und Nachmessung, Antworten dort auf 230 Zeichen gekürzt | siehe Datei |
| [docs/testtabelle-w06t03-v04.md](docs/testtabelle-w06t03-v04.md) | v04 | Werkzeugwahl mit 6 Werkzeugen | siehe Datei |
| [docs/testfragen-w06t03.md](docs/testfragen-w06t03.md) | v04 | die Testfragen von Tag 3 mit Erwartung | siehe Datei |

Alle Rechte vorbehalten. Einsicht und Lernen sind erlaubt.
