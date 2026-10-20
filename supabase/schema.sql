-- Fast NFT Courier initial schema. Review policies before production use.
create extension if not exists pgcrypto;
create type public.shipment_status as enum ('created','label_created','picked_up','in_transit','out_for_delivery','delivered','exception','cancelled');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'customer' check (role in ('customer','staff','admin')),
  created_at timestamptz not null default now()
);
create table public.shipments (
  id uuid primary key default gen_random_uuid(),
  tracking_number text not null unique,
  customer_id uuid references auth.users(id) on delete set null,
  recipient_name text,
  origin text not null,
  destination text not null,
  status public.shipment_status not null default 'created',
  estimated_delivery date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table public.tracking_events (
  id uuid primary key default gen_random_uuid(),
  shipment_id uuid not null references public.shipments(id) on delete cascade,
  status public.shipment_status not null,
  location text not null,
  description text not null,
  event_time timestamptz not null default now(),
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);
create table public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references auth.users(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
create index shipments_customer_id_idx on public.shipments(customer_id);
create index tracking_events_shipment_time_idx on public.tracking_events(shipment_id,event_time desc);
create index shipments_status_idx on public.shipments(status);

alter table public.profiles enable row level security;
alter table public.shipments enable row level security;
alter table public.tracking_events enable row level security;
alter table public.audit_logs enable row level security;

create or replace function public.current_user_role()
returns text language sql stable security definer set search_path = public
as $$ select role from public.profiles where id = auth.uid() $$;

create policy "profiles_read_self_or_staff" on public.profiles for select to authenticated
using (id = auth.uid() or public.current_user_role() in ('staff','admin'));
create policy "shipments_read_own_or_staff" on public.shipments for select to authenticated
using (customer_id = auth.uid() or public.current_user_role() in ('staff','admin'));
create policy "events_read_own_or_staff" on public.tracking_events for select to authenticated
using (exists (select 1 from public.shipments s where s.id = shipment_id and (s.customer_id = auth.uid() or public.current_user_role() in ('staff','admin'))));
create policy "audit_admin_read" on public.audit_logs for select to authenticated
using (public.current_user_role() = 'admin');

-- IMPORTANT: don't enable anonymous table reads for public tracking.
-- Add a server-side tracking endpoint with rate limiting, anti-enumeration controls,
-- and a minimal approved response. Protect all writes with server-verified roles and
-- audit logging. Never let users assign their own staff/admin role.
