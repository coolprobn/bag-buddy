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
end
