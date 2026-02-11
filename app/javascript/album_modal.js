const AlbumModal = {
  modalId: "albumModal",
  currentImageIndex: 0,
  albumImages: [],

  init() {
    if (document.documentElement.dataset.albumModalInit === "true") return;
    document.documentElement.dataset.albumModalInit = "true";

    // Handle show event
    document.addEventListener("show.bs.modal", (event) => {
      const shownModal = event.target;
      if (!shownModal || shownModal.id !== this.modalId) return;

      const trigger = event.relatedTarget;
      if (!trigger) return;

      const title = trigger.dataset.albumTitle || "Untitled";
      const description = trigger.dataset.albumDescription || "";
      const imagesJson = trigger.dataset.albumImages || "[]";

      try {
        this.albumImages = JSON.parse(imagesJson);
      } catch (e) {
        console.error("Failed to parse album images:", e);
        this.albumImages = [];
      }

      this.currentImageIndex = 0;

      const titleEl = shownModal.querySelector("#albumModalLabel");
      const descEl = shownModal.querySelector("#albumModalDescription");

      if (titleEl) titleEl.textContent = title;
      if (descEl) descEl.textContent = description;

      this.updateImage();
    });

    // Handle navigation via event delegation
    document.addEventListener("click", (event) => {
      const prevBtn = event.target.closest("#albumNavPrev");
      const nextBtn = event.target.closest("#albumNavNext");

      if (prevBtn) {
        this.previousImage();
      } else if (nextBtn) {
        this.nextImage();
      }
    });

    // Handle keyboard navigation
    document.addEventListener("keydown", (event) => {
      const modal = document.getElementById(this.modalId);
      if (!modal || !modal.classList.contains("show")) return;

      if (event.key === "ArrowLeft") {
        this.previousImage();
      } else if (event.key === "ArrowRight") {
        this.nextImage();
      }
    });
  },

  updateImage() {
    const modal = document.getElementById(this.modalId);
    if (!modal || this.albumImages.length === 0) return;

    const imageEl = modal.querySelector("#albumModalImage");
    const prevBtn = modal.querySelector("#albumNavPrev");
    const nextBtn = modal.querySelector("#albumNavNext");
    const currentEl = modal.querySelector("#albumImageCurrent");
    const totalEl = modal.querySelector("#albumImageTotal");
    const counterEl = modal.querySelector(".album-image-counter");

    // Update image
    if (imageEl) {
      imageEl.src = this.albumImages[this.currentImageIndex];
    }

    // Update counter
    if (currentEl) currentEl.textContent = this.currentImageIndex + 1;
    if (totalEl) totalEl.textContent = this.albumImages.length;

    // Show/hide buttons based on multiple images
    const hasMultipleImages = this.albumImages.length > 1;
    if (prevBtn) prevBtn.style.display = hasMultipleImages ? "block" : "none";
    if (nextBtn) nextBtn.style.display = hasMultipleImages ? "block" : "none";
    if (counterEl)
      counterEl.style.display = hasMultipleImages ? "block" : "none";

    // Disable prev button at start
    if (prevBtn) {
      prevBtn.disabled = this.currentImageIndex === 0;
      prevBtn.classList.toggle("opacity-50", this.currentImageIndex === 0);
    }

    // Disable next button at end
    if (nextBtn) {
      nextBtn.disabled = this.currentImageIndex === this.albumImages.length - 1;
      nextBtn.classList.toggle(
        "opacity-50",
        this.currentImageIndex === this.albumImages.length - 1,
      );
    }
  },

  nextImage() {
    if (this.currentImageIndex < this.albumImages.length - 1) {
      this.currentImageIndex++;
      this.updateImage();
    }
  },

  previousImage() {
    if (this.currentImageIndex > 0) {
      this.currentImageIndex--;
      this.updateImage();
    }
  },
};

export default AlbumModal;
