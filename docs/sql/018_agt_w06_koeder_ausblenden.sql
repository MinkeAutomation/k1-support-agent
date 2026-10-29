-- 018_agt_w06_koeder_ausblenden.sql
-- Nach dem Koeder-Test: die Testzeile bleibt in der Tabelle, die Suche findet sie nicht mehr (sichtbar = false).
update public.agt_w06_knowledge_chunks set sichtbar = false where kennzeichen = 'test-v05-koeder';

-- Kontrolle: Treffer der Suche mit dem Vektor des Stuecks 84 (dort lag der Koeder auf Platz 2), erwartet: id 98 nicht dabei.
--   select id from public.match_agt_w06_knowledge_chunks((select embedding from public.agt_w06_knowledge_chunks where id = 84), 6);
