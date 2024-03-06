# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  deleted_at         :datetime
#  email              :string           not null
#  email_confirmed_at :datetime
#  name               :string
#  password_digest    :string
#  username           :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at  (deleted_at)
#  index_users_on_email       (email) UNIQUE
#  index_users_on_username    (username) UNIQUE
#
class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  PASSWORD_FORMAT =
    /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,72}\z/
  USERNAME_FORMAT = /\A[a-z0-9\-_\.]{3,20}\z/

  # associations
  has_many :audit_logs, dependent: :destroy

  # normalizations
  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :username, with: ->(username) { username.strip.downcase }

  # validations
  validates :email, presence: true, uniqueness: true,
                    format: { with: EMAIL_FORMAT, message: I18n.t('models.user.email_format') }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 },
                       format: { with: USERNAME_FORMAT, message: I18n.t('models.user.username_format') }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 8, maximum: 72 },
                       format: { with: PASSWORD_FORMAT, message: I18n.t('models.user.password_format') },
                       if: :password_required?

  generates_token_for :email_confirmation, expires_in: 8.hours do
    email
  end

  generates_token_for :password_reset, expires_in: 1.hour do
    password_salt&.last(10)
  end

  def confirmed?
    email_confirmed_at.present?
  end

  def confirm!
    update(email_confirmed_at: Time.current)
  end

  private

  def password_required?
    password_digest.nil? || password.present?
  end
end
