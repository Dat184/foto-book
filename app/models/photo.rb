class Photo < ApplicationRecord
  enum :sharing, { public: 0, private: 1 }, prefix: true
end
