class User < ApplicationRecord
  validates :name, presence: false, uniqueness: true

  belongs_to :team, :foreign_key => "team_id", inverse_of: :users, optional: true

  def display_name
    handle if handle.present?
    name
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
