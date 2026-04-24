// sidebar.js — 더조은식품 그룹웨어 공통 네비게이션

function 사이드바_그리기() {
    const 현재페이지 = window.location.pathname.split('/').pop() || 'dashboard.html';

    const 메뉴목록 = [
        { isHeader: true, name: '👑 Executive (경영 & 통계)' },
        { id: 'dashboard', name: '🏠 통합 대시보드', link: 'dashboard.html' },
        { id: 'stats', name: '📊 재무 통계 인사이트', link: 'stats.html' },

        { isHeader: true, name: '📝 Groupware (전자 품의)' },
        { id: 'index', name: '💸 지출 결의서', link: 'index.html' },
        { id: 'purchase', name: '🛒 매입 요청서 (발주)', link: 'purchase.html' },
        { id: 'cooperation', name: '📨 협조문', link: 'cooperation.html' },
        { id: 'board', name: '📋 사내 게시판', link: 'board.html' },

        { isHeader: true, name: '🛒 고객 발주 관리' },
        { id: 'orders',   name: '📋 주문 접수 관리', link: 'orders.html' },
        { id: 'delivery', name: '🚚 출고지시서 & 배송', link: 'delivery.html' },

        { isHeader: true, name: '👥 HR (인사 관리)' },
        { id: 'employees', name: '👤 직원 관리', link: 'employees.html' },

        { isHeader: true, name: '📦 Core ERP (물류 & 장부)' },
        { id: 'inbound', name: '📥 스마트 매입 장부', link: 'inbound.html' },
        { id: 'outbound', name: '💸 스마트 매출 장부', link: 'outbound.html' },
        { id: 'inventory', name: '📊 실시간 재고 상황판', link: 'inventory.html' },

        { isHeader: true, name: '⚙️ Master Data (기본 정보)' },
        { id: 'product_master',    name: '🏷️ 상품 마스터',    link: 'product.html' },
        { id: 'partner_master',    name: '🤝 거래처 마스터',   link: 'partner.html' },
        { id: 'account_master',    name: '📂 계정과목 마스터', link: 'account.html' },
        { id: 'customer_accounts', name: '🏢 고객사 계정',     link: 'customer_accounts.html' }
    ];

    // ── 데스크톱 사이드바 ──────────────────────────────────
    let 메뉴HTML = '';
    메뉴목록.forEach(메뉴 => {
        if (메뉴.isHeader) {
            메뉴HTML += `<div class="mt-8 mb-3 px-4"><p class="text-[10px] font-black text-knight-blue bg-[#B8D200] inline-block px-3 py-1.5 rounded-md uppercase tracking-widest shadow-sm">${메뉴.name}</p></div>`;
        } else {
            const isActive = 현재페이지 === 메뉴.link;
            메뉴HTML += isActive
                ? `<a href="${메뉴.link}" class="flex items-center space-x-3 py-3 px-4 rounded-xl bg-white/10 font-bold border-l-4 border-[#B8D200] text-white transition-all shadow-md"><span>${메뉴.name}</span></a>`
                : `<a href="${메뉴.link}" class="flex items-center space-x-3 py-3 px-4 rounded-xl hover:bg-white/5 transition text-gray-300 hover:text-white"><span class="font-bold">${메뉴.name}</span></a>`;
        }
    });

    // ── 모바일 하단 탭바 (핵심 5개) ───────────────────────
    const 탭메뉴 = [
        { link: 'dashboard.html', icon: `<svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>`, label: '홈' },
        { link: 'index.html',     icon: `<svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 14l6-6m-5.5.5h.01m4.99 5h.01M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16l3.5-2 3.5 2 3.5-2 3.5 2z"/></svg>`, label: '지출' },
        { link: 'purchase.html',  icon: `<svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/></svg>`, label: '발주' },
        { link: 'inbound.html',   icon: `<svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>`, label: '매입' },
        { link: 'inventory.html', icon: `<svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>`, label: '재고' },
    ];

    let 탭HTML = '';
    탭메뉴.forEach(탭 => {
        const isActive = 현재페이지 === 탭.link;
        const color = isActive ? 'text-[#152484]' : 'text-gray-400';
        const dot = isActive ? '<span class="absolute top-1 left-1/2 -translate-x-1/2 w-1 h-1 bg-[#B8D200] rounded-full"></span>' : '';
        탭HTML += `
        <a href="${탭.link}" class="relative flex-1 flex flex-col items-center justify-center pt-2 pb-1 gap-0.5 ${color} transition-colors">
            ${dot}
            ${탭.icon}
            <span class="text-[10px] font-black">${탭.label}</span>
        </a>`;
    });

    const 전체HTML = `
    <aside class="hidden md:flex w-64 bg-[#152484] text-white flex-col fixed h-full shadow-2xl z-40 overflow-y-auto" style="--knight-blue:#152484;">
        <div class="p-6 flex flex-col h-full">
            <div class="mb-8 italic">
                <p class="text-[10px] font-bold text-[#B8D200] tracking-widest uppercase">The Joeun Food Biz-OS</p>
                <h1 class="text-3xl font-black tracking-tighter mt-1">정의의 기사</h1>
            </div>
            <nav class="space-y-1 flex-1 pb-6">
                ${메뉴HTML}
            </nav>
            <div class="pt-4 border-t border-white/10">
                <button onclick="사이드바_로그아웃()" class="w-full flex items-center gap-3 py-3 px-4 rounded-xl hover:bg-red-500/20 transition text-red-300 hover:text-red-200 font-bold text-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                    </svg>
                    로그아웃
                </button>
            </div>
        </div>
    </aside>

    <nav class="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 z-50 flex items-stretch h-16 shadow-[0_-4px_20px_rgba(0,0,0,0.08)]">
        ${탭HTML}
    </nav>
    `;

    const container = document.getElementById('sidebar-container');
    if (container) container.innerHTML = 전체HTML;
}

async function 사이드바_로그아웃() {
    if (!confirm("로그아웃 하시겠습니까?")) return;
    localStorage.removeItem('autoLogin');
    await supabaseClient.auth.signOut();
    window.location.href = 'login.html';
}

document.addEventListener('DOMContentLoaded', 사이드바_그리기);
