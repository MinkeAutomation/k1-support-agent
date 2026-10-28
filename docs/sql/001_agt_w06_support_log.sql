-- 001_agt_w06_support_log.sql
-- Protokolltabelle des K1 Support-Agenten: eine Zeile je Lauf, fuer jeden Weg
-- (agent, rueckfrage, fremd, ohne_jev, ausfall, folgefrage). Eine flache Tabelle, ein schreibender Workflow.
-- Gespeichert wird nur, was der Lauf selbst erzeugt; die Fragen im Projekt sind erfunden.

begin;

create table if not exists public.agt_w06_support_log (
  id                  bigint generated always as identity primary key,
  created_at          timestamptz not null default now(),
  execution_id        text not null,
  workflow_name       text not null,
  workflow_version    text not null,
  prompt_version      text,
  test_id             text,
  session_id          text,                 -- Gespraech, an dem die Weiche Folgefragen erkennt
  question            text,
  jev_noul            numeric,              -- Bezug zu K1, 0 bis 1
  jev_anliegen        text,                 -- zweite Jev-Frage, nur als Vergleichswert, nicht geroutet
  jev_anliegen_conf   numeric,
  jev_attempts        integer,              -- 2 heisst: Wiederholung nach 429 oder 529
  route               text not null
                      check (route in ('agent', 'rueckfrage', 'fremd', 'ohne_jev', 'ausfall', 'folgefrage')),
  tool_called         boolean,
  tools_called        text,                 -- ausgefuehrte Werkzeuge in Reihenfolge, aus den Zwischenschritten
  tool_calls_count    integer,
  tool_reason         text,
  action              text,                 -- bestaetigte Aktion (ticket:<Nummer>, eskalation:gesendet) oder leer
  memory_setting      text,                 -- Typ, Fenster und Schluessel des Gedaechtnisses
  model               text,
  tokens_in           integer,              -- vorgesehen, Token stehen nur im Ausfuehrungsprotokoll
  tokens_out          integer,
  cost_usd            numeric,
  cost_usd_listprice  numeric,
  duration_ms         integer,
  status              text not null
                      check (status in ('ok', 'fallback', 'error', 'tool_error'))
);

create index if not exists idx_agt_w06_support_log_created_at on public.agt_w06_support_log (created_at desc);
create index if not exists idx_agt_w06_support_log_execution_id on public.agt_w06_support_log (execution_id);
create index if not exists idx_agt_w06_support_log_session_id on public.agt_w06_support_log (session_id);

-- Row Level Security ist an, eine INSERT-Policy gibt es bewusst nicht: von aussen (Browser, anon) laesst sich nichts schreiben.
-- Der n8n-Knoten "Lauf protokollieren" schreibt mit dem serverseitigen Schluessel der Rolle service_role.
-- Mit dem anon-Schluessel scheitert das Schreiben, die Chat-Antwort erscheint trotzdem. Den Schluessel nur im Credential ablegen.
alter table public.agt_w06_support_log enable row level security;

comment on table public.agt_w06_support_log is 'K1 Support-Agent: eine Protokollzeile je Lauf (Jev-Wert, Weg, Werkzeugaufrufe, Kosten, Dauer).';

commit;

-- Kontrolle nach dem ersten Test (SQL-Editor), die Zeile muss die Ausfuehrungsnummer des Tests tragen:
--   select id, created_at, execution_id, route, tools_called, status from public.agt_w06_support_log order by id desc limit 1;
