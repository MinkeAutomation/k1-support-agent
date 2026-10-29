-- 016_agt_w06_antwort_test.sql
-- Tag 4: Spalte antwort_test im Protokoll. Sie traegt den Antworttext nur bei Testlaeufen (Kuerzel in eckigen Klammern vor der
-- Frage, also eine test_id); im Echtbetrieb bleibt sie leer. Damit lassen sich 45 Vergleichslaeufe ohne einzelnes Oeffnen der
-- Ausfuehrungen auswerten.

begin;

alter table public.agt_w06_support_log add column if not exists antwort_test text;
comment on column public.agt_w06_support_log.antwort_test is 'Antworttext bei Testlaeufen (test_id gesetzt), sonst leer.';

commit;
