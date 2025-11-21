class SocialMediaPost < ApplicationRecord
  PLATFORMS = %w[instagram tiktok facebook].freeze

  validates :title, presence: true
  validates :platforms_posted, presence: true
  validates :post_url_per_platform, presence: true

  validates :platforms_posted, inclusion: { in: PLATFORMS }
end
