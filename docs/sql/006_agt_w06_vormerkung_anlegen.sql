-- 006_agt_w06_vormerkung_anlegen.sql
-- Schreibfunktion fuer das Werkzeug Teamvormerkung: legt genau 1 Zeile in agt_w06_tickets an und liefert ein JSON-Objekt.
--   status "fehlt"     das Anliegen ist leer oder kuerzer als 5 Zeichen; Feld "feld" nennt "anliegen", es wird nichts angelegt.
--   status "erfasst"   Feld "vorgang" traegt die Nummer (K1-T-...), Feld "neu" ist false, wenn innerhalb von 30 Minuten
--                      in derselben Sitzung derselbe Text mit derselben Auftragsnummer und derselben Kategorie schon
--                      vorgemerkt wurde (dann entsteht kein zweiter Eintrag). Ein anderer Auftrag oder eine andere
--                      Kategorie mit gleichem Wortlaut bekommt ein eigenes Ticket; fehlende Auftragsnummern gelten als gleich.
-- Die Funktion gibt nur Daten zurueck; was der Agent daraufhin sagt, steht im Systemprompt.
-- Aufbau: security definer mit leerem search_path, Ausfuehrungsrecht nur fuer anon und service_role.
-- Auf die Tabelle selbst hat anon kein Recht.

begin;

create or replace function public.agt_w06_vormerkung_anlegen(p_kategorie text, p_anliegen text, p_auftrag text default null, p_session_id text default null)
returns jsonb
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_kat text;
  v_no text;
  v_text text;
  v_order text;
begin
  v_text := left(trim(coalesce(p_anliegen, '')), 1000);
  if char_length(v_text) < 5 then
    return jsonb_build_object('status', 'fehlt', 'feld', 'anliegen');
  end if;
  v_kat := lower(trim(coalesce(p_kategorie, '')));
  if v_kat not in ('auftrag', 'gestaltung', 'ablage', 'freigabe', 'technik', 'sonstiges') then
    v_kat := 'sonstiges';
  end if;
  v_order := substring(coalesce(p_auftrag, '') from '([0-9]{5})');
  select t.ticket_no into v_no
    from public.agt_w06_tickets t
   where t.session_id is not distinct from left(p_session_id, 100)
     and t.summary = v_text
     and t.order_no is not distinct from v_order
     and t.category = v_kat
     and t.created_at > now() - interval '30 minutes'
   order by t.id
   limit 1;
  if v_no is not null then
    return jsonb_build_object('status', 'erfasst', 'vorgang', v_no, 'neu', false);
  end if;
  insert into public.agt_w06_tickets (category, summary, order_no, session_id)
  values (v_kat, v_text, v_order, left(p_session_id, 100))
  returning ticket_no into v_no;
  return jsonb_build_object('status', 'erfasst', 'vorgang', v_no, 'neu', true);
end;
$$;

revoke execute on function public.agt_w06_vormerkung_anlegen(text, text, text, text) from public, anon, authenticated;
grant execute on function public.agt_w06_vormerkung_anlegen(text, text, text, text) to anon, service_role;

commit;

-- Kontrolle danach (im SQL-Editor, ohne eine Vormerkung anzulegen):
--   select public.agt_w06_vormerkung_anlegen('technik', '', null, 'kontrolle');          -- erwartet: {"feld": "anliegen", "status": "fehlt"}
--   select has_function_privilege('anon', 'public.agt_w06_vormerkung_anlegen(text, text, text, text)', 'execute');          -- erwartet: true
--   select has_function_privilege('authenticated', 'public.agt_w06_vormerkung_anlegen(text, text, text, text)', 'execute');  -- erwartet: false
