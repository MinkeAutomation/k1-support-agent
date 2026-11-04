# Testtabelle W07T03, K1 Support-Agent v09

Die Tabelle gehört zur Tages-Doku von Woche 7, Tag 3. Sie zählt nur Läufe am ganzen Agenten (Hauptworkflow mit beiden Agenten und dem MCP-Server). Die Einzeltests am Server und an den Agenten stehen weiter unten in eigenen Tabellen.

**Zahlen:** Gesamttest 7 Fälle in 17 Läufen (Tabelle 1, 17 Zeilen), Nachläufe nach den Notizkorrekturen und der Neuanordnung 6 Läufe (Tabelle 2), Einzeltests am Server 8 Fälle (Tabelle 3), Einzeltests an den Agenten 10 Läufe (Tabelle 4).

**Stand der Version beim Test (04.11.2026):**

| Merkmal | Wert |
|---|---|
| Workflow | Hauptworkflow v09 (Konfigurationswert `v16`, der Hauptworkflow blieb gegenüber v08 unverändert), Auskunfts-Agent `sub-auskunft-v2`, Aktions-Agent `sub-aktion-v7`, MCP-Server v09 |
| Prompt-Versionen | Orchestrator `w07t02-o3`, Auskunfts-Agent `w07t01-a1`, Aktions-Agent `w07t03-x3` |
| Modell | `nvidia/nemotron-3-ultra-550b-a55b:free`, Ausweichmodell `nvidia/nemotron-3.5-super-vl:free`, Temperatur 0 an den Agenten |
| Gedächtnis | nur am Orchestrator: Postgres Chat Memory, Fenster 10, Schlüssel je Sitzung. Die Agenten haben keins |
| Ausgangsverlauf | leer: jeder Lauf startete in einer neuen Sitzung (Sitzungskennung aus der Ausführung) |
| Werkzeugwahl | Auskunfts-Agent: 4 lesende Werkzeuge, Aktions-Agent: 2 schreibende, jeweils über „Selected“ am MCP-Client |

**Wie gemessen wird:** Die Erwartung stand vor dem Lauf fest. „Werkzeug gemessen“ kommt aus dem Ausführungsprotokoll (die tatsächlich ausgeführten Aufrufe), nie aus einer Selbstauskunft des Agenten. Die Antwort steht im Wortlaut, wie der Prüfknoten sie ausgibt; vor der ersten Antwort einer Sitzung setzt der Workflow den Hinweis „Du schreibst mit dem KI-Assistenten von K1.“, in Lauf 2132 ist er in der Ausgabe des Prüfknotens noch nicht enthalten.

## Tabelle 1: Gesamttest über den Hauptworkflow (17 Zeilen)

| Nr | Kategorie | Eingabe | Erwartet (vorab) | Quelle erwartet | Werkzeug gemessen | Antwort im Wortlaut | Urteil | Lauf | Notiz |
|---|---|---|---|---|---|---|---|---|---|
| A1 | Happy Path | Wie ist der Stand von Auftrag 24002? | Auskunfts-Agent, `Auftragsstand` | API (Datenbankfunktion) | `Auftragsstand` | Du schreibst mit dem KI-Assistenten von K1. Auftrag 24002 ist ein Social-Media-Paket mit 3 Beiträgen und befindet sich aktuell in der Erstellung. Recherche und Texte laufen noch, die Vorschau wird voraussichtlich am 28.10.2026 bereitgestellt. Zuletzt wurde der Auftrag am 27.10.2026 aktualisiert. Das voraussichtliche Fertigstellungsdatum ist der 28.10.2026. | PASS | 2123 | 44 s |
| A2 | Happy Path | Wie ist der Stand von Auftrag 24002? | wie A1 | API | `Auftragsstand` | Du schreibst mit dem KI-Assistenten von K1. Auftrag 24002 ist ein Social-Media-Paket mit 3 Beiträgen und befindet sich in der Erstellung. Die Recherche und Texte laufen noch, die Vorschau war für den 28.10.2026 angekündigt. Zuletzt wurde der Auftrag am 27.10.2026 aktualisiert. Das voraussichtliche Fertigstellungsdatum liegt bereits hinter dem heutigen 04.11.2026. Für eine aktuelle Einschätzung wende dich bitte an das K1-Team über den gewohnten Kanal. | PASS | 2128 | 50 s; der Agent erkennt, dass das Datum verstrichen ist, und verweist ans Team |
| A3 | Happy Path | Wie ist der Stand von Auftrag 24002? | wie A1 | API | `Auftragsstand` | Du schreibst mit dem KI-Assistenten von K1. Auftrag 24002 ist ein Social-Media-Paket mit 3 Beiträgen und befindet sich aktuell in der Erstellung. Recherche und Texte laufen noch, die Vorschau wird voraussichtlich am 28.10.2026 bereitgestellt. Der Auftrag wurde zuletzt am 27.10.2026 aktualisiert. | PASS | 2148 | 42 s |
| B1 | Happy Path | Wie lange habe ich Zeit für die Freigabe? | Auskunfts-Agent, `K1_Antwortkatalog` | FAQ | `K1_Antwortkatalog` | Du schreibst mit dem KI-Assistenten von K1. Die Freigabe wartet 24 Stunden auf deine Entscheidung; was danach mit einem nicht freigegebenen Paket passiert, klärt der Support persönlich mit dir. | PASS | 2130 | 32 s |
| B2 | Happy Path | Wie lange habe ich Zeit für die Freigabe? | wie B1 | FAQ | `K1_Antwortkatalog` | Du schreibst mit dem KI-Assistenten von K1. Die Freigabe wartet 24 Stunden auf deine Entscheidung. Was danach mit einem nicht freigegebenen Paket passiert, klärt der Support persönlich mit dir. | PASS | 2150 | 59 s |
| B3 | Happy Path | Wie lange habe ich Zeit für die Freigabe? | wie B1 | FAQ | `K1_Antwortkatalog` | Du schreibst mit dem KI-Assistenten von K1. Die Freigabe wartet 24 Stunden auf deine Entscheidung. Was danach mit einem nicht freigegebenen Paket passiert, klärt der Support persönlich mit dir. | PASS | 2152 | 27 s |
| C1 | Edge Case (Gefahr) | Es hat bei uns im Büro gebrannt, bitte sofort Hilfe vom Team, es geht um Auftrag 24002. TESTLAUF, bitte ignorieren. | Aktions-Agent, `Eilmeldung_ans_Team`, Aktion `eskalation:gesendet` | keine (Mail ans Team) | `Eilmeldung_ans_Team` | Du schreibst mit dem KI-Assistenten von K1. Das K1-Team wurde informiert.<br><br>Bestätigt: Eilmeldung gesendet. | PASS | 2139 | 107 s; 1 Testmail an die feste Testadresse |
| C2 | Edge Case (Gefahr) | wie C1 | wie C1 | keine | `Eilmeldung_ans_Team` | Du schreibst mit dem KI-Assistenten von K1.<br>Das K1-Team wurde informiert.<br><br>Bestätigt: Eilmeldung gesendet. | PASS | 2164 | 44 s; 1 Testmail |
| C3 | Edge Case (Gefahr) | wie C1 | wie C1 | keine | `Eilmeldung_ans_Team` | Du schreibst mit dem KI-Assistenten von K1.<br>Das K1-Team wurde informiert.<br><br>Bestätigt: Eilmeldung gesendet. | PASS | 2167 | 58 s; 1 Testmail |
| D1 | Edge Case (Zustimmung fehlt) | Das Logo in Auftrag 24003 ist verpixelt, kannst du das vom Team korrigieren lassen? | kein Werkzeug, Rückfrage nach der Vormerkung | keine | kein Werkzeug | Du schreibst mit dem KI-Assistenten von K1.<br><br>Soll ich das als Problem „verpixeltes Logo“ bei Auftrag 24003 vormerken lassen? | PASS | 2134 | 12 s; nichts angelegt |
| D2 | Edge Case (Zustimmung fehlt) | wie D1 | wie D1 | keine | kein Werkzeug | Du schreibst mit dem KI-Assistenten von K1.<br><br>Soll ich das als Problem „verpixeltes Logo“ für Auftrag 24003 vormerken, damit das Team es korrigiert? | PASS | 2155 | 16 s; nichts angelegt |
| D3 | Edge Case (Zustimmung fehlt) | wie D1 | wie D1 | keine | kein Werkzeug | Du schreibst mit dem KI-Assistenten von K1. Ja, ich kann das für dich beim Team vormerken lassen. Soll ich eine Vormerkung für die Kategorie Bildqualität mit dem Anliegen „Logo verpixelt“ für Auftrag 24003 anlegen? | PASS | 2157 | 34 s; nichts angelegt. Grenze: „Bildqualität“ ist keine Kategorie des Werkzeugs, die Rückfrage bleibt trotzdem richtig |
| E1 | Fehler (ungültige Nummer) | Bitte leg ein Ticket an: Das Logo im Paket zu Auftrag 123 ist verpixelt. | Aktions-Agent, `Teamvormerkung`, Antwort „ungültig“, nichts angelegt | API (Schreibfunktion) | `Teamvormerkung` | Du schreibst mit dem KI-Assistenten von K1.<br><br>Die Auftragsnummer muss genau fünfstellig sein. Könntest du mir die korrekte fünfstellige Auftragsnummer nennen?<br><br>Bestätigt: nichts. Nicht geklappt: Vormerkung nicht angelegt (Auftragsnummer ungültig). | PASS | 2174 | 36 s; im Gesamttest nur 1 Lauf, weil ein Aufruf mit leerer Nummer ein echtes Ticket anlegen würde und der Test das nicht verhindert; in diesem Lauf entstand kein Ticket, der Nachlauf mit demselben Satz (N5, Lauf 2227) legte eines an |
| F1 | Happy Path (Wissensbasis) | Was passiert technisch bei K1, wenn kein passendes Foto gefunden wird? | Auskunfts-Agent, `K1_Technikwissen` | RAG (Vektorsuche) | `K1_Technikwissen` | Wenn mindestens zwei Suchbegriffe keine fotografierbare Szene bei Pixabay treffen, generiert FLUX das Bild für Folie 1 stattdessen. Das LinkedIn-Bild wird als eigene Grafik erstellt, bei Abläufen als Diagramm mit einer Station pro Schritt. Gotenberg wandelt das HTML in Bilder um; scheitert Layout 4, wird das bisherige Layout verwendet, und bricht das Rendern ganz ab, endet der Lauf mit Fehler F5. | PASS | 2132 | 60 s; Ausgabe des Prüfknotens, der KI-Hinweis wird danach davor gesetzt |
| F2 | Happy Path (Wissensbasis) | wie F1 | wie F1 | RAG | `K1_Technikwissen` | Du schreibst mit dem KI-Assistenten von K1. Wenn Pixabay kein passendes Foto liefert, weil weniger als zwei Suchwörter auf eine fotografierbare Szene zutreffen, generiert FLUX das Bild für Folie 1 selbst. | PASS | 2170 | 58 s |
| F3 | Happy Path (Wissensbasis) | wie F1 | wie F1 | RAG | `K1_Technikwissen` | Du schreibst mit dem KI-Assistenten von K1. Wenn kein passendes Foto gefunden wird - also weniger als zwei Suchwörter zu einer fotografierbaren Szene passen - generiert FLUX das Bild für Folie 1, statt ein Foto von Pixabay zu nutzen. | PASS | 2172 | 71 s; die 2 Gedankenstriche der Antwort sind hier durch Bindestriche ersetzt, sonst Wortlaut |
| G1 | Fehler (Server nicht erreichbar) | Wie ist der Stand von Auftrag 24002? bei absichtlich unveröffentlichtem MCP-Server | fester Ausfallsatz, Weg `Ausfallpfad`, Status `tool_error` | API (Server fällt aus) | `Auskunfts_Agent`, `Ausfallpfad` | Du schreibst mit dem KI-Assistenten von K1. Das hat gerade nicht geklappt. Bitte wende dich an das K1-Team über den Kanal, über den du Aufträge schickst. | PASS | 2201 | 43 s; der Einzellauf des Auskunfts-Agenten (Lauf 2200) endete nach 0,2 s mit `status error` |

**Ergebnis Tabelle 1:** 17 von 17 Läufen bestanden. Die Erwartung zum Werkzeug traf in jedem Lauf zu. Die Fälle A, B, C, D und F laufen je 3 Mal, weil die Antwort des Modells von Lauf zu Lauf im Wortlaut schwankt; die Werkzeugwahl blieb gleich.

## Tabelle 2: Nachläufe nach den Notizkorrekturen und der Neuanordnung (6 Zeilen)

Nach dem Berichtigen der Notizen am Server und dem erneuten Veröffentlichen des Servers (dreimal) lief je ein Fall A noch einmal, um zu belegen, dass die Werkzeuge weiter über den Server erreichbar sind (N1 bis N3). Nach dem Kürzen von Notiztexten in den beiden Agenten und dem erneuten Veröffentlichen lief je ein Fall noch einmal: N4 über den Auskunfts-Agenten, N5 über den Aktions-Agenten. Nach dem Neuanordnen der 4 Workflows im Editor (nur Positionen und Notizgrößen) lief N6 über den Hauptworkflow.

| Nr | Eingabe | Werkzeug gemessen | Antwort im Wortlaut | Urteil | Lauf |
|---|---|---|---|---|---|
| N1 | Wie ist der Stand von Auftrag 24002? | `Auftragsstand` | Du schreibst mit dem KI-Assistenten von K1. Auftrag 24002 ist ein Social-Media-Paket mit 3 Beiträgen und befindet sich aktuell in der Erstellung. Recherche und Texte laufen noch, die Vorschau wird voraussichtlich am 28.10.2026 bereitgestellt. Zuletzt wurde der Auftrag am 27.10.2026 aktualisiert. Das voraussichtliche Fertigstellungsdatum ist der 28.10.2026. | PASS | 2207 |
| N2 | Wie ist der Stand von Auftrag 24002? | `Auftragsstand` | Du schreibst mit dem KI-Assistenten von K1. Auftrag 24002 ist ein Social-Media-Paket mit 3 Beiträgen und befindet sich aktuell in der Erstellung. Recherche und Texte laufen noch, die Vorschau wird voraussichtlich am 28.10.2026 bereitgestellt. Der voraussichtliche Fertigstellungstermin ist ebenfalls der 28.10.2026. Zuletzt wurde der Auftrag am 27.10.2026 aktualisiert. | PASS | 2212 |
| N3 | Wie ist der Stand von Auftrag 24002? | `Auftragsstand` | Du schreibst mit dem KI-Assistenten von K1. Auftrag 24002 ist ein Social-Media-Paket mit 3 Beiträgen und befindet sich aktuell in der Erstellung. Recherche und Texte laufen noch, die Vorschau wird voraussichtlich am 28.10.2026 bereitgestellt. Zuletzt wurde der Auftrag am 27.10.2026 aktualisiert. | PASS | 2217 |
| N4 | Wie ist der Stand von Auftrag 24002? (nach dem Kürzen der Notizen im Auskunfts-Agenten) | `Auftragsstand` | Du schreibst mit dem KI-Assistenten von K1. Auftrag 24002 ist ein Social-Media-Paket mit 3 Beiträgen und befindet sich aktuell in der Erstellung. Recherche und Texte laufen noch, die Vorschau wird voraussichtlich am 28.10.2026 bereitgestellt. Zuletzt wurde der Auftrag am 27.10.2026 aktualisiert. | PASS | 2222 |
| N5 | Bitte leg ein Ticket an: Das Logo im Paket zu Auftrag 123 ist verpixelt. (nach dem Kürzen der Notizen im Aktions-Agenten) | `Teamvormerkung` | Du schreibst mit dem KI-Assistenten von K1. Das Ticket K1-T-01057 wurde für die Korrektur des verpixelten Logos im Paket zu Auftrag 12335 angelegt.<br><br>Bestätigt: Vormerkung K1-T-01057. | PASS (Werkzeug über den Server erreicht), aber Abweichung vom Fall E1 | 2227 |
| N6 | Wie ist der Stand von Auftrag 24002? (nach dem Neuanordnen der Workflows) | `Auftragsstand` | Du schreibst mit dem KI-Assistenten von K1. Auftrag 24002 ist ein Social-Media-Paket mit 3 Beiträgen und befindet sich aktuell in der Erstellung. Recherche und Texte laufen noch, die Vorschau wird voraussichtlich am 28.10.2026 bereitgestellt. Der Stand wurde zuletzt am 27.10.2026 aktualisiert. | PASS | 2232 |

**Abweichung bei N5:** Der Aktions-Agent hat aus „Auftrag 123“ die Nummer 12335 gemacht und damit eine gültige Vormerkung angelegt (Testzeile K1-T-01057, nicht entfernt). Im Lauf 2174 (E1) hatte derselbe Eingabesatz noch die Antwort „Auftragsnummer ungültig“ ergeben. Das Modell schwankt hier von Lauf zu Lauf; die Prüfung der Nummer im Werkzeug greift nur bei der Nummer, die der Agent übergibt. Für N5 zählt nur der Beleg, dass `Teamvormerkung` nach dem Veröffentlichen weiter über den Server läuft.

## Tabelle 3: Einzeltests am MCP-Server (8 Zeilen)

Die Aufrufe liefen über einen Hilfsworkflow mit der Anmeldung des Servers (Läufe 2090 und 2097) und über curl für die Ablehnung.

| Nr | Fall | Erwartet | Gemessen | Lauf |
|---|---|---|---|---|
| S1 | Aufruf ohne Token (POST und GET) | abgelehnt | 403, „Authorization data is wrong!“ | curl |
| S2 | falsches Token (POST) | abgelehnt | 403, gleiche Meldung | curl |
| S3 | `K1_Antwortkatalog` | CSV mit Kopfzeile | 200, Tabelle mit den Spalten `id,kategorie,frage,...` | 2090 |
| S4 | `K1_Technikwissen` mit dem Parameter `input` | Textstellen mit Quellzeile | 200, 4 Textstellen mit „Quelle: …, Abschnitt: …, Wissensstand: 30.09.2026“ | 2097 |
| S5 | `Feiertage_nachschlagen` mit `jahr` 2026 | Liste | 200, Liste mit `2026-01-01 Neujahr` | 2090 |
| S6 | `Auftragsstand` mit `nummer` 24002 | gefunden | 200, `status` gefunden, Phase `in_erstellung` | 2090 |
| S7 | `Teamvormerkung` mit ungültiger Nummer 123 | `ungueltig`, nichts angelegt | 200, `status` ungueltig, nichts angelegt | 2090 |
| S8 | `Eilmeldung_ans_Team`, 1 Aufruf | `accepted`, 1 Mail an die feste Testadresse | 200, `accepted` | 2090 |

Beim Test von S4 meldete `K1_Technikwissen` mit dem Parameter `query` einen Schemafehler: Die Schnittstelle am Server heißt `input`, die Beschreibung des Werkzeugs nennt noch `query`. Die Lage ist in v08 dieselbe; sie ist unter „Grenzen“ in der Dokumentation vermerkt.

## Tabelle 4: Einzeltests an den Agenten (10 Zeilen)

| Nr | Was | Gemessen | Lauf |
|---|---|---|---|
| T1 | Standalone-MCP-Client gegen den Server, alle 6 Werkzeuge einzeln | alle 6 liefern ihr Ergebnis, `tools/list` nennt alle 6 Namen | 2099 |
| T2 | Auskunfts-Agent: Frage zur Freigabefrist und zu Auftrag 24002 | Werkzeugnamen im Protokoll `K1_MCP_Auskunft_K1_Antwortkatalog` und `K1_MCP_Auskunft_Auftragsstand` (Clientname, ein Unterstrich, Werkzeugname) | 2107 |
| T3 | derselbe Test nach dem Anpassen von `Ergebnis bündeln [Code]` | `werkzeuge` trägt `K1_Antwortkatalog` und `Auftragsstand`, Rückgabe als Klartext | 2110 |
| T4 | Aktions-Agent mit Brand-Meldung, Max Iterations 1 (nur um den Fehlerweg zu provozieren) | Werkzeugname `K1_MCP_Aktion_Eilmeldung_ans_Team`, Mail `accepted`, Fehler „Max iterations (1) reached“, Kontext des Clients leer | 2113 |
| T5 | Aktions-Agent mit beiden Modellen absichtlich ungültig | Agent scheitert vor dem Werkzeug, `isExecuted` false | 2115 |
| T6 | Aktions-Agent, Brand-Meldung nach dem Umbau der Auswertung | Antwort „Das K1-Team wurde informiert.“, Beleg danach korrigiert (die SMTP-Antwort wurde zunächst als Verpackung gelesen) | 2116 |
| T7 | Auskunfts-Agent: Technikfrage und Feiertag | `K1_Technikwissen` mit Quellzeile, `Feiertage_nachschlagen` mit Datum | 2118 |
| T8 | Aktions-Agent: Vormerkung mit Zustimmung ja und ungültiger Nummer 123 | Werkzeug `Teamvormerkung`, Rückgabe `ungueltig`, nichts angelegt | 2119 |
| T9 | gleiche Frage an den Auskunfts-Agenten: „Wie ist der Stand von Auftrag 24002? Und lege bitte ein Ticket an.“ | ruft `Auftragsstand`, sagt „Ein Ticket kann ich nicht anlegen“ (der Prompt des Auskunfts-Agenten verbietet Aktionen ohnehin) | 2197 |
| T10 | gleiche Frage an den Aktions-Agenten (Zustimmung nein) | ruft kein Werkzeug, weil die Zustimmung auf „nein“ stand; sagt „Es wurde nichts vorgemerkt, weil die Zustimmung der Person fehlt.“ | 2198 |

T9 und T10 sind nur ein Zusatz und belegen die Auswahl am Client nicht: T9 verbietet der Prompt ohnehin, und in T10 rief der Aktions-Agent wegen der fehlenden Zustimmung gar kein Werkzeug auf. Der gemeinsame Server ist belegt durch T2 (Lauf 2107, Auskunfts-Agent) und die Läufe 2139 und 2174 der Aktion über den Hauptworkflow (Tabelle 1, Fälle C und E1); die Auswahl (4 und 2 Namen) zeigen die Client-Knoten `K1_MCP_Auskunft` und `K1_MCP_Aktion` im Bild.
