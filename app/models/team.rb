class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :team_captain_id, presence: true, uniqueness: true

  scope :unfull, -> { joins(:users).group("teams.id").having("COUNT(users.id) < ?", APP_CONFIG['max_teamsize']) }
  scope :full, -> { joins(:users).group("teams.id").having("COUNT(users.id) >= ?", APP_CONFIG['max_teamsize']) }

  has_many :users, :class_name => 'User', dependent: :nullify, inverse_of: :team
  has_many :joinrequests, :class_name => 'Joinrequest', dependent: :destroy, inverse_of: :team
  belongs_to :captain, class_name: 'User', foreign_key: :team_captain_id

  def captain_name
    return "None" if captain.nil?
    captain.name
  end

  def self.to_csv(records)
    return '' if records.count.zero?

    columns = %w[ID Name]

    CSV.generate do |csv|
      csv << columns
      records.each do |record|
        values = []
        values << record.id
        values << record.name

        csv << values
      end
    end
  end
end
