-- 013_agt_w06_route_limit.sql
-- Tag 4: neuer Weg "limit" im Protokoll. Eine Sitzung mit 20 Nachrichten bekommt ab der naechsten Nachricht einen festen
-- Abschluss ohne Modellaufruf; die Zeile traegt route = 'limit'.

begin;

alter table public.agt_w06_support_log drop constraint if exists agt_w06_support_log_route_check;
alter table public.agt_w06_support_log add constraint agt_w06_support_log_route_check
  check (route in ('agent', 'rueckfrage', 'fremd', 'ohne_jev', 'ausfall', 'folgefrage', 'limit'));

commit;

-- Kontrolle danach:
--   select pg_get_constraintdef(oid) from pg_constraint where conrelid = 'public.agt_w06_support_log'::regclass and contype = 'c' and conname like '%route%';
