const PhotoModal = {
  modalId: "photoModal",

  init() {
    if (document.documentElement.dataset.photoModalInit === "true") return;
    document.documentElement.dataset.photoModalInit = "true";

    document.addEventListener("show.bs.modal", (event) => {
      const modal = event.target;
      if (!modal || modal.id !== this.modalId) return;

      const trigger = event.relatedTarget;
      if (!trigger) return;

      const title = trigger.dataset.photoTitle || "Untitled";
      const imageUrl = trigger.dataset.photoImage || "";
      const description = trigger.dataset.photoDescription || "";

      const titleEl = modal.querySelector("#photoModalLabel");
      const imageEl = modal.querySelector("#photoModalImage");
      const descEl = modal.querySelector("#photoModalDescription");

      if (titleEl) titleEl.textContent = title;
      if (imageEl) imageEl.src = imageUrl;
      if (descEl) descEl.textContent = description;
    });
  },
};

export default PhotoModal;
