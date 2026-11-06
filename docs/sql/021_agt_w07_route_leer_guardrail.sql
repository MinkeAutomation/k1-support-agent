-- 021_agt_w07_route_leer_guardrail.sql
-- Woche 7 Tag 5 (K1 v11): zwei neue Wege im Protokoll. route = 'leer' (leere oder nur aus Leerzeichen bestehende Frage,
-- fester Hinweis ohne Modellaufruf) und route = 'guardrail' (Ausgangs-Guardrail hat den Modelltext ersetzt, tool_reason traegt den Musternamen).
-- Die Spalte status bleibt unveraendert (ok, fallback, error, tool_error): leer schreibt ok, guardrail schreibt fallback.
-- Muster: 013_agt_w06_route_limit.sql. Nur diese eine CHECK-Aenderung, keine andere Tabelle.

begin;

alter table public.agt_w06_support_log drop constraint if exists agt_w06_support_log_route_check;
alter table public.agt_w06_support_log add constraint agt_w06_support_log_route_check
  check (route in ('agent', 'rueckfrage', 'fremd', 'ohne_jev', 'ausfall', 'folgefrage', 'limit', 'leer', 'guardrail'));

commit;

-- Kontrolle danach:
--   select pg_get_constraintdef(oid) from pg_constraint where conrelid = 'public.agt_w06_support_log'::regclass and contype = 'c' and conname like '%route%';
