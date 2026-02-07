// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

import FlashToast from "flash_toast";
import PhotoModal from "photo_modal";

FlashToast.init();
PhotoModal.init();
