# Cloudinary reads CLOUDINARY_URL by default.
# This initializer makes the configuration explicit and fails fast if missing.

return if ENV["CLOUDINARY_URL"].blank?

Cloudinary.config_from_url(ENV.fetch("CLOUDINARY_URL"))
Cloudinary.config.secure = true
