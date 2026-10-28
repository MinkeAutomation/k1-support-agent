-- 003_agt_w06_auftraege_tickets.sql
-- Zwei Tabellen fuer die Werkzeuge Auftragsstand und Teamvormerkung:
--   agt_w06_orders  : erfundene K1-Auftraege (Testdaten, keine echten Kunden), fuer anon nur lesbar
--   agt_w06_tickets : Support-Tickets, die der Agent anlegt; auf die Tabelle selbst hat anon kein Recht
-- Die Funktionen dazu stehen in 005 (lesen) und 006 (Ticket anlegen). Kein Werkzeug bekommt den Schluessel der Rolle service_role.

begin;

create table if not exists public.agt_w06_orders (
  order_no        text primary key check (order_no ~ '^[0-9]{5}$'),
  customer_label  text not null,
  product         text not null,
  status          text not null
                  check (status in ('eingegangen', 'in_erstellung', 'wartet_auf_freigabe', 'freigegeben', 'abgelegt', 'storniert')),
  status_note     text not null,
  expected_on     date,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

alter table public.agt_w06_orders enable row level security;
revoke all on public.agt_w06_orders from anon, authenticated;
grant select on public.agt_w06_orders to anon;
drop policy if exists "anon liest Testauftraege" on public.agt_w06_orders;
create policy "anon liest Testauftraege" on public.agt_w06_orders
  for select to anon using (true);

insert into public.agt_w06_orders (order_no, customer_label, product, status, status_note, expected_on) values
  ('24001', 'Testkunde A (fiktiv)', 'Social-Media-Paket, 5 Beitraege', 'wartet_auf_freigabe', 'Die Vorschau liegt seit 26.10.2026 in Telegram und wartet auf deine Freigabe.', '2026-10-28'),
  ('24002', 'Testkunde B (fiktiv)', 'Social-Media-Paket, 3 Beitraege', 'in_erstellung', 'Recherche und Texte laufen, die Vorschau kommt voraussichtlich am 28.10.2026.', '2026-10-28'),
  ('24003', 'Testkunde C (fiktiv)', 'Social-Media-Paket, 5 Beitraege', 'abgelegt', 'Freigegeben am 24.10.2026 und im Kundenordner abgelegt.', null),
  ('24004', 'Testkunde D (fiktiv)', 'Einzelbild mit LinkedIn-Post', 'storniert', 'Auf Wunsch storniert am 22.10.2026.', null),
  ('24005', 'Testkunde E (fiktiv)', 'Social-Media-Paket, 3 Beitraege', 'eingegangen', 'Der Auftrag ist am 27.10.2026 eingegangen, die Erstellung startet als Naechstes.', '2026-10-29')
on conflict (order_no) do nothing;

create sequence if not exists public.agt_w06_ticket_seq start 1001;

create table if not exists public.agt_w06_tickets (
  id            bigint generated always as identity primary key,
  ticket_no     text not null unique default ('K1-T-' || lpad(nextval('public.agt_w06_ticket_seq')::text, 5, '0')),
  created_at    timestamptz not null default now(),
  category      text not null
                check (category in ('auftrag', 'gestaltung', 'ablage', 'freigabe', 'technik', 'sonstiges')),
  summary       text not null check (char_length(summary) between 5 and 1000),
  order_no      text,
  session_id    text,
  status        text not null default 'offen' check (status in ('offen', 'in_bearbeitung', 'erledigt'))
);

alter table public.agt_w06_tickets enable row level security;
revoke all on public.agt_w06_tickets from anon, authenticated;
revoke all on sequence public.agt_w06_ticket_seq from public, anon, authenticated;

comment on table public.agt_w06_orders is 'K1 Support-Agent: erfundene Testauftraege, fuer anon nur lesbar.';
comment on table public.agt_w06_tickets is 'K1 Support-Agent: Support-Tickets, Anlegen nur ueber agt_w06_vormerkung_anlegen.';

commit;

-- Kontrolle (SQL-Editor), erwartet: true, false, false
--   select has_table_privilege('anon', 'public.agt_w06_orders', 'select') as orders_select,
--          has_table_privilege('anon', 'public.agt_w06_orders', 'insert,update,delete') as orders_write,
--          has_table_privilege('anon', 'public.agt_w06_tickets', 'select,insert,update,delete') as tickets_any;
