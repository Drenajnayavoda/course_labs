(function () {
  const basePath = "/oss_toolchainmap";

  let tools = [];
  let isLoaded = false;

  function loadTools() {
    if (isLoaded) return;

    fetch(basePath + "/assets/search/tools.json")
      .then(function (r) { return r.json(); })
      .then(function (data) {
        if (!Array.isArray(data)) {
          console.error("[tools-search] tools.json is not an array");
          return;
        }
        tools = data;
        isLoaded = true;
        window.toolsSearchData = { tools: tools };
        console.log("[tools-search] loaded", tools.length, "records");

        if (typeof window.toolsSearchApplyFilters === "function") {
          window.toolsSearchApplyFilters();
        }
      })
      .catch(function (err) {
        console.error("[tools-search] failed to load tools.json", err);
      });
  }

  function initSearch() {
    var input = document.getElementById("tools-search-input");
    var resultsList = document.getElementById("tools-search-results");

    if (!input || !resultsList) {
      return;
    }

    function defaultRenderResults(items) {
      resultsList.innerHTML = "";
      if (!items.length) return;

      items.slice(0, 50).forEach(function (tool) {
        const li = document.createElement("li");
        li.textContent = tool.name || "Без названия";
        resultsList.appendChild(li);
      });
    }

    function renderResults(items) {
      if (typeof window.renderToolsSearchResults === "function") {
        window.renderToolsSearchResults(items, resultsList);
      } else {
        defaultRenderResults(items);
      }
    }

    function onSearch() {
      const q = input.value.trim().toLowerCase();
      if (!q || !tools.length) {
        resultsList.innerHTML = "";
        return;
      }

      const filtered = tools.filter(function (t) {
        const haystack = [
          t.name,
          t.vendor,
          t.description,
          t.division,
          t.type,
          t.tool_class,
          t.kind,
          t.lic
        ]
          .filter(Boolean)
          .join(" ")
          .toLowerCase();

        return haystack.includes(q);
      });

      renderResults(filtered);
    }

    input.addEventListener("input", onSearch);
  }

  document.addEventListener("DOMContentLoaded", function () {
    loadTools();
    initSearch();
  });
})();