# Versionsmatrix K1 Support-Agent

Je Workflow-Version steht hier, was es dazu im Repository gibt: Plan, Testtabelle, Tages-Doku und Workflow-Export. Jede Zelle ist entweder ein Link auf eine Datei im Repository oder ein Satz „gab es nicht: <Grund>“. Eine Lücke steht also sichtbar da und wird nicht verschwiegen. Die Datei wird bei jeder neuen Version nachgezogen.

| Version | Datum | Plan | Testtabelle | Tages-Doku | Workflow-Export |
|---|---|---|---|---|---|
| v09 | 04.11.2026 | [Plan v09](plan/plan-w07t03-v09.png) | [Testtabelle v09](testtabelle-w07t03-v09.md) (Gesamttest 17 Läufe, alle bestanden; Nachläufe 5; Einzeltests Server 8, Agenten 10) | [W7 Tag 3](w07t03.html) | [Export v09](../workflows/k1-support-agent_2026-11-04_v09.json), [Server](../workflows/k1-mcp-server_2026-11-04_v09.json), [Auskunft](../workflows/subs/sub-auskunfts-agent-k1.json), [Aktion](../workflows/subs/sub-aktions-agent-k1.json) |
| v08 | 03.11.2026 | [Plan v08](plan/plan-w07t02-v08.png) | [Testtabelle v08](testtabelle-w07t02-v08.md) | [W7 Tag 2](w07t02.html) | [Export v08](../workflows/k1-support-agent_2026-11-03_v08.json) |
| v07 | 02.11.2026 | [Plan v07](plan/plan-w07t01-v07.png) | [Testtabelle v07](testtabelle-w07t01-v07.md) | [W7 Tag 1](w07t01.html) | [Export v07](../workflows/k1-support-agent_2026-11-02_v07.json) |
| v06 | 30.10.2026 | gab es nicht: für v06 wurde kein Plan auf dem Endstand gezeichnet; der Aufbau ist der von Plan v05, nur dass die Jev-Weiche und das Schreiben der Protokollzeile je ein Aufruf eines Sub-Workflows sind (Gesamtansicht v06 in der Tages-Doku) | [Testtabelle v06](testtabelle-w06t05-v06.md) | [W6 Tag 5](w06t05.html) | [Export v06](../workflows/k1-support-agent_2026-10-30_v06.json) |
| v05.1 | 30.10.2026 | gab es nicht: für v05.1 wurde kein Plan auf dem Endstand gezeichnet; v05.1 ändert nur den Prüfknoten, der Aufbau bleibt der von Plan v05 | gab es nicht: für v05.1 gibt es keine eigene Testtabelle, die Tests waren der Knotentest (Einzelliste [knotentest-pruefknoten.md](knotentest-pruefknoten.md)) und Läufe im ChangeLog | [W6 Tag 5](w06t05.html) | [Export v05.1](../workflows/k1-support-agent_2026-10-30_v05.1.json) |
| v05 | 29.10.2026 | [Plan v05](plan/plan-w06t04-v05.png) | [Testtabelle v05](testtabelle-w06t04-v05.md), Antworten in dieser Tabelle auf 230 Zeichen gekürzt (Altbestand) | [W6 Tag 4](w06t04.html) | [Export v05](../workflows/k1-support-agent_2026-10-29_v05.json) |
| v04 | 28.10.2026 | [Plan v04](plan/plan-w06t03-v04.png) | [Testtabelle v04](testtabelle-w06t03-v04.md), Spalte „Ergebnis“ dort gekürzt (Altbestand) | [W6 Tag 3](w06t03.html) | [Export v04](../workflows/k1-support-agent_2026-10-28_v04.json) |
| v03 | 27.10.2026 | [Plan v03](plan/plan-w06t02-v03.png) | gab es nicht: die Tests von v03 stehen nur in der Tages-Doku von Tag 2, nicht als eigene Datei | [W6 Tag 2](w06t02.html) | gab es nicht: der Export von v03 wurde nicht in das Repository gelegt, die Exporte beginnen mit v04 |
| v02 | 26.10.2026 | [Plan v02](plan/plan-w06t01-v02.png) | gab es nicht: die Tests von v02 stehen nur in der Tages-Doku von Tag 1, nicht als eigene Datei | [W6 Tag 1](w06t01.html) | gab es nicht: der Export von v02 wurde nicht in das Repository gelegt, die Exporte beginnen mit v04 |

**Baurunden innerhalb von v08.** Der Stand v08 entstand am 03.11.2026 in mehreren Baurunden. Die Konfiguration im Workflow (`workflow_version`) zählt diese Runden intern weiter, von `v08` bis `v16`; im Export steht deshalb `v16`. Die letzte Runde `v17` änderte nur Texte (Prompts, Ausfallsatz, Notizen, Kommentare) und eine Knotenposition, nicht die Logik, und ließ das Feld bei `v16`. Die Zwischenstände sind keine eigenen Versionen: sie wurden nicht exportiert, nicht getaggt und nicht einzeln dokumentiert. Plan, Testtabelle, Tages-Doku und Export gelten für den Endstand.

| Konfiguration im Workflow | gehört zu Version | Plan, Testtabelle, Tages-Doku, Export |
|---|---|---|
| `v08` bis `v16`, dazu die Textrunde `v17` ohne eigenen Feldwert (Baurunden am 03.11.2026) | v08 | nur für den Endstand nach `v17` (Feld `v16`), siehe Zeile v08 oben; die Änderungen je Runde stehen im [ChangeLog](../ChangeLog.md), Abschnitt v08, Tabelle „Baurunden innerhalb von v08“ |

**Agenten-Exporte.** Unter `workflows/subs/` liegt immer der jüngste Stand der Agenten (jetzt v09). Die Agenten von v08 und v07 sind über die Git-Tags `v08` und `v07` abrufbar.

Die Testtabellen von v09, v08 und v07 enthalten die Chat-Antworten im Wortlaut, die von v06 nennt ausdrücklich, dass der Wortlaut nicht übernommen wurde. In den Testtabellen von v05 (Antworten auf 230 Zeichen) und v04 (Spalte „Ergebnis“) sind die Antworten gekürzt; der vollständige Wortlaut liegt dort nur in den Protokollzeilen der Datenbank und wurde nicht nachgetragen.
