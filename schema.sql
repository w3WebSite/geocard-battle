-- Habilitar extensión UUID si no está activa
create extension if not exists "uuid-ossp";

-- 1. Tabla de Salas / Partidas
create table rooms (
  code text primary key,
  active boolean default false,
  winner text,
  red_score int default 0,
  blue_score int default 0,
  start_time timestamp with time zone,
  duration int,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Tabla de Geocaches (con cartas en vez de preguntas)
create table geocaches (
  id uuid default uuid_generate_v4() primary key,
  room_code text references rooms(code) on delete cascade,
  lat double precision not null,
  lng double precision not null,
  claimed boolean default false,
  team text,
  card_name text not null,
  card_type text not null, -- Ej: 'Agua', 'Fuego', 'Tierra'
  attack int not null,
  defense int not null,
  image_url text
);

-- 3. Inventario de Cartas de los Jugadores / Equipos
create table player_cards (
  id uuid default uuid_generate_v4() primary key,
  room_code text references rooms(code) on delete cascade,
  team text not null, -- 'red' o 'blue'
  user_email text not null,
  card_name text not null,
  attack int not null,
  defense int not null,
  image_url text,
  acquired_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. Chat Global
create table messages (
  id uuid default uuid_generate_v4() primary key,
  room_code text references rooms(code) on delete cascade,
  user_email text not null,
  text text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);