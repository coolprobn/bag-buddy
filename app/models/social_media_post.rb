class SocialMediaPost < ApplicationRecord
  # Platforms are stored as integer array (enum values)
  # Use class methods to work with platform names
  PLATFORMS = %w[instagram tiktok facebook].freeze

  validates :title, presence: true
  validates :platforms_posted, presence: true
  validates :post_url_per_platform, presence: true
end
