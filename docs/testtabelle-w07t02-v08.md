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

**In den Reihen dieser Tabelle ist der Ticketpfad nicht live gemessen.** Für alle Läufe der Tabelle zeigte das Werkzeug `Teamvormerkung` absichtlich auf eine nicht vorhandene Datenbankfunktion, damit kein weiteres echtes Ticket entsteht; danach wurde es zurückgesetzt (im Export nachgemessen). Ein Vormerkaufruf liefert deshalb in diesen Läufen einen technischen Fehler und nie eine Ticketnummer. Dass der Workflow bei einer bestätigten Vormerkung die Ticketnummer im festen Absatz nennt, ist im Knotentest belegt; live belegt ist das Anlegen eines Tickets durch den Aktions-Spezialisten im Lauf 1936.

**Testticket K1-T-01056.** Beim Bau entstand in einem Einzellauf des Aktions-Spezialisten (Lauf 1936, eine Vormerkung mit der zu kurzen Nummer 123 im Text) ein echtes Ticket K1-T-01056, weil das Modell die Nummer diesmal nicht an das Werkzeug gab. Es ist ein Testticket und bleibt stehen.

**Mails.** Alle Eilmeldungen gingen an die feste Test-Adresse: in der Schlussreihe 1 (L2), im Nachtrag 1 (L2 Kontrolle), in der Kontrolle am Endstand 2 (L2 Lauf 2050, F4b Lauf 2066). Frühere Läufe von F4b und B1 mit der vorherigen Eingabe sendeten 2 weitere an dieselbe Adresse. Keine Mail an echte Empfänger.

**F4b und B1 überarbeitet.** Beide Fälle laufen mit einer überarbeiteten Eingabe (Wortlaut im Abschnitt „Kontrolle Endstand“) und stehen dort mit den Läufen 2066 und 2069. Die früheren Läufe dieser beiden Fälle sind ersetzt.

**Zahlen getrennt.** Schlussreihe 9 Läufe: 7 PASS, 2 FAIL (L1, A1). Nachtrag 6 Läufe: 6 PASS. Kontrolle am Endstand 6 Läufe: 6 PASS. Die beiden FAIL der Schlussreihe bleiben FAIL; die späteren Läufe heben sie nicht auf.

**Bonus: Max Iterations.** Das Limit steht im Orchestrator auf 5 und in beiden Spezialisten auf 4. Für den Bonusversuch B1 lief der Orchestrator einmal mit 1 (Lauf 2069), danach wieder 5; der Spezialist einzeln lief für A1 einmal mit 1 (Lauf 2015), danach wieder 4.

## Schlussreihe am Endstand (9 Läufe)

Erwartung vor dem Lauf in der Spalte „Soll“. Zeilenumbrüche der Antworten stehen als `<br>`, der ungekürzte Wortlaut folgt unter der Tabelle. F4b und B1 stehen mit überarbeiteter Eingabe in der Kontrolle am Endstand.

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

Zusammen: 9 Läufe, 7 PASS (2 davon mit Grenze), 2 FAIL (L1, A1).

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

## Kontrolle Endstand (6 Läufe)

Stand nach der letzten Textrunde: Die Rollen-Abschnitte der 3 Prompts, der feste Ausfallsatz, einige Notizen, die Beschreibung des Orchestrators und Code-Kommentare wurden sachlich neu gefasst; die Logik blieb gleich, und `Belege aus Kontext [Code]` im Aktions-Spezialisten liegt etwas höher. Danach wurden nur noch Notizen neu gefasst. Diese 6 Läufe laufen auf der Logik der Exporte. **Werkzeug ohne Ziel:** `Teamvormerkung` im Aktions-Spezialisten zeigte für die Läufe auf eine nicht vorhandene Datenbankfunktion und ist danach zurückgesetzt, der Aktions-Spezialist neu veröffentlicht. **Mails:** genau 2 an die feste Testadresse (L2, F4b), kein Ticket. Die Zeilen der Tabellen oben bleiben unverändert stehen. Der feste Ausfallsatz heißt am Endstand „Der Support-Assistent antwortet im Moment nicht.“

**Eingabe F4b und B1 (Wortlaut, beide Läufe gleich, 7 Fragen im Fließtext; Kopf `[K06|s=kontrolle-f4b]` beziehungsweise `[K07|s=kontrolle-b1b]`):**

```
Guten Abend, hier schreibt Lena Brandt vom Verein Nordlicht Lauftreff. Unser Social-Media-Paket zu Auftrag 24003 ist heute angekommen, doch die Farben auf allen drei Beiträgen stimmen nicht und das Logo wirkt unscharf. Ich brauche die Beiträge spätestens am Donnerstag für unsere Jahresfeier und bin deshalb ziemlich verärgert.
Bevor ich etwas freigebe, möchte ich wissen, wie lange K1 auf meine Freigabe wartet und in welchem Ordner ich die fertigen Dateien später finde. Woran liegt es, dass Paket 24002 noch nicht fertig ist? Arbeitet bei euch jemand am 26.12.2026? Dazu die Frage, welche Dienste meine Texte und Bilder erzeugen, was ein Paket kostet und ob ich Aufträge auch per Sprachnachricht schicken kann.
Ich will mit der Sache nicht bis nächste Woche warten: Lasst mich bitte heute noch mit jemandem aus eurem Team sprechen.
Lena Brandt
```

Lena Brandt und der Verein sind erfunden.

| Nr | Eingabe | Ausführung | Werkzeuge aus dem Protokoll | Schlussantwort (Wortlaut) | Ergebnis |
|---|---|---|---|---|---|
| L1 | Wie lange wartet K1 auf meine Freigabe? | 2047 | K1_Antwortkatalog (Auskunfts_Agent), status ok | Du schreibst mit dem KI-Assistenten von K1. Die Freigabe wartet 24 Stunden auf deine Entscheidung. Was danach mit einem nicht freigegebenen Paket passiert, klärt der Support persönlich mit dir. | PASS |
| L2 | Bei uns im Studio brennt es, jemand ist verletzt. | 2050 | Eilmeldung_ans_Team, action eskalation:gesendet, status ok, 1 Mail | Du schreibst mit dem KI-Assistenten von K1. Das K1-Team wurde informiert.<br><br>Bestätigt: Eilmeldung gesendet. | PASS, 1 Mail |
| L3a | Das Logo im Paket zu Auftrag 123 ist verpixelt. | 2052 | keine, status ok | Du schreibst mit dem KI-Assistenten von K1. Soll ich das Problem mit dem verpixelten Logo bei Auftrag 123 als Qualitätsproblem vormerken? | PASS |
| L3b | Ja, bitte vormerken. (gleiche Sitzung wie L3a) | 2057 | Teamvormerkung (ohne Ziel, 404), action leer, status tool_error | Das hat gerade nicht geklappt. Bitte wende dich an das K1-Team über den Kanal, über den du Aufträge schickst.<br><br>Bestätigt: nichts. Offen: Vormerkung nicht bestätigt, Ausgang unbekannt. | PASS mit Grenze wie im Lauf 2004: Aufruf stimmt (Aktions_Agent gerufen), das Werkzeug ohne Ziel liefert keinen Beleg, der Absatz sagt Offen |
| F4b | Mehrfachanfrage (Wortlaut oben) | 2066 | K1_Antwortkatalog, Auftragsstand, Feiertage_nachschlagen (Auskunfts_Agent), Eilmeldung_ans_Team (Aktions_Agent), action eskalation:gesendet, status ok, 1 Mail | Du schreibst mit dem KI-Assistenten von K1.<br><br>Zu deinen Fragen: Die Freigabe wartet 24 Stunden auf deine Entscheidung, danach legt K1 die fertigen Dateien in deinen Nextcloud-Kundenordner, dessen Link du mit dem Paket erhältst. Auftrag 24002 befindet sich noch in der Erstellung &ndash; Recherche und Texte laufen, die Vorschau ist für den 28.10.2026 angekündigt. Am 26.12.2026 (Zweiter Weihnachtstag, bundesweiter Feiertag) arbeitet das K1-Team nicht. Texte werden über Perplexity Sonar und ein Sprachmodell via OpenRouter erzeugt, Bilder stammen von Pixabay oder werden für die erste Karussell-Seite per KI generiert. K1 ist eine Kursübung, Preise und Verträge gehören nicht dazu; Aufträge kannst du auch per Sprachnachricht über Telegram schicken.<br><br>Zu deinem dringenden Anliegen bei Auftrag 24003: Das K1-Team wurde informiert.<br><br>Bestätigt: Eilmeldung gesendet. | PASS, 1 Mail: beide Spezialisten liefen, alle 7 Fragen beantwortet (Freigabe, Ablage, Auftragsstand, Feiertag, Dienste, Preis, Sprachnachricht), Teamwunsch führt zur belegten Eilmeldung, Absatz „Bestätigt: Eilmeldung gesendet.“ |
| B1 (Bonus) | wie F4b, Orchestrator Max Iterations 1 (danach 5) | 2069 | `tool_called` true, `tool_calls_count` leer (unbekannt), `tools_called` Auskunfts_Agent, action leer, route ausfall, status error | Du schreibst mit dem KI-Assistenten von K1. Der Support-Assistent antwortet im Moment nicht. Bitte versuch es später noch einmal oder wende dich an das K1-Team. | PASS mit Beobachtung: Abbruch (Max iterations (1) reached) gemessen, fester Ausfallweg, kein Absturz; es lief nur der Auskunfts_Agent, deshalb kein Zusatzsatz und keine Mail. Den Zusatzsatz für einen gelaufenen Aktions_Agent belegt der Knotentest |

Das Zeichen `&ndash;` in F4b ist ein Gedankenstrich aus der Modellantwort (U+2013).

Zusammen: 6 Läufe, 6 PASS (2 davon mit Grenze oder Beobachtung). Für die Eingabe L1 damit 4 von 5 Läufen mit Spezialist (1990 FAIL, 2023, 2025, 2027, 2047).

**Rückbau (im Export nachgemessen):** `max_iterations` im Hauptworkflow wieder 5, `Teamvormerkung` wieder `…/rpc/agt_w06_vormerkung_anlegen`, Aktions-Spezialist veröffentlicht, Auskunfts-Spezialist veröffentlicht, Hauptworkflow nicht veröffentlicht. Gegenüber dem Stand davor sind in den Exporten nur die Knoten mit neu gefassten Texten und die Position von `Belege aus Kontext [Code]` geändert.

## Was nur im Knotentest belegt ist

Die folgenden Verhaltensweisen sind ausschließlich durch Knotentests belegt; ein Live-Nachweis liegt dafür nicht vor. Sie sind nicht live gemessen, weil sie ein echtes Ticket oder einen Fehler zu einem bestimmten Zeitpunkt bräuchten:

- Bestätigte Vormerkung mit Ticketnummer im festen Absatz („Bestätigt: Vormerkung K1-T-…“), auch zusammen mit einer Eilmeldung.
- Teilaktion im Fehlerweg: eine Vormerkung steht, danach fällt der Spezialist aus.
- Bricht der Orchestrator ab, nachdem der Aktions-Spezialist lief, hängt der feste Ausfallsatz „Ein Teil des Vorgangs kann schon ausgeführt worden sein.“ an.
- Unbekannter Ausgang (Zeitüberschreitung, leere oder unlesbare Rückgabe) steht unter „Offen“, nicht unter „Nicht geklappt“.
- Eine Antwort aus nur dem KI-Hinweis geht in den festen Ausfallsatz (Reparatur nach L1).
- Schreibzusagen ohne Werkzeugaufruf wie „Ich habe notiert, dass die Farben im Paket nicht stimmen.“ ersetzt der Prüfknoten.

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

**F4b (2066)** (das Zeichen im zweiten Satz ist im Original U+2013):

```
Du schreibst mit dem KI-Assistenten von K1.

Zu deinen Fragen: Die Freigabe wartet 24 Stunden auf deine Entscheidung, danach legt K1 die fertigen Dateien in deinen Nextcloud-Kundenordner, dessen Link du mit dem Paket erhältst. Auftrag 24002 befindet sich noch in der Erstellung [U+2013] Recherche und Texte laufen, die Vorschau ist für den 28.10.2026 angekündigt. Am 26.12.2026 (Zweiter Weihnachtstag, bundesweiter Feiertag) arbeitet das K1-Team nicht. Texte werden über Perplexity Sonar und ein Sprachmodell via OpenRouter erzeugt, Bilder stammen von Pixabay oder werden für die erste Karussell-Seite per KI generiert. K1 ist eine Kursübung, Preise und Verträge gehören nicht dazu; Aufträge kannst du auch per Sprachnachricht über Telegram schicken.

Zu deinem dringenden Anliegen bei Auftrag 24003: Das K1-Team wurde informiert.

Bestätigt: Eilmeldung gesendet.
```

**B1 (2069):**

```
Du schreibst mit dem KI-Assistenten von K1. Der Support-Assistent antwortet im Moment nicht. Bitte versuch es später noch einmal oder wende dich an das K1-Team.
```

Die Antworten von S1, S2 und A1 sind Rückgaben des einzeln gestarteten Spezialisten und stehen vollständig in der Tabelle; die Antworten des Nachtrags und der Kontrolle am Endstand stehen dort ebenfalls vollständig, ohne Zeilenumbruch außer bei L2 (Kontrolle im Nachtrag und in der Kontrolle am Endstand), L3b und F4b.
