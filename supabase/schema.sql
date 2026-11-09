create extension if not exists pgcrypto;
create table if not exists public.profiles(id uuid primary key references auth.users(id) on delete cascade, display_name text, role text not null default 'editor' check(role in ('admin','editor')), created_at timestamptz default now());
create or replace function public.current_role() returns text language sql stable security definer set search_path=public as $$ select role from public.profiles where id=auth.uid() $$;
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$ select coalesce(public.current_role()='admin',false) $$;
create table if not exists public.products(id uuid primary key default gen_random_uuid(),name text not null,price numeric(14,2) not null default 0 check(price>=0),category text not null,sales_type text not null default 'marketplace',image_url text,source_url text,description text,is_active boolean not null default true,created_by uuid references auth.users(id),created_at timestamptz default now());
create table if not exists public.articles(id uuid primary key default gen_random_uuid(),title text not null,category text not null,author text,image_url text,excerpt text not null,body text not null,status text not null default 'draft' check(status in ('draft','review','published')),created_by uuid references auth.users(id),created_at timestamptz default now(),published_at timestamptz);
create table if not exists public.orders(id uuid primary key default gen_random_uuid(),customer_name text not null,customer_email text,status text not null default 'pending',total numeric(14,2) not null check(total>=0),payment_reference text,created_at timestamptz default now());
alter table public.profiles enable row level security; alter table public.products enable row level security; alter table public.articles enable row level security; alter table public.orders enable row level security;
create policy "profile self or admin read" on public.profiles for select to authenticated using(id=auth.uid() or public.is_admin());
create policy "admin profiles manage" on public.profiles for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "public active products" on public.products for select to anon,authenticated using(is_active);
create policy "staff all products" on public.products for select to authenticated using(public.current_role() in ('admin','editor'));
create policy "staff insert products" on public.products for insert to authenticated with check(public.current_role() in ('admin','editor') and created_by=auth.uid());
create policy "staff update products" on public.products for update to authenticated using(public.current_role() in ('admin','editor')) with check(public.current_role() in ('admin','editor'));
create policy "admin delete products" on public.products for delete to authenticated using(public.is_admin());
create policy "public published articles" on public.articles for select to anon,authenticated using(status='published');
create policy "staff all articles" on public.articles for select to authenticated using(public.current_role() in ('admin','editor'));
create policy "staff insert articles" on public.articles for insert to authenticated with check(public.current_role() in ('admin','editor') and created_by=auth.uid());
create policy "staff update articles" on public.articles for update to authenticated using(public.current_role() in ('admin','editor')) with check(public.current_role() in ('admin','editor'));
create policy "admin delete articles" on public.articles for delete to authenticated using(public.is_admin());
create policy "admin read orders" on public.orders for select to authenticated using(public.is_admin());
-- Setelah membuat user admin di Authentication > Users, salin UUID-nya lalu:
-- insert into public.profiles(id,display_name,role) values ('UUID-ADMIN','Administrator GolfShop','admin');
-- Untuk editor: undang melalui Supabase Auth, lalu insert profil dengan role 'editor'.
