class User < ApplicationRecord
  has_many :sounds
  scope :authenticate, lambda { |email, password|
    where(email: email, password: password)
  }
end
