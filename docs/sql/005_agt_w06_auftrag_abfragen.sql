-- 005_agt_w06_auftrag_abfragen.sql
-- Lesefunktion fuer das Werkzeug Auftragsstand. Sie liefert immer ein JSON-Objekt mit dem Feld "status".
--   status "fehlt"       keine Ziffer in der Eingabe; Feld "feld" nennt, was fehlt.
--   status "ungueltig"   Eingabe ist keine Zahl mit genau 5 Ziffern.
--   status "unbekannt"   die Nummer ist gueltig, aber kein Auftrag angelegt.
--   status "gefunden"    dazu die Felder auftragsnummer, paket, phase, hinweis, fertig_voraussichtlich, zuletzt_geaendert.
-- Die Funktion gibt nur Daten zurueck; was der Agent damit tut, steht im Systemprompt.
-- Rechte: security invoker, die Funktion laeuft also nur mit dem SELECT-Recht der Rolle anon auf agt_w06_orders.

begin;

create or replace function public.agt_w06_auftrag_abfragen(p_nummer text)
returns jsonb
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
  v_text text := btrim(regexp_replace(coalesce(p_nummer, ''), '^\s*#', ''));
  v_row public.agt_w06_orders%rowtype;
begin
  if v_text !~ '[0-9]' then
    return jsonb_build_object('status', 'fehlt', 'feld', 'auftragsnummer');
  end if;
  if v_text !~ '^[0-9]{5}$' then
    return jsonb_build_object('status', 'ungueltig', 'feld', 'auftragsnummer', 'regel', 'genau 5 Ziffern');
  end if;
  select * into v_row from public.agt_w06_orders o where o.order_no = v_text;
  if not found then
    return jsonb_build_object('status', 'unbekannt', 'auftragsnummer', v_text);
  end if;
  return jsonb_build_object(
    'status', 'gefunden',
    'auftragsnummer', v_row.order_no,
    'paket', v_row.product,
    'phase', v_row.status,
    'hinweis', v_row.status_note,
    'fertig_voraussichtlich', to_char(v_row.expected_on, 'DD.MM.YYYY'),
    'zuletzt_geaendert', to_char(v_row.updated_at at time zone 'Europe/Berlin', 'DD.MM.YYYY')
  );
end;
$$;

revoke execute on function public.agt_w06_auftrag_abfragen(text) from public, anon, authenticated;
grant execute on function public.agt_w06_auftrag_abfragen(text) to anon, service_role;

commit;

-- Kontrolle danach (im SQL-Editor):
--   select public.agt_w06_auftrag_abfragen('24002');         -- erwartet: status gefunden, paket, phase, ...
--   select public.agt_w06_auftrag_abfragen('77012');         -- erwartet: {"status": "unbekannt", "auftragsnummer": "77012"}
--   select public.agt_w06_auftrag_abfragen('2400');          -- erwartet: status ungueltig
--   select public.agt_w06_auftrag_abfragen('240021');        -- erwartet: status ungueltig
--   select public.agt_w06_auftrag_abfragen('ohne Zahl');     -- erwartet: {"feld": "auftragsnummer", "status": "fehlt"}
--   select has_function_privilege('anon', 'public.agt_w06_auftrag_abfragen(text)', 'execute');  -- erwartet: true
--   select has_function_privilege('authenticated', 'public.agt_w06_auftrag_abfragen(text)', 'execute');  -- erwartet: false
