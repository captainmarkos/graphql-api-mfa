class ApiKey < ApplicationRecord
  belongs_to :bearer, polymorphic: true

  scope :newest, -> { order(created_at: :desc).first }
end
