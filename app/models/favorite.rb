class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :comment
  has_many   :notifications, dependent: :destroy
end
