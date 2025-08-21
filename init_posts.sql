

-- 아래는 초기값 인서트 함수 모음임--
  -- 먼저 삭제 진행 : 외래키 관계 때문에 삭제 순서를 지켜야 함
DELETE FROM chats;
DELETE FROM tickets;
DELETE FROM orders;
DELETE FROM games;
DELETE FROM team_standings;
DELETE FROM posts;
DELETE FROM users;
DELETE FROM teams;
DELETE FROM venues;


-- 1. VENUES
INSERT INTO venues (id, name, location, capacity)
VALUES 
  ('10000000-0000-0000-0000-000000000001', '서울종합운동장 야구장', '서울', 25000),
  ('10000000-0000-0000-0000-000000000002', '대구삼성라이온즈파크', '대구', 24000),
  ('10000000-0000-0000-0000-000000000003', '광주기아챔피언스필드', '광주', 22000),
  ('10000000-0000-0000-0000-000000000004', '사직야구장', '부산', 26000),
  ('10000000-0000-0000-0000-000000000005', '인천SSG랜더스필드', '인천', 25000),
  ('10000000-0000-0000-0000-000000000006', '창원NC파크', '창원', 23000),
  ('10000000-0000-0000-0000-000000000007', '고척스카이돔', '서울', 17000),
  ('10000000-0000-0000-0000-000000000008', '수원kt위즈파크', '수원', 20000),
  ('10000000-0000-0000-0000-000000000009', '대전한화생명이글스파크', '대전', 21000);

-- 2. TEAMS
INSERT INTO teams (id, name, short_name, venue_id)
VALUES 
  ('20000000-0000-0000-0000-000000000001', '두산 베어스', '두산', '10000000-0000-0000-0000-000000000001'),
  ('20000000-0000-0000-0000-000000000002', '삼성 라이온즈', '삼성', '10000000-0000-0000-0000-000000000002'),
  ('20000000-0000-0000-0000-000000000003', 'KIA 타이거즈', 'KIA', '10000000-0000-0000-0000-000000000003'),
  ('20000000-0000-0000-0000-000000000004', '롯데 자이언츠', '롯데', '10000000-0000-0000-0000-000000000004'),
  ('20000000-0000-0000-0000-000000000005', 'SSG 랜더스', 'SSG', '10000000-0000-0000-0000-000000000005'),
  ('20000000-0000-0000-0000-000000000006', 'NC 다이노스', 'NC', '10000000-0000-0000-0000-000000000006'),
  ('20000000-0000-0000-0000-000000000007', '키움 히어로즈', '키움', '10000000-0000-0000-0000-000000000007'),
  ('20000000-0000-0000-0000-000000000008', 'kt 위즈', 'kt', '10000000-0000-0000-0000-000000000008'),
  ('20000000-0000-0000-0000-000000000009', '한화 이글스', '한화', '10000000-0000-0000-0000-000000000009'),
('20000000-0000-0000-0000-000000000010', 'LG 트윈스', '한화', '10000000-0000-0000-0000-000000000001');

-- 3. USERS
INSERT INTO users (id, email, password, nickname, is_admin)
VALUES 
  ('30000000-0000-0000-0000-000000000001', 'admin@example.com', 'admin123', '관리자', true),
  ('30000000-0000-0000-0000-000000000002', 'user1@example.com', 'user1123', '유저1', false),
  ('30000000-0000-0000-0000-000000000003', 'user2@example.com', 'user2123', '유저2', false);

-- 4. GAMES
-- games 테이블 초기 데이터 삽입
-- 필요 시: CREATE EXTENSION IF NOT EXISTS pgcrypto;

WITH
params AS (
  SELECT
    ARRAY[
    '20000000-0000-0000-0000-000000000001'::uuid,
	'20000000-0000-0000-0000-000000000002'::uuid,
	'20000000-0000-0000-0000-000000000003'::uuid,
	'20000000-0000-0000-0000-000000000004'::uuid,
	'20000000-0000-0000-0000-000000000005'::uuid,
	'20000000-0000-0000-0000-000000000006'::uuid,
	'20000000-0000-0000-0000-000000000007'::uuid,
	'20000000-0000-0000-0000-000000000009'::uuid,
	'20000000-0000-0000-0000-000000000008'::uuid,
	'20000000-0000-0000-0000-000000000010'::uuid
    ] AS team_ids,
    TIMESTAMP '2025-04-01 18:30:00'           AS season_start,
    122                                       AS season_days  -- 4~7월 일수(4/1~7/31)
),
g AS (
  SELECT generate_series(0, 399) AS n
)
INSERT INTO games (
  id, date_time, home_team_id, away_team_id, status,
  inning, home_score, away_score, ticket_price,
  created_at, updated_at
)
SELECT
  gen_random_uuid() AS id,
  -- 4/1 기준으로 날짜 순환 + 시작 시간 18:30 + 가벼운 분산(30분 단위)
  (SELECT season_start FROM params)
    + ((n % (SELECT season_days FROM params)) * INTERVAL '1 day')
    + ((n % 3) * INTERVAL '30 minutes')         AS date_time,
  -- 팀 배열에서 순환 선택(서로 다른 팀이 되도록 인덱스를 어긋나게)
  (SELECT team_ids[(n % array_length(team_ids,1)) + 1] FROM params)                 AS home_team_id,
  (SELECT team_ids[((n + 1) % array_length(team_ids,1)) + 1] FROM params)           AS away_team_id,
  'ended'                                                                            AS status,
  9 + (n % 3)                                                                        AS inning,        -- 9~11회
  (n * 7) % 13                                                                       AS home_score,    -- 0~12 분포
  (n * 11) % 13                                                                      AS away_score,    -- 0~12 분포
  20000 + ((n % 5) * 5000)                                                           AS ticket_price,  -- 20,000~40,000
  now()::timestamp                                                                   AS created_at,
  NULL::timestamp                                                                    AS updated_at
FROM g;



-- 5. ORDERS
INSERT INTO orders (id, user_id, game_id, unit_price, amount, status, paid_at, pg_provider, pg_tx_id, pg_payload, receipt_url)
VALUES 
  ('50000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000002', '40000000-0000-0000-0000-000000000001', 15000, 2, 'paid', now(), 'KakaoPay', 'tx123abc', '{}', 'https://receipt.com/tx123abc');

-- 6. TICKETS
INSERT INTO tickets (id, order_id, voucher_code, status)
VALUES 
  ('60000000-0000-0000-0000-000000000001', '50000000-0000-0000-0000-000000000001', 'TICKET-ABC123', 'valid'),
  ('60000000-0000-0000-0000-000000000002', '50000000-0000-0000-0000-000000000001', 'TICKET-DEF456', 'valid');

-- 7. POSTS
INSERT INTO posts (id, category, title, body, status, slug, author_id)
VALUES 
  ('70000000-0000-0000-0000-000000000001', 'news', '개막전 대진 안내', '개막전 일정 및 티켓 정보 안내', 'published', 'opening-match-news', '30000000-0000-0000-0000-000000000001');

-- 8. CHATS
INSERT INTO chats (id, session_id, user_id, role, message)
VALUES 
  ('80000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '30000000-0000-0000-0000-000000000002', 'user', '내일 경기 몇 시에 시작하나요?'),
  ('80000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '30000000-0000-0000-0000-000000000001', 'admin', '내일 경기는 오후 6시 30분에 시작됩니다.');
