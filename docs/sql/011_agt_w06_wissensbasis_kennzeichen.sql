-- 011_agt_w06_wissensbasis_kennzeichen.sql
-- Tag 4: Testzeilen in der Wissensbasis kennzeichnen und aus der Suche ausblenden koennen.
-- Neue Spalten: kennzeichen (Freitext, leer bei echten Stuecken) und sichtbar (true = die Suche findet das Stueck).
-- Die Suchfunktion match_agt_w06_knowledge_chunks (SQL 004) bekommt dieselbe Signatur und die zusaetzliche Bedingung
-- "sichtbar". Die 22 echten Stuecke sind sichtbar, fuer die frueheren Staende aendert sich die Suche damit nicht.
-- Eine Testzeile wird nie geloescht, sondern ueber sichtbar = false ausgeblendet.

begin;

alter table public.agt_w06_knowledge_chunks
  add column if not exists kennzeichen text,
  add column if not exists sichtbar boolean not null default true;

comment on column public.agt_w06_knowledge_chunks.kennzeichen is 'Leer bei echten Stuecken, sonst Name des Tests, zu dem die Zeile gehoert (zum Beispiel test-v05-koeder).';
comment on column public.agt_w06_knowledge_chunks.sichtbar is 'false blendet das Stueck in match_agt_w06_knowledge_chunks aus; die Zeile bleibt in der Tabelle.';

create or replace function public.match_agt_w06_knowledge_chunks(
  query_embedding extensions.vector(3072),
  match_count     int   default 4,
  filter          jsonb default '{}'::jsonb)
returns table (id bigint, content text, metadata jsonb, similarity float)
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if match_count is null or match_count < 1 or match_count > 10 then
    raise exception 'match_count muss zwischen 1 und 10 liegen, war %', match_count;
  end if;
  return query
    select k.id, k.content, k.metadata,
           1 - (k.embedding operator(extensions.<=>) query_embedding) as similarity
    from public.agt_w06_knowledge_chunks k
    where k.sichtbar
      and k.metadata @> coalesce(filter, '{}'::jsonb)
    order by k.embedding operator(extensions.<=>) query_embedding, k.id
    limit match_count;
end;
$$;

revoke execute on function public.match_agt_w06_knowledge_chunks(extensions.vector, int, jsonb)
  from public, anon, authenticated;
grant execute on function public.match_agt_w06_knowledge_chunks(extensions.vector, int, jsonb)
  to anon, service_role;

commit;

-- Kontrolle danach:
--   select count(*) filter (where sichtbar) as sichtbar, count(*) filter (where kennzeichen is not null) as testzeilen
--     from public.agt_w06_knowledge_chunks;      -- vor dem Koeder-Test: 22 sichtbar, 0 Testzeilen
--   select has_function_privilege('anon', 'public.match_agt_w06_knowledge_chunks(extensions.vector, int, jsonb)', 'execute');  -- true
