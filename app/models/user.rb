class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :trackable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, length: { maximum: 255 }, allow_blank: true
  validates :phone, length: { maximum: 255 }, allow_blank: true

  def full_name
    [first_name, last_name].compact.join(" ")
  end
end
