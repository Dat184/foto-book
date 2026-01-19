class Album < ApplicationRecord
  enum sharing: { public: 0, private: 1 }
end
