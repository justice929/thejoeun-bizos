// ============================================================
// utils.js — 더조은식품 그룹웨어 공통 모듈
// Supabase 초기화, 초성 검색 엔진, 공통 상수
// ============================================================

const SUPABASE_URL = 'https://beztuwponzoxutokkjtv.supabase.co';
const SUPABASE_KEY = 'sb_publishable_XLUv4Tdq8BHLPluQ4uDXJA_0pL50TiV';
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

// ERP 마스터 계정 (삭제 권한 등)
const MASTER_ID = 'justice@thejoeun.com';
// 결재 최고 승인자
const 최고관리자계정 = 'jungeu0913@naver.com';

// ── 초성 검색 엔진 ──────────────────────────────────────────
const 초성_배열 = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"];

function 초성추출(str) {
    let result = "";
    for (let i = 0; i < str.length; i++) {
        const code = str.charCodeAt(i) - 44032;
        result += (code > -1 && code < 11172)
            ? 초성_배열[Math.floor(code / 588)]
            : str.charAt(i);
    }
    return result;
}

// 배열에서 초성+전체 매칭 검색. keyField가 없으면 배열 원소가 문자열이라고 가정.
function 초성검색(목록, keyword, keyField = null) {
    const kw = keyword.toLowerCase().replace(/\s/g, '');
    if (!kw) return 목록;
    const cho = 초성추출(kw);
    return 목록.filter(item => {
        const str = (keyField ? (item[keyField] || '') : item)
            .toLowerCase().replace(/\s/g, '');
        return str.includes(kw) || 초성추출(str).includes(cho);
    });
}
