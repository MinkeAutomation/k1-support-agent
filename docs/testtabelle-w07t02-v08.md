# Testtabelle v08 (Woche 7 Tag 2, 03.11.2026)

Testläufe am ganzen Agenten für v08: welche Felder der Orchestrator den Spezialisten mitgibt und was geschieht, wenn einer von ihnen ausfällt. Alle Chat-Antworten stehen vollständig im Wortlaut. Ein FAIL bleibt FAIL.

## Stand und Einstellungen

| Feld | Wert |
|---|---|
| Workflow | v08, Export [k1-support-agent_2026-11-03_v08.json](../workflows/k1-support-agent_2026-11-03_v08.json); die Konfiguration zählt die Baurunden innerhalb von v08 intern weiter (Schlussreihe am Stand `v15`, Nachtrag am Stand `v16`, Kontrolle am Endstand nach der Textrunde `v17`, in der das Feld `workflow_version` bei `v16` blieb, siehe [ChangeLog](../ChangeLog.md)) |
| Prompt-Versionen | Orchestrator `w07t02-o3`, Aktions-Agent `w07t02-x2`, Auskunfts-Agent `w07t01-a1` |
| Spezialisten | [SUB Auskunfts-Agent K1](../workflows/subs/sub-auskunfts-agent-k1.json) `sub-auskunft-v2`, [SUB Aktions-Agent K1](../workflows/subs/sub-aktions-agent-k1.json) `sub-aktion-v6` |
| Wissensquellen | FAQ `faq/k1-faq.csv`, Wissensbasis Stand 30.09.2026 |
| Modell | `nvidia/nemotron-3-ultra-550b-a55b:free`, Ausweichmodell `nvidia/nemotron-3.5-super-vl:free` (OpenRouter, Gratismodelle) |
| Max Iterations | Orchestrator 5, beide Spezialisten 4 |
| Gedächtnis | Postgres Chat Memory, Fenster 10, Tabelle `agt_w06_chat_histories`, Schlüssel `session_id` |
| Ausgangsverlauf | jeder Fall in einer neuen, leeren Sitzung; nur L3b läuft in der Sitzung von L3a weiter |
| Modus | Chat-Eingang im Editor (manuell), Orchestrator nicht veröffentlicht, Spezialisten veröffentlicht |

**Messart.** „live“ heißt: ein echter Lauf am ganzen Agenten oder am einzelnen Spezialisten, gelesen aus dem Ausführungsprotokoll (Spalten `tools_called`, `action`, `status` der Protokollzeile). „Knotentest“ heißt: ein einzelner Code-Knoten bekommt vorgegebene Eingaben, ohne Modell und ohne Lauf.

**Der Ticketpfad ist nicht live gemessen.** Für die ganze Reihe zeigte das Werkzeug `Teamvormerkung` absichtlich auf eine nicht vorhandene Datenbankfunktion, damit kein weiteres echtes Ticket entsteht; danach wurde es zurückgesetzt (im Export nachgemessen). Ein Vormerkaufruf liefert deshalb in dieser Reihe einen technischen Fehler und nie eine Ticketnummer. Dass der Workflow bei einer bestätigten Vormerkung die Ticketnummer im festen Absatz nennt, ist nur im Knotentest belegt.

**Testticket K1-T-01056.** Beim Bau entstand in einem Einzellauf des Aktions-Spezialisten (Lauf 1936, eine Vormerkung mit der zu kurzen Nummer 123 im Text) ein echtes Ticket K1-T-01056, weil das Modell die Nummer diesmal nicht an das Werkzeug gab. Es ist ein Testticket und bleibt stehen.

**Mails.** In der Schlussreihe gingen genau 3 Eilmeldungen an die feste Test-Adresse (L2, F4b und B1), im Nachtrag 1 weitere (L2 Kontrolle), in der Kontrolle am Endstand 1 weitere (L2, Lauf 2050). Keine Mail an echte Empfänger.

**Zahlen getrennt.** Schlussreihe 11 Läufe: 9 PASS, 2 FAIL (L1, A1). Nachtrag 6 Läufe: 6 PASS. Kontrolle am Endstand 5 Läufe: 5 PASS. Die beiden FAIL der Schlussreihe bleiben FAIL; die späteren Läufe heben sie nicht auf.

## Schlussreihe am Endstand (11 Läufe)

Erwartung vor dem Lauf in der Spalte „Soll“. Zeilenumbrüche der Antworten stehen als `<br>`, der ungekürzte Wortlaut folgt unter der Tabelle. Das Zeichen in F4b Punkt 3 ist ein Gedankenstrich aus der Modellantwort und steht als `&ndash;`.

| Nr | Eingabe | Soll (vor dem Lauf) | Lauf | Handoff an den Spezialisten | Werkzeuge aus dem Protokoll | Schlussantwort (Wortlaut) | Ergebnis | Messart |
|---|---|---|---|---|---|---|---|---|
| L1 | Wie lange wartet K1 auf meine Freigabe? | Auskunfts_Agent, K1_Antwortkatalog, Antwort zur Freigabe | 1990 | keiner (kein Spezialist gerufen) | keine, `agents_called` leer, Weg agent, status ok | Du schreibst mit dem KI-Assistenten von K1. | **FAIL** | live |
| L2 | Bei uns im Studio brennt es, jemand ist verletzt. | Aktions_Agent, prioritaet hoch, Eilmeldung, „Das K1-Team wurde informiert.“ | 1992 (Aktion 2000) | zustimmung nein, prioritaet hoch | Eilmeldung_ans_Team, action eskalation:gesendet, status ok, 1 Mail angenommen | Du schreibst mit dem KI-Assistenten von K1.<br>Das K1-Team wurde informiert.<br><br>Bestätigt: Eilmeldung gesendet. | PASS | live |
| L3a | Das Logo im Paket zu Auftrag 123 ist verpixelt. | kein Werkzeug, Rückfrage zur Vormerkung | 1995 | keiner | keine, status ok | Du schreibst mit dem KI-Assistenten von K1. Soll ich das Problem mit dem verpixelten Logo bei Auftrag 123 als Qualitätsmangel vormerken? | PASS | live |
| L3b | Ja, bitte vormerken. (Sitzung von L3a) | Aktions_Agent, prioritaet normal, zustimmung ja, Teamvormerkung | 2004 (Aktion 2008) | zustimmung ja (nicht gesperrt), prioritaet normal | Teamvormerkung (Werkzeug absichtlich ohne Ziel, technischer Fehler), action leer, status tool_error | Das hat gerade nicht geklappt. Bitte wende dich an das K1-Team über den Kanal, über den du Aufträge schickst.<br><br>Bestätigt: nichts. Offen: Vormerkung nicht bestätigt, Ausgang unbekannt. | PASS mit Grenze: Felder und Aufruf stimmen; der Ausgang bleibt unbekannt und der Absatz sagt es offen | live (Handoff), Ticket nicht |
| S1 | Aktions-Spezialist einzeln: query leer, zustimmung nein, prioritaet leer | EINGABE_FEHLT, prioritaet wird normal, kein Agent | 2013 | query leer, prioritaet wird normal | keine, `aktion_stand` keine, `werkzeuge` leer | Rückgabe des Spezialisten: status error, `antwort` EINGABE_FEHLT, `fehler_text` EINGABE_FEHLT | PASS | live (Spezialist einzeln) |
| S2 | Aktions-Spezialist einzeln: „Das Logo im Paket zu Auftrag 123 ist verpixelt, bitte vormerken.“, zustimmung ja, prioritaet leer | prioritaet normal, Vormerkung nur mit Zustimmung | 2014 | zustimmung ja (nicht gesperrt), prioritaet wird normal | Teamvormerkung (Werkzeug ohne Ziel, Antwort 404) | Rückgabe des Spezialisten: status ok, `antwort`: Die Vormerkung konnte nicht angelegt werden, der Dienst ist momentan nicht erreichbar. Das K1-Team ist über den Auftragskanal erreichbar. | PASS mit Grenze: Felder stimmen; der Modelltext sagt „konnte nicht angelegt werden“, das ist mehr, als der Beleg trägt (im Hauptweg steht dafür „Ausgang unbekannt“) | live (Spezialist einzeln) |
| A1 | Aktions-Spezialist einzeln, Max Iterations 1 (danach zurück auf 4), Eingabe wie S2, Fehler nach dem Werkzeugaufruf | `aktion_stand` belegt, Belege der Aktion in `werkzeuge` | 2015 | wie S2 | Teamvormerkung lief, danach Abbruch „Max iterations (1) reached“ im Fehlerausgang | Rückgabe des Spezialisten: status error, `antwort` SPEZIALIST_AUSGEFALLEN, `fehler_text` Max iterations (1) reached. The agent could not complete the task within the allowed number of iterations., `aktion_stand` werkzeug_lief | **FAIL (Teil)** | live (Spezialist einzeln) |
| F1 | wie L1, Auskunfts-Spezialist vorher unveröffentlicht, danach wieder veröffentlicht | fester Ausfallsatz, kein Absturz | 2016 | query (Sub-Workflow unveröffentlicht, Aufruf scheitert) | Auskunfts_Agent 2 Aufrufe, Ausfallpfad, status tool_error | Du schreibst mit dem KI-Assistenten von K1. Das hat gerade nicht geklappt. Bitte wende dich an das K1-Team über den Kanal, über den du Aufträge schickst. | PASS | live |
| F3 | Wo ist mein Auftrag 99999? | Auskunft, nichts erfunden | 1997 | query | Auftragsstand (Auskunfts_Agent), status ok | Du schreibst mit dem KI-Assistenten von K1. Zu Auftrag 99999 gibt es in unserem System keinen Eintrag. Bitte prüfe die fünfstellige Nummer noch einmal. Wenn du eine andere Nummer hast, nenne sie mir gerne. Das K1-Team hilft dir sonst über den gewohnten Auftragskanal weiter. | PASS | live |
| F4b | lange Mehrfachanfrage zu K1: Auftrag 24003, 7 Fragen, Wunsch nach dem Team, mit einer fiktiven Beispiel-Mailadresse | beide Spezialisten, Eilmeldung, 7 Fragen beantwortet | 2006 (Aktion 2011) | Auskunft: query mit den 7 Fragen; Aktion: query, prioritaet hoch | K1_Antwortkatalog, Auftragsstand, Feiertage_nachschlagen, K1_Technikwissen, Eilmeldung_ans_Team, action eskalation:gesendet, status ok, 1 Mail | Du schreibst mit dem KI-Assistenten von K1.<br><br>Zu deinen Fragen:<br>1. Die Freigabe wartet 24 Stunden auf deine Entscheidung.<br>2. Deine fertigen Dateien findest du nach der Freigabe in deinem Nextcloud-Kundenordner, dessen Link du mit dem Paket erhältst.<br>3. Auftrag 24002 (Social-Media-Paket, 3 Beiträge) ist in Erstellung &ndash; Recherche und Texte laufen, die Vorschau war für den 28.10.2026 geplant.<br>4. Am 25.12.2026 (Erster Weihnachtstag, bundesweiter Feiertag) arbeitet das K1-Team nicht.<br>5. Dein Auftrag wird durch KI-Dienste (Perplexity Sonar, OpenRouter), Jina Reader für Artikel, Supadata für Videos, Pixabay für Fotos und Nextcloud zur Ablage verarbeitet.<br>6. K1 ist eine Kursübung, daher gibt es keine Preise pro Paket.<br>7. Aufträge per Sprachnachricht sind per Telegram möglich, wobei du deinen Kundennamen besser als Text nennst.<br><br>Zu deinem dringenden Problem bei Auftrag 24003 (verpixeltes Logo, falsche Farben, benötigt bis Freitag): Das K1-Team wurde informiert.<br><br>Bestätigt: Eilmeldung gesendet. | PASS | live |
| B1 | wie F4b, Orchestrator Max Iterations 1 (danach zurück auf 5) | Abbruch, fester Ausfallweg, kein Absturz | 2019 (Aktion 2021) | Aktion lief | `tool_called` true, `tool_calls_count` leer (unbekannt), `tools_called` Aktions_Agent, action leer, Weg ausfall, status error | Du schreibst mit dem KI-Assistenten von K1. Der Support-Assistent ist gerade nicht erreichbar. Bitte versuch es später noch einmal oder wende dich an das K1-Team. Ein Teil des Vorgangs kann schon ausgeführt worden sein. | PASS mit Beobachtung: Der Aktions-Spezialist sendete in diesem Lauf 1 Mail (Lauf 2021, angenommen); die Antwort deutet sie nur allgemein an, `action` bleibt leer | live |

Zusammen: 11 Läufe, 9 PASS (3 davon mit Grenze oder Beobachtung), 2 FAIL (L1, A1).

### Die beiden FAIL

**L1, Lauf 1990.** Der Orchestrator rief keinen Spezialisten und gab nur den KI-Hinweis aus („Du schreibst mit dem KI-Assistenten von K1.“, kein Werkzeugaufruf angefordert). Ursache: Der Knoten `Zwischenschritte auspacken [Code]` wertete eine Antwort nur dann als leer, wenn sie gar keinen Text hatte; der KI-Hinweis allein galt als Antwort, und die Regel für Sachaussagen ohne Spezialist greift nur bei einer neuen Zahl oder einem Sachwort. Die Lücke bestand seit dem ersten Bau von v08. Was danach geschah: Der Knoten wertet jetzt eine Antwort, die nach Abzug des KI-Hinweises leer ist, als leer; ohne Aktion folgt der feste Ausfallsatz. Danach 6 weitere Läufe, alle PASS (Tabelle unten). Die Reparatur selbst wurde live nicht ausgelöst, weil der Fall „nur KI-Hinweis“ nicht wieder auftrat; sie ist nur im Knotentest belegt.

**A1, Lauf 2015.** `aktion_stand` stimmt (`werkzeug_lief`), aber `werkzeuge` bleibt leer. Der Fehlerausgang eines KI-Agenten in n8n liefert keine Zwischenschritte, und die Werkzeugknoten geben dort keine Daten her; das Werkzeug lieferte in dieser Reihe dazu nur eine 404-Antwort ohne `status`. Was danach geschah: nichts repariert. Dass eine belegte Ablehnung im Fehlerweg weitergereicht wird, ist nur im Knotentest belegt. Im Hauptweg sagt der Absatz in solchen Fällen „Ausgang unbekannt“.

## Nachtrag nach der Reparatur von L1 (6 Läufe)

Stand nach der Änderung am Knoten `Zwischenschritte auspacken [Code]`. Je Fall eine neue Sitzung.

| Nr | Eingabe | Soll (vor dem Lauf) | Lauf | Werkzeuge aus dem Protokoll | Schlussantwort (Wortlaut) | Ergebnis | Messart |
|---|---|---|---|---|---|---|---|
| L1a | Wie lange wartet K1 auf meine Freigabe? | Auskunfts_Agent, K1_Antwortkatalog | 2023 | K1_Antwortkatalog (Auskunfts_Agent), status ok | Du schreibst mit dem KI-Assistenten von K1. Die Freigabe wartet 24 Stunden auf deine Entscheidung; was danach mit einem nicht freigegebenen Paket passiert, klärt der Support persönlich mit dir. | PASS | live |
| L1b | wie L1a | wie L1a | 2025 | K1_Antwortkatalog (Auskunfts_Agent), status ok | Du schreibst mit dem KI-Assistenten von K1. Die Freigabe wartet 24 Stunden auf deine Entscheidung. Was danach mit einem nicht freigegebenen Paket passiert, klärt der Support persönlich mit dir. | PASS | live |
| L1c | wie L1a | wie L1a | 2027 | K1_Antwortkatalog (Auskunfts_Agent), status ok | Du schreibst mit dem KI-Assistenten von K1. Die Freigabe wartet 24 Stunden auf deine Entscheidung. Was danach mit einem nicht freigegebenen Paket passiert, klärt der Support persönlich mit dir. | PASS | live |
| K4 | Wo finde ich meine fertigen Dateien? | Auskunfts_Agent, K1_Antwortkatalog | 2029 | K1_Antwortkatalog (Auskunfts_Agent), status ok | Du schreibst mit dem KI-Assistenten von K1. Nach der Freigabe legt K1 die Bilder und Texte in deinem Kundenordner in einer Nextcloud ab. Den Link zu diesem Ordner erhältst du zusammen mit dem fertigen Paket. | PASS | live |
| L2 (Kontrolle) | Bei uns im Studio brennt es, jemand ist verletzt. | Aktions_Agent, prioritaet hoch, Eilmeldung | 2039 | Eilmeldung_ans_Team, action eskalation:gesendet, status ok, 1 Mail | Du schreibst mit dem KI-Assistenten von K1. Das K1-Team wurde informiert.<br><br>Bestätigt: Eilmeldung gesendet. | PASS | live |
| F3 (Kontrolle) | Wo ist mein Auftrag 99999? | Auskunft, nichts erfunden | 2041 | Auftragsstand, status ok | Du schreibst mit dem KI-Assistenten von K1. Zu Auftrag 99999 liegt in unserem System kein Eintrag vor. Bitte prüfe die fünfstellige Nummer noch einmal. Wenn du eine andere Nummer hast, nenne sie mir gerne. Das K1-Team kann über den gewohnten Auftragskanal weiterhelfen, falls die Nummer dort anders lautet. | PASS | live |

Zusammen: 6 Läufe, 6 PASS. Für die Eingabe L1 am Endstand: 3 von 4 Läufen mit Spezialist (1990 FAIL, 2023, 2025, 2027). Das ist eine kleine Stichprobe und keine belastbare Quote. Der Orchestrator ruft bei einfachen Fragen nicht in jedem Lauf den Spezialisten; die Antwort darauf ist jetzt der feste Ausfallsatz, kein zweiter Versuch.

## Kontrolle Endstand (5 Läufe)

Stand nach der letzten Textrunde: Die Rollen-Abschnitte der 3 Prompts, der feste Ausfallsatz, einige Notizen, die Beschreibung des Orchestrators und Code-Kommentare wurden sachlich neu gefasst; die Logik blieb gleich, und `Belege aus Kontext [Code]` im Aktions-Spezialisten liegt etwas höher. Diese 5 Läufe laufen auf genau dem Stand der Exporte. **Werkzeug ohne Ziel:** `Teamvormerkung` im Aktions-Spezialisten zeigte für die Läufe auf eine nicht vorhandene Datenbankfunktion und ist danach zurückgesetzt, der Aktions-Spezialist neu veröffentlicht. **Mails:** genau 1 an die feste Testadresse (L2), kein Ticket. Die Zeilen der Tabellen oben bleiben unverändert stehen; sie zitieren teils den Wortlaut vor dieser Runde, etwa die frühere Fassung des festen Ausfallsatzes in B1 (Lauf 2019). Heute heißt er „Der Support-Assistent antwortet im Moment nicht.“

| Nr | Eingabe | Ausführung | Werkzeuge aus dem Protokoll | Schlussantwort (Wortlaut) | Ergebnis |
|---|---|---|---|---|---|
| L1 | Wie lange wartet K1 auf meine Freigabe? | 2047 | K1_Antwortkatalog (Auskunfts_Agent), status ok | Du schreibst mit dem KI-Assistenten von K1. Die Freigabe wartet 24 Stunden auf deine Entscheidung. Was danach mit einem nicht freigegebenen Paket passiert, klärt der Support persönlich mit dir. | PASS |
| L2 | Bei uns im Studio brennt es, jemand ist verletzt. | 2050 | Eilmeldung_ans_Team, action eskalation:gesendet, status ok, 1 Mail | Du schreibst mit dem KI-Assistenten von K1. Das K1-Team wurde informiert.<br><br>Bestätigt: Eilmeldung gesendet. | PASS, 1 Mail |
| L3a | Das Logo im Paket zu Auftrag 123 ist verpixelt. | 2052 | keine, status ok | Du schreibst mit dem KI-Assistenten von K1. Soll ich das Problem mit dem verpixelten Logo bei Auftrag 123 als Qualitätsproblem vormerken? | PASS |
| L3b | Ja, bitte vormerken. (gleiche Sitzung wie L3a) | 2057 | Teamvormerkung (ohne Ziel, 404), action leer, status tool_error | Das hat gerade nicht geklappt. Bitte wende dich an das K1-Team über den Kanal, über den du Aufträge schickst.<br><br>Bestätigt: nichts. Offen: Vormerkung nicht bestätigt, Ausgang unbekannt. | PASS mit Grenze wie im Lauf 2004: Aufruf stimmt (Aktions_Agent gerufen), das Werkzeug ohne Ziel liefert keinen Beleg, der Absatz sagt Offen |
| B1 | lange Mehrfachanfrage zu K1 (Auftrag 24003, 7 Fragen, Teamwunsch, mit einer fiktiven Beispiel-Mailadresse), Orchestrator Max Iterations 1 (danach 5) | 2062 | `tool_called` true, `tool_calls_count` leer (unbekannt), `tools_called` Auskunfts_Agent, action leer, route ausfall, status error | Du schreibst mit dem KI-Assistenten von K1. Der Support-Assistent antwortet im Moment nicht. Bitte versuch es später noch einmal oder wende dich an das K1-Team. | PASS mit Beobachtung: Abbruch gemessen, fester Ausfallweg mit dem neuen Wortlaut, kein Absturz. Diesmal lief nur der Auskunfts_Agent, deshalb steht der Zusatz „Ein Teil des Vorgangs kann schon ausgeführt worden sein.“ nicht dabei (er gilt nur, wenn der Aktions_Agent lief); kein Mailversand |

Zusammen: 5 Läufe, 5 PASS (2 davon mit Grenze oder Beobachtung). Für die Eingabe L1 damit 4 von 5 Läufen mit Spezialist (1990 FAIL, 2023, 2025, 2027, 2047).

**Rückbau (im Export nachgemessen):** `max_iterations` im Hauptworkflow wieder 5, `Teamvormerkung` wieder `…/rpc/agt_w06_vormerkung_anlegen`, Aktions-Spezialist veröffentlicht, Auskunfts-Spezialist veröffentlicht, Hauptworkflow nicht veröffentlicht. Gegenüber dem Stand davor sind in den Exporten nur die Knoten mit neu gefassten Texten und die Position von `Belege aus Kontext [Code]` geändert.

## Was nur im Knotentest belegt ist

Diese Aussagen sind nicht live gemessen, weil sie ein echtes Ticket oder einen Fehler zu einem bestimmten Zeitpunkt bräuchten:

- Bestätigte Vormerkung mit Ticketnummer im festen Absatz („Bestätigt: Vormerkung K1-T-…“), auch zusammen mit einer Eilmeldung.
- Teilaktion im Fehlerweg: eine Vormerkung steht, danach fällt der Spezialist aus.
- Unbekannter Ausgang (Zeitüberschreitung, leere oder unlesbare Rückgabe) steht unter „Offen“, nicht unter „Nicht geklappt“.
- Eine Antwort aus nur dem KI-Hinweis geht in den festen Ausfallsatz (Reparatur nach L1).
- Schreibzusagen ohne Werkzeugaufruf wie „Ich habe notiert, dass die Farben im Paket nicht stimmen.“ ersetzt der Prüfknoten.

Die Testskripte der Knotentests liegen nicht in diesem Repository. Sie liefen vor der Abgabe mit 0 unerwarteten Abweichungen.

## Schlussantworten im Wortlaut (ungekürzt)

**L1 (1990):**

```
Du schreibst mit dem KI-Assistenten von K1.
```

**L2 (1992):**

```
Du schreibst mit dem KI-Assistenten von K1.
Das K1-Team wurde informiert.

Bestätigt: Eilmeldung gesendet.
```

**L3a (1995):**

```
Du schreibst mit dem KI-Assistenten von K1. Soll ich das Problem mit dem verpixelten Logo bei Auftrag 123 als Qualitätsmangel vormerken?
```

**L3b (2004):**

```
Das hat gerade nicht geklappt. Bitte wende dich an das K1-Team über den Kanal, über den du Aufträge schickst.

Bestätigt: nichts. Offen: Vormerkung nicht bestätigt, Ausgang unbekannt.
```

**F1 (2016):**

```
Du schreibst mit dem KI-Assistenten von K1. Das hat gerade nicht geklappt. Bitte wende dich an das K1-Team über den Kanal, über den du Aufträge schickst.
```

**F3 (1997):**

```
Du schreibst mit dem KI-Assistenten von K1. Zu Auftrag 99999 gibt es in unserem System keinen Eintrag. Bitte prüfe die fünfstellige Nummer noch einmal. Wenn du eine andere Nummer hast, nenne sie mir gerne. Das K1-Team hilft dir sonst über den gewohnten Auftragskanal weiter.
```

**F4b (2006)** (das Zeichen in Punkt 3 ist im Original U+2013):

```
Du schreibst mit dem KI-Assistenten von K1.

Zu deinen Fragen:
1. Die Freigabe wartet 24 Stunden auf deine Entscheidung.
2. Deine fertigen Dateien findest du nach der Freigabe in deinem Nextcloud-Kundenordner, dessen Link du mit dem Paket erhältst.
3. Auftrag 24002 (Social-Media-Paket, 3 Beiträge) ist in Erstellung [U+2013] Recherche und Texte laufen, die Vorschau war für den 28.10.2026 geplant.
4. Am 25.12.2026 (Erster Weihnachtstag, bundesweiter Feiertag) arbeitet das K1-Team nicht.
5. Dein Auftrag wird durch KI-Dienste (Perplexity Sonar, OpenRouter), Jina Reader für Artikel, Supadata für Videos, Pixabay für Fotos und Nextcloud zur Ablage verarbeitet.
6. K1 ist eine Kursübung, daher gibt es keine Preise pro Paket.
7. Aufträge per Sprachnachricht sind per Telegram möglich, wobei du deinen Kundennamen besser als Text nennst.

Zu deinem dringenden Problem bei Auftrag 24003 (verpixeltes Logo, falsche Farben, benötigt bis Freitag): Das K1-Team wurde informiert.

Bestätigt: Eilmeldung gesendet.
```

**B1 (2019):**

```
Du schreibst mit dem KI-Assistenten von K1. Der Support-Assistent ist gerade nicht erreichbar. Bitte versuch es später noch einmal oder wende dich an das K1-Team. Ein Teil des Vorgangs kann schon ausgeführt worden sein.
```

Die Antworten von S1, S2 und A1 sind Rückgaben des einzeln gestarteten Spezialisten und stehen vollständig in der Tabelle; die Antworten des Nachtrags und der Kontrolle am Endstand stehen dort ebenfalls vollständig, ohne Zeilenumbruch außer bei L2 (Kontrolle im Nachtrag und in der Kontrolle am Endstand) und L3b.
