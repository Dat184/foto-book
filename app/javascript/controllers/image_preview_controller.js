import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "output"];

  preview() {
    const file = this.inputTarget.files?.[0];
    if (!file) return;

    // chỉ preview ảnh
    if (!file.type.startsWith("image/")) return;

    const reader = new FileReader();
    reader.onload = (e) => {
      this.outputTarget.src = e.target.result;
      this.outputTarget.style.display = "";
    };
    reader.readAsDataURL(file);
  }

  clear() {
    this.inputTarget.value = "";
    this.outputTarget.src = "";
    this.outputTarget.style.display = "none";
  }
}
