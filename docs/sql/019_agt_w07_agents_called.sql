-- 019_agt_w07_agents_called.sql
-- K1 Support-Agent v07 (Woche 7 Tag 1, 02.11.2026).
-- Ergänzt die Protokolltabelle um 1 Spalte: die Spezialisten, die der Orchestrator in diesem Lauf gerufen hat,
-- in Aufrufreihenfolge und durch Komma getrennt (zum Beispiel "Auskunfts_Agent,Aktions_Agent").
-- Leer (null) auf allen Wegen ohne Orchestrator (fremd, rueckfrage, limit, ausfall) und in allen Zeilen vor v07.
-- Ausführen: einmal im Supabase SQL-Editor. Mehrfaches Ausführen schadet nicht (if not exists).
-- Row Level Security und Policies der Tabelle bleiben unverändert; geschrieben wird weiter über den Protokoll-Sub mit service_role.

alter table public.agt_w06_support_log
  add column if not exists agents_called text;

comment on column public.agt_w06_support_log.agents_called is
  'v07: vom Orchestrator gerufene Spezialisten in Aufrufreihenfolge, kommagetrennt; null ohne Orchestrator';

-- Prüfung danach (liefert 1 Zeile mit data_type text):
-- select column_name, data_type from information_schema.columns
--  where table_schema = 'public' and table_name = 'agt_w06_support_log' and column_name = 'agents_called';
