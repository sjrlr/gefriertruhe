-- Gefriertruhe: einmal im Supabase SQL-Editor ausführen ("Run")

create table if not exists public.items (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  category    text not null default 'sonstiges',
  frozen_at   date not null default current_date,
  amount      text not null default '',
  created_at  timestamptz not null default now(),
  created_by  uuid default auth.uid() references auth.users(id) on delete set null
);

-- Nur eingeloggte Benutzer (also ihr zwei) dürfen lesen und schreiben
alter table public.items enable row level security;

drop policy if exists "Eingeloggte duerfen alles" on public.items;
create policy "Eingeloggte duerfen alles"
  on public.items for all
  to authenticated
  using (true)
  with check (true);

-- Live-Synchronisierung zwischen den Handys
alter publication supabase_realtime add table public.items;
