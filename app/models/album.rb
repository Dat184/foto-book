class Album < ApplicationRecord
  # Cú pháp: enum :tên_cột, { hash_giá_trị }, option
  # Lưu ý: dùng "prefix: true" thay vì "_prefix: true" (dù cả 2 đều chạy, nhưng prefix chuẩn hơn ở cú pháp mới)
  enum :sharing, { public: 0, private: 1 }, prefix: true

  belongs_to :user
end
