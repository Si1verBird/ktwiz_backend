CREATE TYPE game_status AS ENUM ('scheduled', 'live', 'ended');
CREATE TYPE order_status AS ENUM ('pending', 'paid', 'failed', 'canceled');
CREATE TYPE ticket_status AS ENUM ('valid', 'used', 'refunded');
CREATE TYPE post_category AS ENUM ('news', 'story', 'photo', 'highlight', 'live');
CREATE TYPE post_status AS ENUM ('draft', 'published', 'archived');
CREATE TYPE chat_role AS ENUM ('user', 'assistant', 'admin');

CREATE TABLE venues (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR NOT NULL UNIQUE,
  location VARCHAR,
  capacity INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR NOT NULL UNIQUE,
  short_name VARCHAR,
  venue_id UUID NOT NULL REFERENCES venues(id),
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR NOT NULL UNIQUE,
  password_hash VARCHAR NOT NULL,
  nickname VARCHAR NOT NULL,
  is_admin BOOLEAN NOT NULL DEFAULT false,
  last_login_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP
);

CREATE TABLE games (
  id UUID PRIMARY KEY,
  date_time TIMESTAMP NOT NULL,
  home_team_id UUID NOT NULL REFERENCES teams(id),
  away_team_id UUID NOT NULL REFERENCES teams(id),
  status game_status NOT NULL DEFAULT 'scheduled',
  inning INT NOT NULL DEFAULT 0,
  home_score INT NOT NULL DEFAULT 0,
  away_score INT NOT NULL DEFAULT 0,
  ticket_price INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP
);

CREATE TABLE team_standings (
  team_id UUID PRIMARY KEY REFERENCES teams(id),
  games_played INT NOT NULL DEFAULT 0,
  wins INT NOT NULL DEFAULT 0,
  losses INT NOT NULL DEFAULT 0,
  win_rate FLOAT NOT NULL DEFAULT 0.0,
  rank INT,
  updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE orders (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  game_id UUID NOT NULL REFERENCES games(id),
  unit_price INT NOT NULL DEFAULT 0,
  amount INT NOT NULL DEFAULT 0,
  status order_status NOT NULL DEFAULT 'pending',
  paid_at TIMESTAMP,
  pg_provider VARCHAR,
  pg_tx_id VARCHAR,
  pg_payload TEXT,
  receipt_url VARCHAR,
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP
);

CREATE TABLE tickets (
  id UUID PRIMARY KEY,
  order_id UUID NOT NULL REFERENCES orders(id),
  voucher_code VARCHAR NOT NULL UNIQUE,
  issued_at TIMESTAMP NOT NULL DEFAULT now(),
  status ticket_status NOT NULL
);

CREATE TABLE posts (
  id UUID PRIMARY KEY,
  category post_category NOT NULL,
  title VARCHAR,
  body TEXT,
  thumbnail VARCHAR,
  images TEXT,
  video_url VARCHAR,
  status post_status NOT NULL,
  slug VARCHAR NOT NULL UNIQUE,
  author_id UUID NOT NULL REFERENCES users(id),
  deleted BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP
);

CREATE TABLE chats (
  id UUID PRIMARY KEY,
  session_id UUID NOT NULL,
  user_id UUID REFERENCES users(id),
  role chat_role NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);



-- games
CREATE INDEX idx_games_date_time ON games(date_time);
CREATE INDEX idx_games_status ON games(status);

-- orders
CREATE INDEX idx_orders_user_created_at ON orders(user_id, created_at);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_pg_tx_id ON orders(pg_tx_id);

-- posts
CREATE INDEX idx_posts_category_status_created ON posts(category, status, created_at);

-- chats
CREATE INDEX idx_chats_session_created ON chats(session_id, created_at);