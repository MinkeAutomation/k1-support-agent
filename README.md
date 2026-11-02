# K1 Support-Agent

n8n-Agent für Fragen zur Content-Maschine K1: ein Orchestrator verteilt jede Anfrage an 2 Spezialisten (Auskunft, Aktion), davor eine Jev-Weiche, dazu Gesprächsgedächtnis und ein Prüfknoten für Zusagen. Übung aus dem Kurs „KI-Automatisierung“, Woche 6 und 7, Oktober und November 2026. Die FAQ-Einträge sind Beispieldaten ohne Zusagen an echte Kunden.

## Stand

**v07 vom 02.11.2026.** Der Agent ist in einen Orchestrator und 2 Spezialisten geteilt: der Auskunfts-Agent hat nur die 4 lesenden Werkzeuge, der Aktions-Agent nur Vormerkung und Eilmeldung. Orchestrierungsmodell hierarchisch, in den Tests nacheinander abgearbeitet (beobachtet bei vorgegebener Reihenfolge im Prompt, keine technische Grenze von n8n belegt). Testreihe 10 von 10 bestanden; Kontrolle gegen den ausgelieferten Prompt 12 von 14 Läufen (Fehllauf T1 1840, bekannte Schwachstelle T4a 1847 „Ich habe notiert“, Korrektur in der nächsten Version).

## Links

- [Wochen-Doku](https://minkeautomation.github.io/k1-support-agent/) mit allen Tagen
- [Tages-Doku Woche 7 Tag 1 (v07)](https://minkeautomation.github.io/k1-support-agent/w07t01.html)
- [ChangeLog](ChangeLog.md)
- [Einrichten und Nachbauen](workflows/README.md)
- [Ausführliche Fassung des README, Archiv, Stand v05 (nicht auf v07 nachgezogen)](docs/readme-ausfuehrlich.md); für v07 gelten dieses README, [Einrichten und Nachbauen](workflows/README.md) und die [Tages-Doku](https://minkeautomation.github.io/k1-support-agent/w07t01.html)

## Versionen

Je Version Plan, Tests, Workflow-Export und Tages-Doku. Ein Strich heißt: für diese Version gibt es das nicht als eigene Datei.

| Version | Datum | Plan | Tests | Workflow | Tages-Doku | Git-Tag |
|---|---|---|---|---|---|---|
| v07 | 02.11.2026 | [Plan v07](docs/plan/plan-w07t01-v07.png) | [Testtabelle v07](docs/testtabelle-w07t01-v07.md) (10 Testfälle), [Knotentest](docs/knotentest-pruefknoten.md) | [Export](workflows/k1-support-agent_2026-11-02_v07.json), [Auskunft](workflows/subs/sub-auskunfts-agent-k1.json), [Aktion](workflows/subs/sub-aktions-agent-k1.json) | [Woche 7 Tag 1](https://minkeautomation.github.io/k1-support-agent/w07t01.html) | `v07` |
| v06 | 30.10.2026 | - | [Knotentest](docs/knotentest-pruefknoten.md), Läufe im [ChangeLog](ChangeLog.md) | [Export](workflows/k1-support-agent_2026-10-30_v06.json), [Subs](workflows/subs/) | [ChangeLog](ChangeLog.md) | `v06` |
| v05.1 | 30.10.2026 | - | [Knotentest](docs/knotentest-pruefknoten.md) | [Export](workflows/k1-support-agent_2026-10-30_v05.1.json) | [ChangeLog](ChangeLog.md) | `v05.1` |
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
| [docs/testtabelle-w07t01-v07.md](docs/testtabelle-w07t01-v07.md) | v07 | Testfälle Orchestrator mit Spezialisten, Chat-Antwort ungekürzt, Startzeiten der Unterläufe | Testreihe 10 Testfälle, 10 bestanden; Kontrolle 14 Läufe, 12 bestanden |
| [docs/knotentest-pruefknoten.md](docs/knotentest-pruefknoten.md) | v05.1, v06, v07 | Knotentest Prüfknoten, je Eingabesatz Kennung, Eingabe, Erwartung, Ergebnis | 289 Prüffälle (198 ersetzt, 91 bleiben stehen), 0 Abweichungen |
| [docs/testtabelle-w06t04-v05.md](docs/testtabelle-w06t04-v05.md) | v05 | Vergleich von 3 Prompt-Fassungen und Nachmessung, Antworten dort auf 230 Zeichen gekürzt | siehe Datei |
| [docs/testtabelle-w06t03-v04.md](docs/testtabelle-w06t03-v04.md) | v04 | Werkzeugwahl mit 6 Werkzeugen | siehe Datei |
| [docs/testfragen-w06t03.md](docs/testfragen-w06t03.md) | v04 | die Testfragen von Tag 3 mit Erwartung | siehe Datei |

Alle Rechte vorbehalten. Einsicht und Lernen sind erlaubt.
