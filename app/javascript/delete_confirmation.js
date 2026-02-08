const DeleteConfirmation = {
  init() {
    // Listen for regular form submission (for non-Turbo forms)
    document.addEventListener("submit", (event) => {
      this.handleSubmit(event);
    });

    // Also listen for turbo:submit-start for Turbo-enabled forms
    document.addEventListener("turbo:submit-start", (event) => {
      this.handleTurboSubmit(event);
    });
  },

  handleSubmit(event) {
    const form = event.target;
    if (!form) return;

    // Check if form has double_confirm attribute
    const hasDoubleConfirm = form.dataset.doubleConfirm === "true";
    if (!hasDoubleConfirm) return;

    // Check if the form method is DELETE
    const methodInput = form.querySelector('input[name="_method"]');
    const isDelete = methodInput && methodInput.value === "delete";
    if (!isDelete) return;

    // Check if already confirmed
    if (form.dataset.confirmed === "true") {
      return; // Allow submission
    }

    // Prevent submission
    event.preventDefault();

    // Show first confirmation
    const firstConfirm = confirm("Are you sure you want to delete this photo?");
    if (!firstConfirm) return;

    // Show second confirmation
    const secondConfirm = confirm(
      "FINAL WARNING: This action cannot be undone. Delete permanently?",
    );
    if (!secondConfirm) return;

    // Mark as confirmed and resubmit
    form.dataset.confirmed = "true";
    form.submit();
  },

  handleTurboSubmit(event) {
    const form = event.target;
    if (!form) return;

    // Check if form has double_confirm attribute
    const hasDoubleConfirm = form.dataset.doubleConfirm === "true";
    if (!hasDoubleConfirm) return;

    // Check if the form method is DELETE
    const methodInput = form.querySelector('input[name="_method"]');
    const isDelete = methodInput && methodInput.value === "delete";
    if (!isDelete) return;

    // Check if already confirmed
    if (form.dataset.confirmed === "true") {
      return; // Allow submission
    }

    // Stop the Turbo submission
    event.detail.formSubmission.stop();

    // Show first confirmation
    const firstConfirm = confirm("Are you sure you want to delete this photo?");
    if (!firstConfirm) return;

    // Show second confirmation
    const secondConfirm = confirm(
      "FINAL WARNING: This action cannot be undone. Delete permanently?",
    );
    if (!secondConfirm) return;

    // Mark as confirmed and resubmit
    form.dataset.confirmed = "true";
    form.requestSubmit();
  },
};

export default DeleteConfirmation;
