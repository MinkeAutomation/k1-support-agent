-- 004_agt_w06_wissensbasis.sql
-- Wissensbasis des K1 Support-Agenten (Vektorsuche): Stuecke der technischen K1-Dokumente mit Vektor.
-- Die Tabelle folgt dem Schema des n8n-Vector-Store-Knotens (content, metadata, embedding); aus den Metadaten
-- werden Spalten berechnet. Dazu kommt die Suchfunktion match_agt_w06_knowledge_chunks.
--
-- Embedding-Paar: Modell models/gemini-embedding-001 mit 3072 Dimensionen (mit 1 Probeaufruf gemessen).
-- Ein anderes Modell, eine andere Dimension oder fehlende Modellangaben scheitern beim Schreiben an der Pruefregel
-- agt_w06_knowledge_paar (is true: ein fehlender Wert ergibt sonst NULL, und NULL liesse eine CHECK-Regel durch).
-- Vektor, Dokument und Stueck-Nummer sind Pflicht (not null).
-- Ein Wechsel heisst neue Spalte und vollstaendiges Neueinlesen.
--
-- Rechte: anon darf nur lesen (Policy nur SELECT) und die Suchfunktion aufrufen. Schreiben darf nur der Einlese-Workflow
-- mit dem Schreibzugang (service_role umgeht RLS). Die Texte stammen aus dem oeffentlichen K1-Repository.
--
-- Vektoren mit mehr als 2000 Dimensionen bekommen keinen HNSW-Index; bei rund 30 bis 60 Stuecken genuegt die
-- sequentielle Suche. Die Erweiterung vector liegt auf dieser Instanz im Schema extensions, deshalb
-- extensions.vector und operator(extensions.<=>) bei leerem search_path.

begin;

create table public.agt_w06_knowledge_chunks (
  id          bigserial primary key,
  content     text not null,
  metadata    jsonb not null default '{}'::jsonb,
  embedding   extensions.vector(3072) not null,
  dokument    text generated always as (metadata->>'dokument') stored not null,
  chunk_index int  generated always as ((metadata->>'chunk_index')::int) stored not null,
  kategorie   text generated always as (metadata->>'kategorie') stored,
  created_at  timestamptz not null default now(),
  constraint agt_w06_knowledge_paar check ((
    metadata->>'embed_model' = 'models/gemini-embedding-001'
    and metadata->>'embed_dims' = '3072') is true),
  constraint agt_w06_knowledge_eindeutig unique (dokument, chunk_index)
);

alter table public.agt_w06_knowledge_chunks enable row level security;

revoke all on public.agt_w06_knowledge_chunks from anon, authenticated;
grant select on public.agt_w06_knowledge_chunks to anon;

create policy "anon liest Wissensbasis" on public.agt_w06_knowledge_chunks
  for select to anon using (true);

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
    where k.metadata @> coalesce(filter, '{}'::jsonb)
    order by k.embedding operator(extensions.<=>) query_embedding, k.id
    limit match_count;
end;
$$;

revoke execute on function public.match_agt_w06_knowledge_chunks(extensions.vector, int, jsonb)
  from public, anon, authenticated;
grant execute on function public.match_agt_w06_knowledge_chunks(extensions.vector, int, jsonb)
  to anon, service_role;

commit;
