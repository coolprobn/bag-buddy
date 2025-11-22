class Customer < ApplicationRecord
  has_many :sales, dependent: :destroy
  has_many :sales_returns, through: :sales

  validates :first_name, presence: true
  validates :email,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            },
            allow_blank: true

  def full_name
    [first_name, last_name].compact.join(" ").strip
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      address
      created_at
      email
      facebook_url
      first_name
      id
      instagram_profile_url
      last_name
      notes
      phone
      tiktok_profile_url
      updated_at
      whatsapp_number
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[sales sales_returns]
  end
end
