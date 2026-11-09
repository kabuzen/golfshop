-- Skema awal Supabase untuk katalog produksi.
create table if not exists public.products (
 id uuid primary key default gen_random_uuid(),
 name text not null,
 description text,
 price numeric(14,2) not null check (price >= 0),
 category text not null,
 image_url text,
 source_url text,
 sales_mode text not null default 'marketplace' check (sales_mode in ('marketplace','direct')),
 is_active boolean not null default true,
 created_at timestamptz not null default now()
);
alter table public.products enable row level security;
create policy "Public can read active products" on public.products
 for select using (is_active = true);
-- Hanya admin terautentikasi melalui kebijakan/role server yang boleh insert/update/delete.
-- Jangan membuat policy write publik. Tambahkan tabel profiles/role dan policy berbasis auth.uid()
-- setelah alur autentikasi admin ditetapkan.
