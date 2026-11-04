# Workflows

Hier liegen die n8n-Exporte des Support-Agenten. Dateiname `k1-support-agent_<JJJJ-MM-TT>_vNN.json`, die Versionsnummer immer zweistellig. In den Exporten stehen nur Platzhalter, keine Schlüssel, keine Zugangsdaten und keine private Server- oder Projektadresse. Enthalten sind nur öffentliche Adressen: die Rohdateien auf raw.githubusercontent.com (FAQ und Wissensbasis-Dokumente), openrouter.ai (Jev und Sprachmodell), date.nager.at (Feiertage) und supabase.com (Link im Knopf der Eilmeldung); ab v09 kommt in den Agenten die interne Adresse `http://localhost:5678/mcp/<<REPLACE_WITH_MCP_PATH>>` des MCP-Servers dazu.

Welche Version zu welchem Tag und welcher Tages-Doku gehört, steht in der [Versionstabelle im README](../README.md#versionen).

**Stand 04.11.2026:**

- `k1-mcp-server_2026-11-04_v09.json` (neu, `AGT-2606 W07T03 K1 MCP-Server v09`, 25 Knoten, davon 8 ausführbar und 17 Notizen): ein eigener Workflow mit einem MCP Server Trigger (Anmeldung Bearer Auth, Pfad als Platzhalter `<<REPLACE_WITH_MCP_PATH>>`) und den 6 Werkzeugen `K1_Antwortkatalog`, `K1_Technikwissen` (mit Embeddings), `Feiertage_nachschlagen`, `Auftragsstand`, `Teamvormerkung` und `Eilmeldung_ans_Team`. `Teamvormerkung` trägt hier den Parameter `session_id`, weil es am Server keinen Konfigurationsknoten gibt; die Kennung steht als Zeile „Sitzung: …“ im Auftrag des Aktions-Agenten. Die Zugänge der Werkzeuge sind dieselben wie in der Tabelle unter „Nach dem Import einrichten“, nur dass sie jetzt im Server gesetzt werden.
- `k1-support-agent_2026-11-04_v09.json` (`AGT-2606 W07T03 K1 Support-Agent v09`, 58 Knoten, 31 ausführbar und 27 Notizen): der Hauptworkflow ist gegenüber v08 in Logik und Prompt unverändert, die Notizen sind auf v09 gestellt. Er ruft die beiden Agenten `SUB Auskunfts-Agent K1 v09` und `SUB Aktions-Agent K1 v09` auf (4 Platzhalter für Sub-Workflows wie bei v07).
- `subs/sub-auskunfts-agent-k1.json` (Stand v09, 32 Knoten, 12 ausführbar und 20 Notizen) und `subs/sub-aktions-agent-k1.json` (Stand v09, 33 Knoten, 13 ausführbar und 20 Notizen): die Werkzeug-Knoten sind durch je einen MCP Client ersetzt, `K1_MCP_Auskunft` (Auswahl „Selected“, 4 lesende Werkzeuge) und `K1_MCP_Aktion` (Auswahl „Selected“, `Teamvormerkung` und `Eilmeldung_ans_Team`). Adresse der Clients: `http://localhost:5678/mcp/<<REPLACE_WITH_MCP_PATH>>`, Anmeldung Bearer Auth mit demselben Token wie am Server. Die interne Adresse gilt, weil ein Client über die öffentliche Adresse der Instanz in unserer Umgebung eine Prüfseite bekam; läuft deine Instanz anders, trägst du dort die passende Adresse ein. Die Fassungen von v08 sind über den Git-Tag `v08` abrufbar.
- Keine neue SQL-Datei.

**Reihenfolge für v09:**

1. Wie bei v07: Datenbank einrichten und `sub-jev-weiche.json` und `sub-protokollzeile.json` importieren (Zugänge siehe Tabelle unten).
2. **Zuerst den Server** importieren, eigenen Zugang vom Typ Bearer Auth (ein selbst gewählter Token) am Trigger setzen, den Pfad (`<<REPLACE_WITH_MCP_PATH>>`) durch einen langen, eigenen Pfad ersetzen, die Werkzeug-Zugänge setzen, die Platzhalter `<<REPLACE_WITH_SUPABASE_PROJECT>>`, `<<REPLACE_WITH_TABLE_ID>>` und `<<REPLACE_WITH_TEST_EMAIL>>` ersetzen und **veröffentlichen**. Ein nicht veröffentlichter Server lässt die Clients mit einem Fehler (404) scheitern; ohne gültigen Token antwortet er mit 403.
3. Danach die beiden Agenten importieren: in beiden MCP Clients denselben Pfad und denselben Bearer-Zugang eintragen, `<<REPLACE_WITH_SUPABASE_PROJECT>>` ersetzen, Sprachmodell-Zugänge setzen und beide **veröffentlichen**.
4. Zuletzt den Hauptworkflow importieren und in den 4 Knoten `Jev-Weiche aufrufen [Execute Sub-workflow]`, `Protokollzeile aufrufen [Execute Sub-workflow]`, `Auskunfts_Agent` und `Aktions_Agent` den jeweiligen Sub auswählen (Platzhalter wie in der Tabelle für v07 weiter unten).
5. Die Einstellungen im Export des Servers (`callerPolicy` auf `workflowsFromSameOwner`, `availableInMCP` auf true) nach dem Import prüfen und bewusst setzen.

**Stand 03.11.2026 (Vorgänger):**

- `k1-support-agent_2026-11-03_v08.json`: wie v07 aufgebaut, dazu Handoff mit festen Feldern und Fehlerbehandlung. `Aktions_Agent` übergibt `query`, `zustimmung`, `prioritaet` sowie die festen Felder `person_nachricht` und `vorige_antwort`; `Auskunfts_Agent` übergibt `query`. 58 Knoten (31 ausführbar und 27 Notizen). Import wie unten für v07 beschrieben, mit denselben 4 Platzhaltern; die Agenten tragen nach dem Import die Namen `SUB Auskunfts-Agent K1 v08` und `SUB Aktions-Agent K1 v08`. Endstand nach der letzten Textrunde (`workflow_version` `v16`): fester Ausfallsatz „Der Support-Assistent antwortet im Moment nicht. …“, Rollen-Abschnitte der Prompts neu gefasst, Notiz „Testfälle am Endstand“ mit den Läufen der Testtabelle.
- `subs/sub-aktions-agent-k1.json` (Stand v08, 34 Knoten): neu sind das Feld `prioritaet`, die Prüfung der Zustimmung in `Eingabe prüfen [Code]` und der Knoten `Belege aus Kontext [Code]` im Fehlerausgang (14 ausführbare Knoten und 20 Notizen); im Knopf der Eilmeldung stehen `<<REPLACE_WITH_SUPABASE_PROJECT>>` und `<<REPLACE_WITH_TABLE_ID>>`. `subs/sub-auskunfts-agent-k1.json` (Stand v08, 36 Knoten, 16 ausführbar und 20 Notizen): fachlich wie v07. Die Fassungen der Agenten zu v07 sind über den Git-Tag `v07` abrufbar.
- Keine neue SQL-Datei.

**Stand 02.11.2026 (Vorgänger):**

- `k1-support-agent_2026-11-02_v07.json`: der Agent ist in einen Orchestrator und 2 Agenten geteilt. Der Orchestrator `Anfrage verteilen [AI Agent]` hat kein eigenes Fachwerkzeug mehr, er ruft nur `Auskunfts_Agent` und `Aktions_Agent` auf. Beide sind Werkzeuge, die je einen Sub-Workflow starten. Jev-Weiche, Protokoll-Sub, Prüfknoten, Gedächtnis und Ausweichmodell bleiben wie in v06. 58 Knoten (31 ausführbar und 27 Notizen).
- `subs/sub-auskunfts-agent-k1.json` (`SUB Auskunfts-Agent K1`): lesender Agent mit `K1_Antwortkatalog`, `K1_Technikwissen`, `Feiertage_nachschlagen` und `Auftragsstand`, kein Schreibzugriff, kein Mailzugang.
- `subs/sub-aktions-agent-k1.json` (`SUB Aktions-Agent K1`): schreibender Agent mit `Teamvormerkung` und `Eilmeldung_ans_Team`. Die Vormerkung läuft nur, wenn der Orchestrator das Feld `zustimmung` mit ja übergibt.
- Neue Spalte im Protokoll: `agents_called`, angelegt mit `docs/sql/019_agt_w07_agents_called.sql`.

**Reihenfolge für v07:**

1. `docs/sql/019_agt_w07_agents_called.sql` im SQL-Editor ausführen (nach den Dateien unten unter „Nach dem Import einrichten“).
2. Die 4 Subs importieren: `sub-jev-weiche.json`, `sub-protokollzeile.json`, `sub-auskunfts-agent-k1.json`, `sub-aktions-agent-k1.json`. Ihre Zugänge setzen (Tabelle unten) und die Platzhalter ersetzen.
3. **Die beiden neuen Subs veröffentlichen** (Publish). Ein nicht veröffentlichter Sub lässt sich als Werkzeug des Orchestrators nicht aufrufen, der Aufruf liefert dann „Workflow is not active“. Die beiden Subs dürfen nur von Workflows desselben Eigentümers aufgerufen werden.
4. v07 importieren. In 4 Knoten steht statt der Sub-Auswahl ein Platzhalter, dort jeweils den importierten Sub auswählen:

| Knoten im Hauptworkflow | Platzhalter | Sub auswählen |
|---|---|---|
| `Jev-Weiche aufrufen [Execute Sub-workflow]` | `SUB_JEV_WEICHE_NACH_IMPORT_AUSWAEHLEN` | `SUB Jev-Weiche mit Retry` |
| `Protokollzeile aufrufen [Execute Sub-workflow]` | `SUB_PROTOKOLLZEILE_NACH_IMPORT_AUSWAEHLEN` | `SUB Protokollzeile schreiben` |
| `Auskunfts_Agent` | `SUB_AUSKUNFTS_AGENT_NACH_IMPORT_AUSWAEHLEN` | `SUB Auskunfts-Agent K1` |
| `Aktions_Agent` | `SUB_AKTIONS_AGENT_NACH_IMPORT_AUSWAEHLEN` | `SUB Aktions-Agent K1` |

Jeder der beiden neuen Subs hat einen Testzweig (`Testeingang (Test) [Manual Trigger]` mit festen Werten), damit er sich einzeln starten lässt. Im Aufruf durch den Orchestrator läuft dieser Zweig nicht.

**Stand 30.10.2026 (Vorgänger):**

- `k1-support-agent_2026-10-30_v06.json`: derselbe Aufbau wie v05.1, aber die Jev-Weiche und die Protokollzeile laufen als Aufrufe von 2 eigenen Sub-Workflows (`SUB Jev-Weiche mit Retry`, `SUB Protokollzeile schreiben`). 59 Knoten (35 ausführbar und 24 Notizen). Die beiden Subs liegen als Export unter `workflows/subs/` (`sub-protokollzeile.json` und `sub-jev-weiche.json`, ohne Versionsnummer im Namen, mit Platzhaltern statt Zugängen). Sie zuerst importieren und ihre Zugänge setzen, danach v06 importieren und in beiden Aufrufknoten die Workflow-Auswahl neu setzen; die Subs dürfen nur von Workflows desselben Eigentümers aufgerufen werden. Der Jev-Sub trägt den OpenRouter-Zugang, der Protokoll-Sub den Supabase-Schreibzugang. Zusätzlich zur Tabelle `agt_w06_support_log` kennt die Erlaubnisliste des Protokoll-Subs eine Testtabelle `agt_w06_sub_test` (nur für Tests, nicht Teil des Nachbaus, ein Schema dafür liegt nicht im Repo).

- `k1-support-agent_2026-10-30_v05.1.json`: derselbe Aufbau wie v05 (61 Knoten, 37 ausführbar und 24 Notizen, gleiche Werkzeuge, gleiche Prompts, gleiche Platzhalter und Zugänge) mit korrigiertem Prüfknoten `Werkzeugwahl messen`: jede Zusage in Vergangenheit oder Vollzug ("ist angelegt", "wurde informiert") wird auf dem ganzen Text ersetzt, ohne Abstandsfenster (das Partizip der Wortliste allein genügt), egal ob neben einem Angebot, in Klammern, Zitaten, Hervorhebungen, langen Einschüben oder einem Zukunftsnachsatz ("ist angelegt und wird bearbeitet"), solange das Werkzeug sie nicht bestätigt hat, und eine Ticketaktion entsteht nur aus der bestätigten Rückgabe der Vormerkung. Die Einrichtung nach dem Import ist dieselbe wie unten. Einzelheiten und Läufe im [ChangeLog](../ChangeLog.md). Bekannte Grenze: Der Prüfknoten arbeitet mit einer Liste fester Formulierungen, Umschreibungen außerhalb der Liste rutschen durch, und ein korrektes Angebot mit geteiltem Modalverb ("Ich kann das vormerken und weiterleiten") wird unnötig ersetzt, die sichere Richtung (Einzelheiten und Plan für v06 im ChangeLog).

**Stand 29.10.2026 (Vorgänger):**

Der Export v05 hat 61 Knoten: 37 ausführbare Knoten und 24 Notizen.

- `k1-support-agent_2026-10-29_v05.json`: der Support-Agent mit denselben 6 Werkzeugen, 3 Fassungen des Systemprompts (im Echtbetrieb balanciert, `w06t04-p11-j11`), Rückfrage vor der Vormerkung, Obergrenze von 20 Nachrichten, Ausweichmodell, Jev `j11` mit Verlauf. Er greift auf dieselben Adressen zu wie v04 (raw.githubusercontent.com, openrouter.ai, date.nager.at, supabase.com).

**Stand 28.10.2026 (Vorgänger):**

- `k1-support-agent_2026-10-28_v04.json`: der Support-Agent mit 6 Werkzeugen (`K1_Antwortkatalog`, `K1_Technikwissen`, `Feiertage_nachschlagen`, `Auftragsstand`, `Teamvormerkung`, `Eilmeldung_ans_Team`), Systemprompt `w06t03-p8` (Belegregel, Entscheidungstabelle, Warte-Probe), Jev `j9`, Max Tokens 4096. Tests in `docs/testtabelle-w06t03-v04.md`.
- `k1-wissensbasis-einlesen_2026-10-28_v04.json`: der Einlese-Workflow, der die Wissensbasis füllt (3 Dokumente aus dem öffentlichen K1-Repository, 22 Stücke, Wissensstand 30.09.2026).

Beide Exporte haben einen Chat Trigger beziehungsweise einen manuellen Start ohne öffentlichen Zugang.

## Nach dem Import einrichten

1. **Datenbank:** in Supabase im SQL-Editor nacheinander ausführen: `docs/sql/001_agt_w06_support_log.sql`, `002_agt_w06_chat_histories.sql`, `003_agt_w06_auftraege_tickets.sql`, `004_agt_w06_wissensbasis.sql`, `005_agt_w06_auftrag_abfragen.sql` und `006_agt_w06_vormerkung_anlegen.sql`, für v05 danach `011`, `013`, `014` und `016` (Kennzeichen in der Wissensbasis, Weg `limit`, Prüfung der Vormerkung, Antworttext im Protokoll; `012`, `015`, `017` und `018` gehören zu den Tests), für v07 zuletzt `019` (Spalte `agents_called`). Anschließend den Einlese-Workflow einmal ausführen (Zugänge: Supabase mit der Rolle `service_role` zum Schreiben, Google Gemini für die Vektoren), er legt die 22 Stücke an.
2. **Credentials neu zuweisen** (der Export führt keine Zugänge). Ab v07 liegen die Werkzeuge in den beiden Agenten-Subs, die Zugänge werden dort gesetzt; **ab v09 liegen die Werkzeug-Knoten (`K1_Antwortkatalog`, `K1_Technikwissen` samt Embeddings, `Feiertage_nachschlagen`, `Auftragsstand`, `Teamvormerkung`, `Eilmeldung_ans_Team`) im Workflow `K1 MCP-Server`, dort werden ihre Zugänge gesetzt, in den Agenten bleiben Sprachmodell und Ausweichmodell, dazu kommt in den beiden MCP Clients der Zugang Bearer Auth:**

| Knoten | Credential-Typ | wofür |
|---|---|---|
| `K1-Bezug prüfen`, `K1-Bezug erneut prüfen` (bis v05.1; ab v06 im Sub `SUB Jev-Weiche mit Retry`) | OpenAI-Typ mit Base URL `https://openrouter.ai/api/v1` (OpenRouter-Schlüssel) | Jev über die Decisions API |
| `Gratismodell [OpenAI Chat Model]`, `Ausweichmodell [OpenAI Chat Model]` (ab v07 je 1 Paar im Hauptworkflow und in beiden Agenten-Subs) | OpenAI-Typ mit Base URL `https://openrouter.ai/api/v1` (OpenRouter-Schlüssel) | Sprachmodell des Agenten und das Ausweichmodell, wenn das Hauptmodell ausfällt |
| `Verlauf der Sitzung lesen` (auch ab v06 im Hauptworkflow), `Lauf protokollieren` (bis v05.1; ab v06 im Sub `SUB Protokollzeile schreiben`) | Supabase API mit dem serverseitigen Schlüssel der Rolle `service_role` | Protokolltabelle (Row Level Security ohne INSERT-Policy) |
| `Gesprächsverlauf holen`, `Dialog speichern` | dieselbe Supabase API mit der Rolle `service_role` | liest und schreibt `agt_w06_chat_histories` für den Verlauf von Jev |
| `Auftragsstand` (ab v07 im Sub `SUB Auskunfts-Agent K1`), `Teamvormerkung` (ab v07 im Sub `SUB Aktions-Agent K1`) | Supabase API mit dem öffentlichen `anon`-Schlüssel | rufen nur die Funktionen `agt_w06_auftrag_abfragen` und `agt_w06_vormerkung_anlegen` auf |
| `K1_Technikwissen` (ab v07 im Sub `SUB Auskunfts-Agent K1`) | Supabase API mit dem öffentlichen `anon`-Schlüssel (nur lesen) | Suche in `agt_w06_knowledge_chunks` über `match_agt_w06_knowledge_chunks` |
| `Vektoren der Frage [Embeddings Google Gemini]` (ab v07 im Sub `SUB Auskunfts-Agent K1`) | Google Gemini (PaLM) API-Schlüssel | gleiches Modell wie beim Einlesen: `models/gemini-embedding-001` (3072 Stellen) |
| `Dauergedächtnis [Postgres Chat Memory]` | Postgres, Verbindung über den Session Pooler von Supabase, SSL an | Tabelle `agt_w06_chat_histories`, Fenster 10 |
| `Eilmeldung_ans_Team` (ab v07 im Sub `SUB Aktions-Agent K1`) | SMTP | Versand der Eilmeldung; im Export ist kein Zugang hinterlegt, er muss gesetzt werden |

3. **Platzhalter ersetzen** (3 verschiedene):
   - `<<REPLACE_WITH_SUPABASE_PROJECT>>`: Projektkennung der eigenen Supabase-Adresse, im Feld `supabase_rest` des Knotens `Konfiguration [Edit Fields]` und im Link des Knopfes „Ticket öffnen“ im HTML der Eilmeldung. Ab v07 steht `Konfiguration [Edit Fields]` 3 Mal: im Hauptworkflow und in beiden Agenten-Subs, die Eilmeldung im Sub `SUB Aktions-Agent K1`.
   - `<<REPLACE_WITH_TABLE_ID>>`: Tabellen-ID der Tabelle `agt_w06_tickets`, 1 Mal im Knopf der Mail. Sie steht in der Adresszeile, wenn man die Tabelle in Supabase im Tabelleneditor öffnet (Adressteil `/editor/<Zahl>`).
   - `<<REPLACE_WITH_TEST_EMAIL>>`: eigene Test-Mailadresse, 2 Mal im Knoten `Eilmeldung_ans_Team` (Absender und Empfänger). Der Empfänger ist fest eingetragen und wird nie vom Modell gesetzt.
4. Die Einstellungen `errorWorkflow` (Verweis auf einen Fehler-Workflow) und `availableInMCP` (Freigabe für den MCP-Zugriff) gelten nur für die Instanz, auf der der Workflow läuft und stehen deshalb nicht im Export; nach dem Import einen eigenen Fehler-Workflow eintragen und die MCP-Freigabe bewusst setzen.
5. Die FAQ-Adresse (`faq_url` in der Konfiguration) zeigt auf `faq/k1-faq.csv` im Repository `MinkeAutomation/k1-support-agent`; bei einem anderen Repository anpassen.
