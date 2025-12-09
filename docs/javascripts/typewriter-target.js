document.addEventListener("DOMContentLoaded", function () {
  const text = "Stay tuned ;)";
  const el = document.getElementById("typewriter-target");

  const typeSpeed = 100;
  const pauseEnd  = 400;
  let i = 0;

  function type() {
    if (i < text.length) {
      el.textContent += text.charAt(i);
      i++;
      setTimeout(type, typeSpeed);
    } else {
      setTimeout(() => {
        el.textContent = "";
        i = 0;
        type();
      }, pauseEnd);
    }
  }

  type();
});
