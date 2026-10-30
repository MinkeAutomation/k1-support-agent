# Workflows

Hier liegen die n8n-Exporte des Support-Agenten. Dateiname `k1-support-agent_<JJJJ-MM-TT>_vNN.json`, die Versionsnummer immer zweistellig. In den Exporten stehen nur Platzhalter, keine Schlüssel, keine Zugangsdaten und keine private Server- oder Projektadresse. Enthalten sind nur öffentliche Adressen: die Rohdateien auf raw.githubusercontent.com (FAQ und Wissensbasis-Dokumente), openrouter.ai (Jev und Sprachmodell), date.nager.at (Feiertage) und supabase.com (Link im Knopf der Eilmeldung).

Welche Version zu welchem Tag und welcher Tages-Doku gehört, steht in der [Versionstabelle im README](../README.md#versionen).

**Stand 30.10.2026:**

- `k1-support-agent_2026-10-30_v05.1.json`: derselbe Aufbau wie v05 (61 Knoten, 37 ausführbar und 24 Notizen, gleiche Werkzeuge, gleiche Prompts, gleiche Platzhalter und Zugänge) mit korrigiertem Prüfknoten `Werkzeugwahl messen`: Zusagen neben einem Angebot oder in Klammern und Anführungszeichen im selben Satz werden erkannt, und eine Ticketaktion entsteht nur aus der bestätigten Rückgabe der Vormerkung. Die Einrichtung nach dem Import ist dieselbe wie unten. Einzelheiten und Läufe im [ChangeLog](../ChangeLog.md). Bekannte Grenze: Der Prüfknoten arbeitet mit einer Liste fester Formulierungen, einige Sätze rutschen durch, und ein korrektes Angebot mit geteiltem Modalverb ("Ich kann das vormerken und weiterleiten") wird unnötig ersetzt, die sichere Richtung (Einzelheiten und Plan für v06 im ChangeLog).

**Stand 29.10.2026 (Vorgänger):**

Der Export v05 hat 61 Knoten: 37 ausführbare Knoten und 24 Notizen.

- `k1-support-agent_2026-10-29_v05.json`: der Support-Agent mit denselben 6 Werkzeugen, 3 Fassungen des Systemprompts (im Echtbetrieb balanciert, `w06t04-p11-j11`), Rückfrage vor der Vormerkung, Obergrenze von 20 Nachrichten, Ausweichmodell, Jev `j11` mit Verlauf. Er greift auf dieselben Adressen zu wie v04 (raw.githubusercontent.com, openrouter.ai, date.nager.at, supabase.com).

**Stand 28.10.2026 (Vorgänger):**

- `k1-support-agent_2026-10-28_v04.json`: der Support-Agent mit 6 Werkzeugen (`K1_Antwortkatalog`, `K1_Technikwissen`, `Feiertage_nachschlagen`, `Auftragsstand`, `Teamvormerkung`, `Eilmeldung_ans_Team`), Systemprompt `w06t03-p8` (Belegregel, Entscheidungstabelle, Warte-Probe), Jev `j9`, Max Tokens 4096. Tests in `docs/testtabelle-w06t03-v04.md`.
- `k1-wissensbasis-einlesen_2026-10-28_v04.json`: der Einlese-Workflow, der die Wissensbasis füllt (3 Dokumente aus dem öffentlichen K1-Repository, 22 Stücke, Wissensstand 30.09.2026).

Beide Exporte haben einen Chat Trigger beziehungsweise einen manuellen Start ohne öffentlichen Zugang.

## Nach dem Import einrichten

1. **Datenbank:** in Supabase im SQL-Editor nacheinander ausführen: `docs/sql/001_agt_w06_support_log.sql`, `002_agt_w06_chat_histories.sql`, `003_agt_w06_auftraege_tickets.sql`, `004_agt_w06_wissensbasis.sql`, `005_agt_w06_auftrag_abfragen.sql` und `006_agt_w06_vormerkung_anlegen.sql`, für v05 danach `011`, `013`, `014` und `016` (Kennzeichen in der Wissensbasis, Weg `limit`, Prüfung der Vormerkung, Antworttext im Protokoll; `012`, `015`, `017` und `018` gehören zu den Tests). Anschließend den Einlese-Workflow einmal ausführen (Zugänge: Supabase mit der Rolle `service_role` zum Schreiben, Google Gemini für die Vektoren), er legt die 22 Stücke an.
2. **Credentials neu zuweisen** (der Export führt keine Zugänge):

| Knoten | Credential-Typ | wofür |
|---|---|---|
| `K1-Bezug prüfen`, `K1-Bezug erneut prüfen` | OpenAI-Typ mit Base URL `https://openrouter.ai/api/v1` (OpenRouter-Schlüssel) | Jev über die Decisions API |
| `Gratismodell [OpenAI Chat Model]`, `Ausweichmodell [OpenAI Chat Model]` | OpenAI-Typ mit Base URL `https://openrouter.ai/api/v1` (OpenRouter-Schlüssel) | Sprachmodell des Agenten und das Ausweichmodell, wenn das Hauptmodell ausfällt |
| `Verlauf der Sitzung lesen`, `Lauf protokollieren` | Supabase API mit dem serverseitigen Schlüssel der Rolle `service_role` | Protokolltabelle (Row Level Security ohne INSERT-Policy) |
| `Gesprächsverlauf holen`, `Dialog speichern` | dieselbe Supabase API mit der Rolle `service_role` | liest und schreibt `agt_w06_chat_histories` für den Verlauf von Jev |
| `Auftragsstand`, `Teamvormerkung` | Supabase API mit dem öffentlichen `anon`-Schlüssel | rufen nur die Funktionen `agt_w06_auftrag_abfragen` und `agt_w06_vormerkung_anlegen` auf |
| `K1_Technikwissen` | Supabase API mit dem öffentlichen `anon`-Schlüssel (nur lesen) | Suche in `agt_w06_knowledge_chunks` über `match_agt_w06_knowledge_chunks` |
| `Vektoren der Frage [Embeddings Google Gemini]` | Google Gemini (PaLM) API-Schlüssel | gleiches Modell wie beim Einlesen: `models/gemini-embedding-001` (3072 Stellen) |
| `Dauergedächtnis [Postgres Chat Memory]` | Postgres, Verbindung über den Session Pooler von Supabase, SSL an | Tabelle `agt_w06_chat_histories`, Fenster 10 |
| `Eilmeldung_ans_Team` | SMTP | Versand der Eilmeldung; im Export ist kein Zugang hinterlegt, er muss gesetzt werden |

3. **Platzhalter ersetzen** (3 verschiedene, zusammen an 5 Stellen):
   - `<<REPLACE_WITH_SUPABASE_PROJECT>>`: Projektkennung der eigenen Supabase-Adresse, 1 Mal im Feld `supabase_rest` des Knotens `Konfiguration [Edit Fields]` und 1 Mal im Link des Knopfes „Ticket öffnen“ im HTML der Eilmeldung.
   - `<<REPLACE_WITH_TABLE_ID>>`: Tabellen-ID der Tabelle `agt_w06_tickets`, 1 Mal im Knopf der Mail. Sie steht in der Adresszeile, wenn man die Tabelle in Supabase im Tabelleneditor öffnet (Adressteil `/editor/<Zahl>`).
   - `<<REPLACE_WITH_TEST_EMAIL>>`: eigene Test-Mailadresse, 2 Mal im Knoten `Eilmeldung_ans_Team` (Absender und Empfänger). Der Empfänger ist fest eingetragen und wird nie vom Modell gesetzt.
4. Die Einstellungen `errorWorkflow` (Verweis auf einen Fehler-Workflow) und `availableInMCP` (Freigabe für den MCP-Zugriff) gelten nur für die Instanz, auf der der Workflow läuft und stehen deshalb nicht im Export; nach dem Import einen eigenen Fehler-Workflow eintragen und die MCP-Freigabe bewusst setzen.
5. Die FAQ-Adresse (`faq_url` in der Konfiguration) zeigt auf `faq/k1-faq.csv` im Repository `MinkeAutomation/k1-support-agent`; bei einem anderen Repository anpassen.
