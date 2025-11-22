class Vendor < ApplicationRecord
  has_many :products, foreign_key: :current_vendor_id, dependent: :nullify
  has_many :vendor_price_histories, dependent: :destroy

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      address
      created_at
      facebook_url
      id
      instagram_profile_url
      name
      notes
      phone
      tiktok_profile_url
      updated_at
      whatsapp_number
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products vendor_price_histories]
  end
end
