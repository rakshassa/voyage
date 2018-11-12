class User < ApplicationRecord
  attr_accessor :password

  # attr_accessible :handle, :password
  # attr_protected :secret

  before_save :encrypt_password
  after_save :clear_password

  validates :handle, presence: false, uniqueness: true, length: {minimum: 5, maximum: 15}, allow_nil: true
  validates :password, length: {minimum: 6, maximum: 20}, presence: false, allow_nil: true

  belongs_to :team, :foreign_key => "team_id", inverse_of: :users, optional: true
  has_many :joinrequests, :class_name => 'Joinrequest', dependent: :destroy, inverse_of: :team

  def encrypt_password
    if password.present? && provider=='custom'
      self.salt = BCrypt::Engine.generate_salt
      self.secret= BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end

  def self.authenticate(username="", login_password="")
    user = User.find_by_name(username)
    return false unless user.present?
    return false unless user.provider == 'custom'
    return false unless user.secret.present?

    if user.match_password(login_password)
      return user
    else
      return false
    end
  end

  def match_password(login_password="")
    if salt.present?
      secret == BCrypt::Engine.hash_secret(login_password, salt)
    else
      secret == login_password
    end
  end

  def display_name
    return handle if handle.present?
    name
  end

  def block_edit_name
    return false if is_admin
    return false if provider == 'custom'
    true
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
