const FlashToast = {
  toastId: "flashToast",

  init() {
    const handler = this.show.bind(this);

    document.addEventListener("DOMContentLoaded", handler);
    document.addEventListener("turbo:load", handler);
    document.addEventListener("turbo:render", handler);
    document.addEventListener("turbo:frame-render", handler);
  },

  show() {
    const el = document.getElementById(this.toastId);
    if (!el) return;

    if (el.dataset.shown === "true") {
      const currentContent = el.querySelector(".toast-body")?.innerHTML || "";
      if (el.dataset.lastContent === currentContent) return;
    }

    const bs = window.bootstrap;
    if (!bs || !bs.Toast) return;

    const toast = bs.Toast.getOrCreateInstance(el);
    requestAnimationFrame(() => toast.show());
    el.dataset.shown = "true";
    el.dataset.lastContent = el.querySelector(".toast-body")?.innerHTML || "";
  },
};

export default FlashToast;
