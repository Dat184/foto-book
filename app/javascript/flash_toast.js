const FlashToast = {
  toastId: "flashToast",

  init() {
    const handler = this.show.bind(this);

    document.addEventListener("turbo:load", handler);
    document.addEventListener("DOMContentLoaded", handler);
  },

  show() {
    const el = document.getElementById(this.toastId);
    if (!el || el.dataset.shown === "true") return;

    const bs = window.bootstrap;
    if (!bs || !bs.Toast) return;

    const toast = bs.Toast.getOrCreateInstance(el);
    requestAnimationFrame(() => toast.show());
    el.dataset.shown = "true";
  },
};

export default FlashToast;
