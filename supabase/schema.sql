create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text,
  display_name text,
  avatar_url text,
  preferred_locale text default 'en',
  notifications_enabled boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.user_bookmarks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  article_url text not null,
  title text,
  description text,
  image_url text,
  content text,
  published_at text,
  source_id text,
  source_name text,
  author text,
  saved_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint user_bookmarks_user_url_key unique (user_id, article_url)
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, display_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'display_name', split_part(new.email, '@', 1))
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute procedure public.set_updated_at();

drop trigger if exists user_bookmarks_set_updated_at on public.user_bookmarks;
create trigger user_bookmarks_set_updated_at
  before update on public.user_bookmarks
  for each row execute procedure public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.user_bookmarks enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles
for select
to authenticated
using ((select auth.uid()) = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles
for insert
to authenticated
with check ((select auth.uid()) = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles
for update
to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

drop policy if exists "bookmarks_select_own" on public.user_bookmarks;
create policy "bookmarks_select_own"
on public.user_bookmarks
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "bookmarks_insert_own" on public.user_bookmarks;
create policy "bookmarks_insert_own"
on public.user_bookmarks
for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "bookmarks_update_own" on public.user_bookmarks;
create policy "bookmarks_update_own"
on public.user_bookmarks
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "bookmarks_delete_own" on public.user_bookmarks;
create policy "bookmarks_delete_own"
on public.user_bookmarks
for delete
to authenticated
using ((select auth.uid()) = user_id);
