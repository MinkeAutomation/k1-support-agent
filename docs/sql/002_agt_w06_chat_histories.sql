-- 002_agt_w06_chat_histories.sql
-- Tabelle fuer das dauerhafte Gedaechtnis (Knoten Postgres Chat Memory), vorab angelegt statt vom Knoten.
-- Grund: legt der Knoten die Tabelle selbst an, ist nicht gesichert, dass Row Level Security an ist, und die Tabelle
-- enthaelt den Gespraechsverlauf. Aufbau wie die Standardtabelle des Knotens (id, session_id, message), nur mit eigenem Namen.

begin;

create table if not exists public.agt_w06_chat_histories (
  id          serial primary key,
  session_id  varchar(255) not null,
  message     jsonb not null
);

create index if not exists idx_agt_w06_chat_histories_session_id on public.agt_w06_chat_histories (session_id);

alter table public.agt_w06_chat_histories enable row level security;
revoke all on public.agt_w06_chat_histories from anon, authenticated;

comment on table public.agt_w06_chat_histories is 'K1 Support-Agent: Gespraechsverlauf je session_id fuer Postgres Chat Memory, kein Zugriff fuer anon und authenticated.';

commit;

-- Kontrolle: select relrowsecurity from pg_class where relname = 'agt_w06_chat_histories';  -- erwartet true
