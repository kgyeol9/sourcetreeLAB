let items = [];

async function fetchItems() {
  const res = await fetch("get_items.php");
  const raw = await res.json();
  items = raw;
  renderItems();
}

function renderItems() {
  const itemContainer = document.getElementById('itemContainer');
  const category = document.getElementById('categoryFilter').value;
  const job = document.getElementById('jobFilter').value;
  const keyword = document.getElementById('searchInput').value.trim();

  const filtered = items.filter(item => {
    const matchCategory = category === 'all' || item.category === category;
    const matchJob = job === 'all' || item.job === job;
    const matchName = item.name.includes(keyword);
    return matchCategory && matchJob && matchName;
  });

  itemContainer.innerHTML = filtered.map(item => `
    <div class="item-card" onclick="location.href='item_detail.html?id=${item.id}'">
      <div class="item-sprite ${item.imagePath} icon-${item.row}-${item.col}"></div>
      <p>${item.name}</p>
    </div>
  `).join('');
}

// 필터 이벤트 설정
document.getElementById('categoryFilter').addEventListener('change', renderItems);
document.getElementById('jobFilter').addEventListener('change', renderItems);
document.getElementById('searchInput').addEventListener('input', renderItems);

fetchItems();
