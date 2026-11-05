-- 020_agt_w07_answer_chain_results.sql (05.11.2026, W07T04, K1 Antwort-Kette v10)
-- Ausfuehren: einmal im Supabase SQL-Editor, mehrfaches Ausfuehren schadet nicht (if not exists).
-- Ergebnistabelle des A/B-Tests: je Zeile 1 Ticket, 1 Variante (A oder B), 1 Lauf.
-- Nur erfundene Testtickets, keine Personendaten. Entwurf der Tabelle: flach, weil nur der Workflow
-- schreibt, niemand verknuepft liest und kein Stammdatum doppelt vorkommt. Row Level Security an, kein Policy: nur der Service-Zugang
-- des Workflows (BYPASSRLS) schreibt und liest, anon und authenticated sehen nichts. Erwartete Zeilen: 10 Tickets x 2 Varianten x 3 Laeufe = 60.
begin;

create table if not exists public.agt_w07_answer_chain_results (
  id                  bigint generated always as identity primary key,
  created_at          timestamptz not null default now(),
  execution_id        text not null,
  series              text not null default 'test',
  run_no              smallint not null check (run_no between 1 and 9),
  variant             text not null check (variant in ('A', 'B')),
  ticket_no           smallint not null check (ticket_no between 1 and 10),
  ticket_category     text not null check (ticket_category in ('normal', 'edge', 'error')),
  ticket_text         text not null,
  baseline            text not null,
  workflow_version    text not null,
  prompt_version      text not null,
  stage_model         text not null,
  judge_model         text not null,
  draft_answer        text,
  final_answer        text,
  tools_used          text,
  tool_calls          smallint,
  code_flags          text,
  draft_correctness   smallint check (draft_correctness between 1 and 5),
  draft_relevance     smallint check (draft_relevance between 1 and 5),
  draft_completeness  smallint check (draft_completeness between 1 and 5),
  draft_safety        smallint check (draft_safety between 1 and 5),
  final_correctness   smallint check (final_correctness between 1 and 5),
  final_relevance     smallint check (final_relevance between 1 and 5),
  final_completeness  smallint check (final_completeness between 1 and 5),
  final_safety        smallint check (final_safety between 1 and 5),
  judge_status        text not null default 'ok' check (judge_status in ('ok', 'invalid', 'skipped')),
  judge_notes         text,
  status              text not null default 'ok' check (status in ('ok', 'error')),
  error_text          text,
  tokens_stage1_est   integer,
  tokens_stage2_est   integer,
  tokens_judge_est    integer,
  cost_usd_shadow_est numeric(10, 6),
  duration_ms         integer,
  hand_correctness    smallint check (hand_correctness between 1 and 5),
  hand_relevance      smallint check (hand_relevance between 1 and 5),
  hand_completeness   smallint check (hand_completeness between 1 and 5),
  hand_safety         smallint check (hand_safety between 1 and 5),
  hand_note           text
);

create unique index if not exists ux_agt_w07_acr_exec_variant_ticket
  on public.agt_w07_answer_chain_results (execution_id, variant, ticket_no);
create index if not exists idx_agt_w07_acr_series_variant
  on public.agt_w07_answer_chain_results (series, variant);

alter table public.agt_w07_answer_chain_results enable row level security;

comment on table public.agt_w07_answer_chain_results is
  'W07T04 K1 Antwort-Kette v10: Ergebniszeilen des A/B-Tests (nur erfundene Testtickets). Tokens und Schattenkosten sind aus der Zeichenzahl geschaetzt.';

commit;

select count(*) as zeilen from public.agt_w07_answer_chain_results;
