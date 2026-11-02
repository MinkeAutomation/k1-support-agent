# Testtabelle W06T05, Workflow v06 (Jev-Weiche und Protokollzeile als Sub-Workflows)

Gelaufen am 30.10.2026, nacheinander, über den Chat-Eingang des Workflows v06. Gratismodelle und Werkzeuge liefen echt. Es entstand keine Testmail, kein Stop and Error und keine Eilmeldung. Die Testkennung steht in der Eingabe in eckigen Klammern (`[V06-Q03|s=...]`), `s=` setzt die Sitzung. Die Vergleichszeile aus v05 ist Zeile 455 der Tabelle `agt_w06_support_log` (Testkennung RG-Q03, siehe [testtabelle-w06t04-v05.md](testtabelle-w06t04-v05.md)).

**Begriffe:** „Testfall“ heißt hier nur ein Lauf am ganzen Agenten. Der Prüfknoten hat einen eigenen Knotentest mit 289 Eingabesätzen: [knotentest-pruefknoten.md](knotentest-pruefknoten.md). Die Einzeltests der beiden Subs stehen unten und im [ChangeLog](../ChangeLog.md), Abschnitt v06.

**Was v06 ändert:** v06 ändert gegenüber v05.1 nur, wie die Jev-Weiche und die Protokollzeile angeschlossen sind: jeweils ein Aufruf eines eigenen Sub-Workflows statt der bisherigen Knoten. Prüfknoten, Prompts und Werkzeuge sind unverändert. Getestet wurde deshalb, ob Weg, Werkzeug, Jev-Werte und Protokollzeile gleich bleiben und ob ein Ausfall der Weiche oder des Protokolls die Antwort an die Person aufhält.

**Ergebnis: 4 von 4 Testfällen bestanden.**

## Übersicht

| Fall | Eingabe | Erwartung | Tatsächlich | Antwort an die Person | Läufe (Hauptlauf, Unterläufe) | Ergebnis |
|---|---|---|---|---|---|---|
| Q03 mit Spaltenvergleich (J8a, L8) | `[V06-Q03\|s=v06j8] Wie lange wartet K1 auf meine Freigabe?` | Weg agent, Werkzeug K1_Antwortkatalog, Jev wie in v05, 1 Protokollzeile | Weg agent, Werkzeug K1_Antwortkatalog, Jev-Wert 0,99 (Anliegen auftragsstatus 0,76), 1 Versuch, Kosten 0,000033474 USD, Protokollzeile 559 | Wortlaut in dieser Tabelle nicht festgehalten; im Protokoll steht eine inhaltlich gleiche Antwort wie in v05, im Wortlaut kürzer | 1767; Jev-Sub 1768, Protokoll-Sub 1769; Spaltenvergleich Lauf 1781 | PASS |
| J8b | `[V06-J8b\|s=v06j8] Und wie lange dauert das danach?` | Weg folgefrage, Jev-Werte aus dem Sub, 1 Protokollzeile | Weg folgefrage, kein Werkzeug, Jev-Wert 0,98 (Anliegen faq 0,18), Protokollzeile 560 | Wortlaut in dieser Tabelle nicht festgehalten | 1770; 1771, 1772 | PASS |
| J9 (Jev fällt aus) | `[V06-J9\|s=v06j9\|stoer=jevaus] Wie lange wartet K1 auf meine Freigabe?` | Der Sub liefert `fallback` (HTTP 500, 1 Versuch), die Weiche nimmt den Zweig „Kein Jev-Wert“, der Agent antwortet ohne Weiche | Weg ohne_jev, Werkzeug K1_Antwortkatalog, Status fallback, `jev_attempts` 1, Jev-Werte leer, Protokollzeile 561 | Wortlaut in dieser Tabelle nicht festgehalten; die Antwort kam, der Agent nutzte K1_Antwortkatalog | 1773; 1774, 1775 | PASS (der Zweig war bis dahin ungetestet) |
| L9 (Protokollfehler erzwungen) | `[V06-L9\|s=v06l9\|stoer=logfehler] Wie lange wartet K1 auf meine Freigabe?` | Der Sub blockiert die nicht erlaubte Tabelle, `Protokollfehler vermerken` läuft, die Antwort kommt an, es entsteht keine Zeile | Sub-Rückgabe `error` mit „Tabelle nicht erlaubt: auth.users“, `protokoll_status` error, Antwort vollständig, keine Zeile mit `V06-L9` in der Tabelle | Wortlaut in dieser Tabelle nicht festgehalten; die Antwort war vollständig | 1776; 1777, 1779 | PASS |

Die Nummern sind Ausführungsnummern in n8n. Die Antwort an die Person ist an diesem Tag nicht im Wortlaut in die Tabelle übernommen worden, belegt sind Weg, Werkzeug, Jev-Werte und die Protokollzeile. Das Feld `antwort_test` der Protokollzeilen enthält die Modellantwort des jeweiligen Laufs.

## Spaltenvergleich der Protokollzeile (Lauf 1781)

`SELECT *` auf die Zeilen 455 (v05) und 559 (v06), derselbe Eingabesatz: alle 27 Spalten sind vorhanden und gleich (Jev-Werte, Kosten, Werkzeug, `tool_reason`, Modell, Gedächtnis, Tokens leer, Status) bis auf `id`, Zeit, `execution_id`, `workflow_name`, `workflow_version` (v06), `test_id`, `session_id`, `duration_ms` (7551 ms gegen 17464 ms) und `antwort_test` (die Modellantwort ist je Lauf etwas anders, hier kürzer). Ergebnis: PASS.

## Zeilen in der Protokolltabelle nach den Läufen

Abfrage über die Läufe 1778 und 1780: Zeile 559 (V06-Q03, Weg agent), Zeile 560 (V06-J8b, Weg folgefrage), Zeile 561 (V06-J9, Weg ohne_jev, Status fallback) und keine Zeile für V06-L9.

## Einzeltests der beiden Subs (vor dem Einbau in v06)

| Sub | Hauptlauf | Unterläufe | Ergebnis |
|---|---|---|---|
| SUB Protokollzeile schreiben | 1735 | 1736 bis 1743 | 7 erwartete PASS und 1 beabsichtigter FAIL (nicht erlaubte Tabelle) |
| SUB Jev-Weiche mit Retry | 1747 | 1748 bis 1753 und 1755 | 6 erwartete PASS und 1 beabsichtigter FAIL (leere Frage); die Nummer 1754 ist kein Unterlauf, sondern der Lauf des Fehler-Workflows, den der Stop and Error im Fall mit leerer Frage auslöste |

## Knotentest des Prüfknotens

| Angabe | Wert |
|---|---|
| Aufruf | `node pruefknoten-test.js <Code aus v06>` |
| Ergebnis | 289 Prüffälle, 0 Abweichungen, exit 0 |
| Code des Knotens | SHA256 `84162f71417ec67ef6717d9298727e2518e355335c0352cdcb778d02b344513f`, in v06 und im Export von v05.1 gleich |
| Einzelliste | [knotentest-pruefknoten.md](knotentest-pruefknoten.md) |

## Nicht gemessen

Die Wege fremd, rueckfrage, limit und ausfall laufen ebenfalls durch den neuen Aufruf `Protokollzeile aufrufen` und das neue `Protokoll geschrieben?`, sind in v06 aber nicht gemessen. Bei fremd und rueckfrage läuft zusätzlich `Dialog sichern` parallel; dass die Chat-Antwort dort weiter aus `Antwort an Kunden` kommt, ist für v06 nicht belegt. Die Subs waren nicht veröffentlicht und liefen aus manuell gestarteten Testläufen; der Betrieb aus einem veröffentlichten Aufrufer ist nicht gemessen.
