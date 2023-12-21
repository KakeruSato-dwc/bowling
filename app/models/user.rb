class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations, dependent: :destroy
  has_many :reviews, dependent: :destroy

  katakana = /\A[\p{katakana}\u{30fc}]+\z/

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true, format: {with: katakana, message: 'はカタカナで入力して下さい。'}
  validates :first_name_kana, presence: true, format: {with: katakana, message: 'はカタカナで入力して下さい。'}
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :telephone_number, presence: true
  validates :email, presence: true
end
