-- ============================================================
-- RLS 보안 강화 패치 — Supabase SQL Editor에서 실행
-- 대상: employees / partner_master / account_master / customer_accounts
-- ============================================================

-- ① employees: 조회는 전체 직원, 수정/삭제는 관리자만
DROP POLICY IF EXISTS "employees_write_all" ON employees;
CREATE POLICY "employees_write_admin" ON employees
    FOR ALL USING (auth.email() = 'justice@thejoeun.com');

-- ② partner_master: 조회는 전체 직원, 수정/삭제는 관리자만
DROP POLICY IF EXISTS "partner_write_all_auth" ON partner_master;
CREATE POLICY "partner_write_admin" ON partner_master
    FOR ALL USING (auth.email() = 'justice@thejoeun.com');

-- ③ account_master: 조회는 전체 직원, 수정/삭제는 관리자만
DROP POLICY IF EXISTS "account_write_all_auth" ON account_master;
CREATE POLICY "account_write_admin" ON account_master
    FOR ALL USING (auth.email() = 'justice@thejoeun.com');

-- ④ customer_accounts: 조회는 전체 직원, 수정/삭제는 관리자만
DROP POLICY IF EXISTS "ca_staff_all" ON customer_accounts;
CREATE POLICY "ca_select_all_auth" ON customer_accounts
    FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "ca_write_admin" ON customer_accounts
    FOR ALL USING (auth.email() = 'justice@thejoeun.com');
