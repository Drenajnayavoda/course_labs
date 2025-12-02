document.addEventListener("DOMContentLoaded", function () {
  const trigger = document.querySelector("[data-tools-overlay-trigger]");
  const overlay = document.querySelector("[data-tools-overlay]");
  const tableContainer = document.getElementById("tools-table-container");
  const tableWrapper = document.getElementById("tools-table-wrapper");

  if (!trigger || !overlay || !tableContainer || !tableWrapper) {
    return;
  }

  var backdrop = overlay.querySelector(".tools-overlay__backdrop");
  var closeBtn = overlay.querySelector(".tools-overlay__close");

  var isTableCloned = false;

  function ensureTable() {
    if (isTableCloned) return;

    tableContainer.innerHTML = tableWrapper.innerHTML;
    isTableCloned = true;
  }

  function openOverlay(evt) {
    if (evt) evt.preventDefault();
    ensureTable();
    overlay.classList.add("is-visible");
  }

  function closeOverlay(evt) {
    if (evt) evt.preventDefault();
    overlay.classList.remove("is-visible");
  }

  trigger.addEventListener("click", openOverlay);

  if (backdrop) {
    backdrop.addEventListener("click", closeOverlay);
  }

  if (closeBtn) {
    closeBtn.addEventListener("click", closeOverlay);
  }

  document.addEventListener("keydown", function (evt) {
    if (evt.key === "Escape") {
      closeOverlay(evt);
    }
  });
});