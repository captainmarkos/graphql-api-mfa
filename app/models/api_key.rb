class ApiKey < ApplicationRecord
  belongs_to :bearer, polymorphic: true

  validates :token, presence: true

  before_validation :create_token

  scope :newest, -> { order(created_at: :desc).first }

  private

  def create_token
    self.token = SecureRandom.hex if self.token.blank?
  end
end
