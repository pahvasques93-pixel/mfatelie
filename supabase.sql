-- MF Ateliê Gestão: tabela única, cada linha é um registro (venda, despesa, produto, material ou os ajustes).
-- Rode este arquivo uma vez em Supabase → SQL Editor → New query → Run.

create table if not exists public.mf_registros (
  user_id       uuid        not null default auth.uid() references auth.users (id) on delete cascade,
  colecao       text        not null check (colecao in ('config', 'materiais', 'produtos', 'vendas', 'despesas')),
  id            text        not null,
  dados         jsonb       not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now(),
  primary key (user_id, colecao, id)
);

-- Cada conta só enxerga e altera as próprias linhas.
alter table public.mf_registros enable row level security;

drop policy if exists "mf_ler"      on public.mf_registros;
drop policy if exists "mf_inserir"  on public.mf_registros;
drop policy if exists "mf_alterar"  on public.mf_registros;
drop policy if exists "mf_excluir"  on public.mf_registros;

create policy "mf_ler"     on public.mf_registros for select to authenticated using ((select auth.uid()) = user_id);
create policy "mf_inserir" on public.mf_registros for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "mf_alterar" on public.mf_registros for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "mf_excluir" on public.mf_registros for delete to authenticated using ((select auth.uid()) = user_id);

-- Mantém a data da última alteração.
create or replace function public.mf_toca() returns trigger language plpgsql set search_path = '' as $$
begin
  new.atualizado_em := now();
  return new;
end $$;

drop trigger if exists mf_toca on public.mf_registros;
create trigger mf_toca before update on public.mf_registros for each row execute function public.mf_toca();
