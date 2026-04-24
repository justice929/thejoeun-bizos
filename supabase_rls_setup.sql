-- ============================================================
-- 더조은식품 그룹웨어 — Supabase RLS 보안 설정
-- Supabase Dashboard > SQL Editor 에서 전체 실행
-- ============================================================

-- ① cooperation_requests 테이블 생성 (cooperation.html 신규)
CREATE TABLE IF NOT EXISTS cooperation_requests (
    id           BIGSERIAL PRIMARY KEY,
    requester    TEXT NOT NULL,
    recipient_dept TEXT NOT NULL,
    title        TEXT NOT NULL,
    content      TEXT NOT NULL,
    status       TEXT DEFAULT '발송완료',
    created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ② inbound_ledger에 source 컬럼 추가 (결재 자동반영 구분용)
ALTER TABLE inbound_ledger ADD COLUMN IF NOT EXISTS source TEXT DEFAULT '직접입력';

-- ③ outbound_ledger에 온라인 판매 관련 컬럼 추가
ALTER TABLE outbound_ledger ADD COLUMN IF NOT EXISTS platform  TEXT DEFAULT NULL;
ALTER TABLE outbound_ledger ADD COLUMN IF NOT EXISTS order_no  TEXT DEFAULT NULL;

-- ④ product_master에 보관기간(일수) 컬럼 추가
ALTER TABLE product_master ADD COLUMN IF NOT EXISTS shelf_days INTEGER DEFAULT 0;

-- ⑤ 상품 이미지 URL 컬럼
ALTER TABLE product_master ADD COLUMN IF NOT EXISTS image_url TEXT DEFAULT NULL;

-- ⑥ 고객 계정 테이블
CREATE TABLE IF NOT EXISTS customer_accounts (
    id            BIGSERIAL PRIMARY KEY,
    partner_code  TEXT,
    company_name  TEXT NOT NULL,
    auth_email    TEXT UNIQUE NOT NULL,
    contact_name  TEXT,
    contact_phone TEXT,
    parent_id     BIGINT REFERENCES customer_accounts(id),  -- 프랜차이즈 계층 대비
    account_level TEXT DEFAULT '본점',
    is_active     BOOLEAN DEFAULT true,
    created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ⑦ 고객 주문 테이블
CREATE TABLE IF NOT EXISTS customer_orders (
    id            BIGSERIAL PRIMARY KEY,
    customer_id   BIGINT REFERENCES customer_accounts(id),
    company_name  TEXT NOT NULL,
    status        TEXT DEFAULT '접수',
    delivery_date DATE,
    total_amount  NUMERIC DEFAULT 0,
    notes         TEXT,
    items_json    JSONB,
    confirmed_by  TEXT,
    confirmed_at  TIMESTAMPTZ,
    driver_name   TEXT,
    delivered_at  TIMESTAMPTZ,
    created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- RLS
ALTER TABLE customer_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_orders   ENABLE ROW LEVEL SECURITY;

-- 고객 계정: 조회는 전체 직원, 수정/삭제는 관리자만
CREATE POLICY "ca_select_all_auth" ON customer_accounts FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "ca_write_admin"     ON customer_accounts FOR ALL   USING (auth.email() = 'justice@thejoeun.com');
CREATE POLICY "co_staff_all"       ON customer_orders   FOR ALL   USING (auth.role() = 'authenticated');

-- ⑧ 사내 게시판 테이블
CREATE TABLE IF NOT EXISTS board_posts (
    id          BIGSERIAL PRIMARY KEY,
    author      TEXT NOT NULL,
    author_name TEXT,
    dept        TEXT NOT NULL,
    title       TEXT NOT NULL,
    content     TEXT NOT NULL,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS board_comments (
    id          BIGSERIAL PRIMARY KEY,
    post_id     BIGINT REFERENCES board_posts(id) ON DELETE CASCADE,
    author      TEXT NOT NULL,
    author_name TEXT,
    content     TEXT NOT NULL,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ⑥ 직원 관리 테이블
CREATE TABLE IF NOT EXISTS employees (
    id        BIGSERIAL PRIMARY KEY,
    name      TEXT NOT NULL,
    dept      TEXT NOT NULL,
    position  TEXT,
    status    TEXT DEFAULT '재직중',
    phone     TEXT,
    email     TEXT,
    hire_date DATE,
    memo      TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ⑤⑥ RLS 정책
ALTER TABLE board_posts    ENABLE ROW LEVEL SECURITY;
ALTER TABLE board_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees      ENABLE ROW LEVEL SECURITY;

CREATE POLICY "board_posts_select"    ON board_posts    FOR SELECT USING (auth.role()='authenticated');
CREATE POLICY "board_posts_insert"    ON board_posts    FOR INSERT WITH CHECK (auth.email()=author);
CREATE POLICY "board_posts_delete"    ON board_posts    FOR DELETE USING (auth.email()=author OR auth.email()='jungeu0913@naver.com');

CREATE POLICY "board_comments_select" ON board_comments FOR SELECT USING (auth.role()='authenticated');
CREATE POLICY "board_comments_insert" ON board_comments FOR INSERT WITH CHECK (auth.email()=author);
CREATE POLICY "board_comments_delete" ON board_comments FOR DELETE USING (auth.email()=author OR auth.email()='jungeu0913@naver.com');

CREATE POLICY "employees_select_all"  ON employees FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "employees_write_admin" ON employees FOR ALL    USING (auth.email() = 'justice@thejoeun.com');

-- ============================================================
-- RLS 활성화
-- ============================================================
ALTER TABLE expense_reports       ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_orders       ENABLE ROW LEVEL SECURITY;
ALTER TABLE inbound_ledger        ENABLE ROW LEVEL SECURITY;
ALTER TABLE outbound_ledger       ENABLE ROW LEVEL SECURITY;
ALTER TABLE cooperation_requests  ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_master        ENABLE ROW LEVEL SECURITY;
ALTER TABLE partner_master        ENABLE ROW LEVEL SECURITY;
ALTER TABLE account_master        ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- expense_reports 정책
-- ============================================================
-- 모든 로그인 유저: 전체 조회 가능
CREATE POLICY "expense_select_all" ON expense_reports
    FOR SELECT USING (auth.role() = 'authenticated');

-- 본인만 INSERT
CREATE POLICY "expense_insert_own" ON expense_reports
    FOR INSERT WITH CHECK (auth.email() = requester);

-- 본인은 DELETE (기안 취소), 관리자는 UPDATE (승인)
CREATE POLICY "expense_delete_own" ON expense_reports
    FOR DELETE USING (auth.email() = requester);

CREATE POLICY "expense_update_admin" ON expense_reports
    FOR UPDATE USING (auth.email() = 'jungeu0913@naver.com');

-- ============================================================
-- purchase_orders 정책
-- ============================================================
CREATE POLICY "po_select_all" ON purchase_orders
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "po_insert_own" ON purchase_orders
    FOR INSERT WITH CHECK (auth.email() = requester);

CREATE POLICY "po_delete_own" ON purchase_orders
    FOR DELETE USING (auth.email() = requester);

CREATE POLICY "po_update_admin" ON purchase_orders
    FOR UPDATE USING (auth.email() = 'jungeu0913@naver.com');

-- ============================================================
-- inbound_ledger / outbound_ledger 정책
-- ============================================================
CREATE POLICY "inbound_all_auth" ON inbound_ledger
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "outbound_all_auth" ON outbound_ledger
    FOR ALL USING (auth.role() = 'authenticated');

-- ============================================================
-- cooperation_requests 정책
-- ============================================================
CREATE POLICY "coop_select_all" ON cooperation_requests
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "coop_insert_own" ON cooperation_requests
    FOR INSERT WITH CHECK (auth.email() = requester);

CREATE POLICY "coop_delete_own" ON cooperation_requests
    FOR DELETE USING (auth.email() = requester);

-- ============================================================
-- 마스터 데이터 정책 (조회는 전체, 수정은 마스터 계정만)
-- ============================================================
CREATE POLICY "master_select_all" ON product_master
    FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "master_write_admin" ON product_master
    FOR ALL USING (auth.email() = 'justice@thejoeun.com');

CREATE POLICY "partner_select_all" ON partner_master
    FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "partner_write_admin" ON partner_master
    FOR ALL USING (auth.email() = 'justice@thejoeun.com');

CREATE POLICY "account_select_all" ON account_master
    FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "account_write_admin" ON account_master
    FOR ALL USING (auth.email() = 'justice@thejoeun.com');
