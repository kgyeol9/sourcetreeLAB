// /resources/js/itemDB.js
(function () {
  /* ===== 전역 노출 필요 함수 ===== */
  let selectedSlot = "A"; // 비교 기본 슬롯

  function toggleDetail(row) {
    const detail = row.nextElementSibling;
    if (!detail || !detail.classList.contains("detail")) return;

    if (detail.classList.contains("open")) {
      detail.classList.remove("open");
      detail.style.maxHeight = "0";
    } else {
      detail.classList.add("open");
      detail.style.maxHeight = detail.scrollHeight + "px";
    }
  }
  window.toggleDetail = toggleDetail;

  function addToCompare(e, btn) {
    if (e) e.stopPropagation();

    const wrap =
      btn.closest("[data-name]") ||
      btn.closest(".r") ||
      btn.closest(".item-card");
    if (!wrap) return;

    const name =
      wrap.dataset.name ||
      (wrap.querySelector(".name-text")?.textContent ||
        wrap.querySelector(".ic-title")?.textContent ||
        "").trim();

    // 이미지 src: data-img 우선, 없으면 DOM에서 첫 번째 img
    const imgSrc =
      wrap.dataset.img ||
      (wrap.querySelector("img")?.getAttribute("src")) ||
      "";

    // 공통 데이터 수집 (없으면 빈문자/0)
    const data = {
      name,
      img: imgSrc,
      quality: wrap.dataset.quality || "",
      category: wrap.dataset.category || "",
      job: wrap.dataset.job || "",
      obtain: wrap.dataset.obtain || "",
      minatk: wrap.dataset.minatk ?? "0",
      maxatk: wrap.dataset.maxatk ?? "0",
      addatk: wrap.dataset.addatk ?? "0",
      accuracy: wrap.dataset.accuracy ?? "0",
      critical: wrap.dataset.critical ?? "0",
    };

    if (selectedSlot === "A") {
      const slotA = document.getElementById("slotA");
      const slotALabel = document.getElementById("slotALabel");
      if (slotA && slotALabel) {
        slotA.dataset.info = JSON.stringify(data);
        slotALabel.innerText = name;
        renderSlot(slotA, data);
      }
    } else {
      const slotB = document.getElementById("slotB");
      const slotBLabel = document.getElementById("slotBLabel");
      if (slotB && slotBLabel) {
        slotB.dataset.info = JSON.stringify(data);
        slotBLabel.innerText = name;
        renderSlot(slotB, data);
      }
    }
    updateCompare();
  }
  window.addToCompare = addToCompare;

  function updateCompare() {
    const slotA = document.getElementById("slotA");
    const slotB = document.getElementById("slotB");
    if (!slotA || !slotB) return;

    const aInfo = slotA.dataset.info;
    const bInfo = slotB.dataset.info;
    if (!aInfo || !bInfo) return;

    const A = JSON.parse(aInfo);
    const B = JSON.parse(bInfo);

    const keys = ["minatk", "maxatk", "addatk", "accuracy", "critical"];
    let html = `<table class="cmp-table">
      <tr><th>능력치</th><th>A</th><th>B</th><th>차이</th></tr>`;

    keys.forEach((k) => {
      const a = parseInt(A[k] || "0", 10);
      const b = parseInt(B[k] || "0", 10);
      if (a !== 0 || b !== 0) {
        const diff = b - a;
        const cls = diff > 0 ? "delta-pos" : diff < 0 ? "delta-neg" : "delta-zero";
        html += `<tr>
          <td>${k.toUpperCase()}</td>
          <td>${a}</td>
          <td>${b}</td>
          <td class="${cls}">${diff > 0 ? "+" : ""}${diff}</td>
        </tr>`;
      }
    });

    html += `</table>`;
    const cmpBox = document.getElementById("cmpBox");
    if (cmpBox) cmpBox.innerHTML = html;
  }

  function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, (m) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[m])
    );
  }

  /* ===== 버튼형 토글 ===== */
  function setupToggleGroup(groupId) {
    const group = document.getElementById(groupId);
    if (!group) return;
    const buttons = group.querySelectorAll(".toggle-btn");
    const allBtn = group.querySelector(".toggle-btn[data-value='전체']");

    buttons.forEach((btn) => {
      btn.addEventListener("click", () => {
        const isActive = btn.classList.contains("active");

        // 전체 버튼 처리
        if (btn === allBtn) {
          if (isActive) {
            // 전체 → 해제
            allBtn.classList.remove("active");
            buttons.forEach((b) => b.classList.remove("active"));
          } else {
            // 전체 → 활성화
            allBtn.classList.add("active");
            buttons.forEach((b) => b.classList.add("active"));
          }
        } else {
          // 개별 버튼 처리
          btn.classList.toggle("active");
          if (allBtn) {
            const others = [...buttons].filter((b) => b !== allBtn);
            allBtn.classList.toggle("active", others.every((b) => b.classList.contains("active")));
          }
        }
      });
    });
  }

  function getSelectedValues(groupId) {
    return Array.from(document.querySelectorAll(`#${groupId} .toggle-btn.active`))
      .map(btn => btn.dataset.value);
  }

  /* ===== 상태/DOM 캐시 ===== */
  const state = {
    view: "list", // 'list' | 'card'
    currentPage: 1,
    pageSize: 10,
    listPairs: [], // [{row, detail}]
    cardItems: [], // [element]
  };

  const els = {};
  function cacheElements() {
    els.bodyList = document.getElementById("itemBody");
    els.resultInfo = document.getElementById("resultInfo");
    els.pageSizeSel = document.getElementById("pageSize");
    els.pageNumsEl = document.getElementById("pageNums");

    els.btnViewList = document.getElementById("btnViewList");
    els.btnViewCard = document.getElementById("btnViewCard");
    els.listView = document.getElementById("listView");
    els.cardView = document.getElementById("cardView");
    els.cardGrid = document.getElementById("cardGrid");
  }

  /* ===== 데이터 수집(+data-name 보정) ===== */
  function buildData() {
    // 리스트 페어 구성
    state.listPairs = [];
    if (els.bodyList) {
      const rows = Array.from(els.bodyList.querySelectorAll(".r"));
      rows.forEach((r) => {
        if (!r.dataset.name) {
          r.dataset.name = (r.querySelector(".name-text")?.textContent || "").trim();
        }
        const next = r.nextElementSibling;
        state.listPairs.push({
          row: r,
          detail: next && next.classList.contains("detail") ? next : null,
        });
      });
    }

    // 카드 수집
    state.cardItems = els.cardGrid
      ? Array.from(els.cardGrid.querySelectorAll(".item-card"))
      : [];
    state.cardItems.forEach((c) => {
      if (!c.dataset.name) {
        c.dataset.name = (c.querySelector(".ic-title")?.textContent || "").trim();
      }
    });

    // 페이지 사이즈 반영
    if (els.pageSizeSel) {
      const v = parseInt(els.pageSizeSel.value || "10", 10);
      state.pageSize = isNaN(v) ? 10 : v;
    }
  }

  function totalItems() {
    return state.view === "list" ? state.listPairs.length : state.cardItems.length;
  }
  function totalPages() {
    const n = totalItems();
    return Math.max(1, Math.ceil(n / state.pageSize));
  }

  /* ===== 결과 정보 ===== */
  function updateResultInfo() {
    if (!els.resultInfo) return;
    const n = totalItems();
    const tp = totalPages();
    const start = n === 0 ? 0 : (state.currentPage - 1) * state.pageSize + 1;
    const end = Math.min(n, state.currentPage * state.pageSize);
    els.resultInfo.textContent = `총 ${n}개 · ${start}-${end} (페이지 ${state.currentPage}/${tp})`;
  }

  /* ===== 축약형 페이지 리스트 생성 ===== */
  function buildPageList(tp, cp) {
    const keep = new Set(
      [1, 2, tp - 1, tp, cp - 2, cp - 1, cp, cp + 1, cp + 2].filter(
        (x) => x >= 1 && x <= tp
      )
    );
    const arr = [];
    let prev = 0;
    for (let i = 1; i <= tp; i++) {
      if (keep.has(i)) {
        arr.push(i);
        prev = i;
      } else {
        if (prev !== -1) {
          arr.push("...");
          prev = -1;
        }
      }
    }
    return arr.filter((v, i, a) => v !== "..." || a[i - 1] !== "...");
  }

  function renderNumbers() {
    if (!els.pageNumsEl) return;
    const tp = totalPages();
    const cp = state.currentPage;
    const parts = buildPageList(tp, cp);

    let html = "";
    parts.forEach((p) => {
      if (p === "...") {
        html += `<span class="page-ellipsis">…</span>`;
      } else {
        html += `<button class="page-num ${p === cp ? "active" : ""}" data-p="${p}" ${p === cp ? "disabled" : ""}>${p}</button>`;
      }
    });

    els.pageNumsEl.innerHTML = html;
    els.pageNumsEl.querySelectorAll(".page-num").forEach((btn) => {
      btn.addEventListener("click", () => {
        const p = parseInt(btn.dataset.p, 10);
        if (!isNaN(p) && p !== state.currentPage) {
          state.currentPage = p;
          renderPage(true);
        }
      });
    });
  }

  /* ===== 페이지 렌더 ===== */
  function renderPage(resetNumbers = true) {
    const n = totalItems();
    const tp = totalPages();
    if (state.currentPage > tp) state.currentPage = tp;

    const startIdx = (state.currentPage - 1) * state.pageSize;
    const endIdx = Math.min(n, startIdx + state.pageSize);

    if (state.view === "list") {
      state.listPairs.forEach(({ row, detail }) => {
        row.style.display = "none";
        if (detail) {
          detail.style.display = "none";
          detail.classList.remove("open");
          detail.style.maxHeight = "0";
        }
      });

      for (let i = startIdx; i < endIdx; i++) {
        const p = state.listPairs[i];
        if (!p) continue;
        p.row.style.display = "";
        if (p.detail) p.detail.style.display = "";
      }
    } else {
      state.cardItems.forEach((card) => (card.style.display = "none"));
      for (let i = startIdx; i < endIdx; i++) {
        const c = state.cardItems[i];
        if (c) c.style.display = "";
      }
    }

    updateResultInfo();
    if (resetNumbers) renderNumbers();
  }

  /* ===== 뷰 토글 ===== */
  function setView(mode) {
    if (!els.listView || !els.cardView || !els.btnViewList || !els.btnViewCard) return;
    const isList = mode === "list";
    state.view = isList ? "list" : "card";
    state.currentPage = 1;

    els.listView.style.display = isList ? "" : "none";
    els.cardView.style.display = isList ? "none" : "";

    els.btnViewList.classList.toggle("active", isList);
    els.btnViewCard.classList.toggle("active", !isList);
    els.btnViewList.setAttribute("aria-selected", String(isList));
    els.btnViewCard.setAttribute("aria-selected", String(!isList));

    renderPage(true);
  }

  /* ===== 이벤트 바인딩 ===== */
  function bindEvents() {
    // 비교 슬롯 선택
    document.querySelectorAll(".sidebox.selectable").forEach((box) => {
      box.addEventListener("click", () => {
        document.querySelectorAll(".sidebox").forEach((b) => b.classList.remove("selected"));
        box.classList.add("selected");
        selectedSlot = box.dataset.slot || "A";
      });
    });

    // 버튼형 토글 그룹 초기화
    setupToggleGroup("jobs");
    setupToggleGroup("cats");
    setupToggleGroup("grades");

    if (els.pageSizeSel) {
      els.pageSizeSel.addEventListener("change", (e) => {
        const v = parseInt(e.target.value, 10);
        state.pageSize = isNaN(v) ? 10 : v;
        state.currentPage = 1;
        renderPage(true);
      });
    }

    if (els.btnViewList) els.btnViewList.addEventListener("click", () => setView("list"));
    if (els.btnViewCard) els.btnViewCard.addEventListener("click", () => setView("card"));
  }

  function renderSlot(slotEl, d) {
    const chips = [];
    if (d.quality) chips.push(`<span class="chip">${escapeHtml(d.quality)}</span>`);
    if (d.category) chips.push(`<span class="chip">${escapeHtml(d.category)}</span>`);
    if (d.job) chips.push(`<span class="chip">${escapeHtml(d.job)}</span>`);

    const rows = [];
    const a = parseInt(d.minatk || "0", 10), b = parseInt(d.maxatk || "0", 10);
    const add = parseInt(d.addatk || "0", 10);
    const acc = parseInt(d.accuracy || "0", 10);
    const cri = parseInt(d.critical || "0", 10);

    if (a !== 0 || b !== 0) rows.push(`<div class="row"><b>ATK</b> ${a} ~ ${b}${add ? ` / +${add}` : ""}</div>`);
    if (acc !== 0) rows.push(`<div class="row"><b>명중률</b> ${acc}</div>`);
    if (cri !== 0) rows.push(`<div class="row"><b>치명타</b> ${cri}</div>`);
    if (d.obtain) rows.push(`<div class="row"><b>획득처</b> ${escapeHtml(d.obtain)}</div>`);

    const imgTag = d.img
      ? `<img class="side-thumb" src="${escapeHtml(d.img)}" alt="${escapeHtml(d.name)}">`
      : `<div class="side-thumb" style="display:grid;place-items:center;color:#777;font-weight:700;">?</div>`;

    slotEl.innerHTML = `
      <div class="slot-item">
        ${imgTag}
        <div class="slot-main">
          <div class="slot-title">${escapeHtml(d.name)}</div>
          ${chips.length ? `<div class="slot-chips">${chips.join("")}</div>` : ""}
          ${rows.length ? `<div class="slot-spec">${rows.join("")}</div>` : `<div class="slot-spec" style="color:#888">표시할 스펙이 없습니다</div>`}
        </div>
      </div>
    `;
  }

  /* ===== 초기화 ===== */
  function init() {
    cacheElements();
    bindEvents();
    buildData();
    setView("list");
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
