let monsterData = [];

async function fetchMonsters() {
  const res = await fetch("get_monsters.php");
  const raw = await res.json();

  monsterData = raw.map(m => ({
    ...m,
    drop: m.drop_items,
    fields: m.field_array,
    move_speed: m.moveSpeed,
    evasion: m.evade,
    attack_range: m.range,
    detect_range: m.sight
  }));

  renderFieldFilters();
  renderMonsters();

  document.getElementById("searchBtn").addEventListener("click", renderMonsters);
  document.getElementById("searchInput").addEventListener("keypress", function (e) {
    if (e.key === "Enter") renderMonsters();
  });
}

function getUniqueFields() {
  const allFields = monsterData.flatMap(m => m.fields);
  return [...new Set(allFields)];
}

function renderFieldFilters() {
  const container = document.getElementById("fieldFilters");
  const fields = getUniqueFields();
  container.innerHTML = '';

  const allLabel = document.createElement("label");
  allLabel.innerHTML = `<input type="checkbox" id="checkAll" checked> 전체`;
  container.appendChild(allLabel);

  fields.forEach(field => {
    const label = document.createElement("label");
    label.innerHTML = `<input type="checkbox" value="${field}" class="field-check" onchange="renderMonsters()" checked> ${field}`;
    container.appendChild(label);
  });

  document.getElementById("checkAll").addEventListener("change", function () {
    document.querySelectorAll(".field-check").forEach(cb => {
      cb.checked = this.checked;
    });
    renderMonsters();
  });
}

function renderMonsters() {
  const container = document.getElementById("monsterContainer");
  container.innerHTML = "";

  const selectedFields = Array.from(
    document.querySelectorAll(".field-check:checked")
  ).map(cb => cb.value);

  const keyword = document.getElementById("searchInput").value.toLowerCase().replace(/\s+/g, '');

  const filtered = monsterData.filter(m => {
    const isInField = m.fields.some(f => selectedFields.includes(f));
    const text = `${m.name}${m.fields.join("")}${m.drop.join("")}`.toLowerCase().replace(/\s+/g, '');
    return isInField && text.includes(keyword);
  });

  if (filtered.length === 0) {
    container.innerHTML = "<p style='text-align:center;'>검색 결과가 없습니다.</p>";
    return;
  }

  const grid = document.createElement("div");
  grid.className = "monster-grid";

  filtered.forEach(m => {
    console.log(m.name, m.imagePath);

    const card = document.createElement("div");
    card.className = "monster-card";
    card.innerHTML = `
      <img src="https://heelack.dothome.co.kr/${m.imagePath}" alt="${m.name}" class="monster-img" />
      <h3 class="monster-name">${m.name}</h3>
      <p><strong>출현지역:</strong> ${m.fields.join(", ")}</p>
      <div class="stat-row"><span>HP: ${m.hp}</span><span>방어력: ${m.defense}</span></div>
      <div class="stat-row"><span>공격력: ${m.attack}</span><span>이동속도: ${m.move_speed}</span></div>
      <div class="stat-row"><span>회피율: ${m.evasion}</span><span>명중률: ${m.accuracy}</span></div>
      <div class="stat-row"><span>공격사거리: ${m.attack_range}</span><span>인식사거리: ${m.detect_range}</span></div>
      <p><strong>드랍아이템:</strong> ${m.drop.join(", ")}</p>
    `;
    grid.appendChild(card);
  });

  container.appendChild(grid);
}

fetchMonsters();
