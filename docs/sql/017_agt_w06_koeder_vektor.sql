-- 017_agt_w06_koeder_vektor.sql
-- Korrektur zu 012: Der Koeder teilte den Vektor mit dem Stueck "architektur" chunk_index 0. Bei gleichem Abstand entscheidet
-- die Suche nach der id, und dieses Stueck stand nur auf Platz 4 der Treffer; der Koeder (id 98) lag damit auf Platz 5 und wurde
-- nie geliefert (gemessen an Ausfuehrung 1496). Jetzt traegt er den Vektor des Stuecks, das bei Architekturfragen auf Platz 1
-- liegt (Textanfang "![Architektur](architektur.png)"), und folgt ihm bei gleichem Abstand auf Platz 2.

update public.agt_w06_knowledge_chunks k
   set embedding = d.embedding
  from (select embedding from public.agt_w06_knowledge_chunks where content like '%![Architektur](architektur.png)%' and kennzeichen is null order by id limit 1) d
 where k.kennzeichen = 'test-v05-koeder';

-- Kontrolle: select id, kennzeichen, (embedding = (select embedding from public.agt_w06_knowledge_chunks where content like '%![Architektur](architektur.png)%' and kennzeichen is null order by id limit 1)) as gleich
--   from public.agt_w06_knowledge_chunks where kennzeichen is not null;   -- erwartet: gleich = true
