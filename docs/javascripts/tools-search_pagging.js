(function () {
  document.addEventListener("DOMContentLoaded", function () {
    var resultsList = document.getElementById("tools-search-results");
    if (!resultsList) return;

    var PAGE_SIZE = 5;

    var currentItems = [];
    var currentPage = 1;

    var pager = document.createElement("div");
    pager.id = "tools-search-pager";
    pager.style.marginTop = "0.5rem";
    pager.style.display = "flex";
    pager.style.alignItems = "center";
    pager.style.gap = "0.5rem";

    var btnPrev = document.createElement("button");
    btnPrev.textContent = "Назад";
    btnPrev.type = "button";

    var pageInfo = document.createElement("span");
    pageInfo.textContent = "";

    var btnNext = document.createElement("button");
    btnNext.textContent = "Вперёд";
    btnNext.type = "button";

    pager.appendChild(btnPrev);
    pager.appendChild(pageInfo);
    pager.appendChild(btnNext);

    resultsList.parentNode.insertBefore(pager, resultsList.nextSibling);

    function renderPage() {
      if (!currentItems.length) {
        resultsList.innerHTML = "";
        pageInfo.textContent = "0 / 0";
        btnPrev.disabled = true;
        btnNext.disabled = true;
        return;
      }

      var totalPages = Math.ceil(currentItems.length / PAGE_SIZE);
      if (currentPage < 1) currentPage = 1;
      if (currentPage > totalPages) currentPage = totalPages;

      var start = (currentPage - 1) * PAGE_SIZE;
      var end = start + PAGE_SIZE;
      var pageItems = currentItems.slice(start, end);

      if (typeof window.renderToolsSearchResultsRaw === "function") {
        window.renderToolsSearchResultsRaw(pageItems, resultsList);
      }

      pageInfo.textContent = currentPage + " / " + totalPages;
      btnPrev.disabled = currentPage === 1;
      btnNext.disabled = currentPage === totalPages;
    }

    btnPrev.addEventListener("click", function () {
      currentPage -= 1;
      renderPage();
    });

    btnNext.addEventListener("click", function () {
      currentPage += 1;
      renderPage();
    });

    var originalRender =
      window.renderToolsSearchResults || window.renderToolsSearchResultsRaw;

    window.renderToolsSearchResults = function (items, listEl) {
      if (listEl && listEl.id !== "tools-search-results") {
        if (typeof originalRender === "function") {
          originalRender(items, listEl);
        }
        return;
      }

      currentItems = Array.isArray(items) ? items : [];
      currentPage = 1;
      renderPage();
    };
  });
})();