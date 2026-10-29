-- 014_agt_w06_vormerkung_pruefung.sql
-- Tag 4: zwei Verschaerfungen der Funktion agt_w06_vormerkung_anlegen (create or replace, gleiche Signatur).
--   1. Auftragsnummer: die erste Ziffernfolge im Feld p_auftrag muss genau 5 Ziffern haben. Eine laengere oder kuerzere
--      Zahl legt kein Ticket an, die Funktion liefert status "ungueltig" mit feld "auftrag". Vorher nahm sie die ersten
--      5 Ziffern einer 6-stelligen Zahl als Auftragsnummer, waehrend die Auftragsabfrage 6 Ziffern abweist.
--   2. Kontaktdaten: eine Mailadresse im Anliegen wird vor dem Speichern durch "[Adresse entfernt]" ersetzt.
--      Die Vormerkung hat bewusst kein Kontaktfeld; das ist die letzte Sperre hinter dem Systemprompt.
-- Rueckgabe sonst wie in 006: status "fehlt" (Anliegen leer) oder "erfasst" mit vorgang und neu.

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
  v_ziffern text;
begin
  v_text := left(trim(coalesce(p_anliegen, '')), 1000);
  v_text := regexp_replace(v_text, '[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}', '[Adresse entfernt]', 'g');
  if char_length(v_text) < 5 then
    return jsonb_build_object('status', 'fehlt', 'feld', 'anliegen');
  end if;
  v_ziffern := substring(coalesce(p_auftrag, '') from '([0-9]+)');
  if v_ziffern is not null and v_ziffern !~ '^[0-9]{5}$' then
    return jsonb_build_object('status', 'ungueltig', 'feld', 'auftrag', 'regel', 'genau 5 Ziffern');
  end if;
  v_order := v_ziffern;
  v_kat := lower(trim(coalesce(p_kategorie, '')));
  if v_kat not in ('auftrag', 'gestaltung', 'ablage', 'freigabe', 'technik', 'sonstiges') then
    v_kat := 'sonstiges';
  end if;
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

-- Kontrolle danach (die Aufrufe mit 6 Ziffern, leerem Anliegen und zu kurzem Text legen kein Ticket an):
--   select public.agt_w06_vormerkung_anlegen('technik', 'Logo verpixelt, bitte pruefen', '240031', 'kontrolle');  -- erwartet: status ungueltig, feld auftrag
--   select public.agt_w06_vormerkung_anlegen('technik', '', '24003', 'kontrolle');                               -- erwartet: status fehlt
--   select has_function_privilege('anon', 'public.agt_w06_vormerkung_anlegen(text, text, text, text)', 'execute');          -- erwartet: true
--   select has_function_privilege('authenticated', 'public.agt_w06_vormerkung_anlegen(text, text, text, text)', 'execute');  -- erwartet: false
