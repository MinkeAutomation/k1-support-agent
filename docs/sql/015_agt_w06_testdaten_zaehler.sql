-- 015_agt_w06_testdaten_zaehler.sql
-- Testdaten fuer den Sitzungszaehler (Tag 4): 20 Protokollzeilen einer Test-Sitzung, damit die 21. Nachricht ohne
-- 20 echte Modellaufrufe geprueft werden kann. Die Zeilen sind gekennzeichnet (workflow_name, execution_id, test_id)
-- und gehoeren zur Sitzung test-zaehler-v05. Sie werden nicht geloescht.

insert into public.agt_w06_support_log
  (execution_id, workflow_name, workflow_version, prompt_version, test_id, session_id, question, route, tool_called, tool_calls_count, status)
select 'testdaten-zaehler-' || g, 'Testdaten Sitzungszaehler v05', 'v05', 'testdaten', 'ZSEED', 'test-zaehler-v05',
       'Testnachricht ' || g, 'agent', false, 0, 'ok'
from generate_series(1, 20) g;

-- Kontrolle: select count(*) from public.agt_w06_support_log where session_id = 'test-zaehler-v05';  -- erwartet: 20
