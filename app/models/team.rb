class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 25}
  validates :team_captain_id, presence: true, uniqueness: true

  scope :unfull, -> { joins(:users).group("teams.id").having("COUNT(users.id) < ?", APP_CONFIG['max_teamsize']) }
  scope :full, -> { joins(:users).group("teams.id").having("COUNT(users.id) >= ?", APP_CONFIG['max_teamsize']) }

  has_many :users, :class_name => 'User', dependent: :nullify, inverse_of: :team
  has_many :joinrequests, :class_name => 'Joinrequest', dependent: :destroy, inverse_of: :team
  belongs_to :captain, class_name: 'User', foreign_key: :team_captain_id
  has_many :teamquests, :class_name => 'Teamquest', dependent: :destroy, inverse_of: :team

  def self.meets_prereqs(quest)
    # TODO: only return an activerecord relationship that contains each team
    # which actually meets all prereqs for quest-step-<lowest>
    # TODO: make a scope??
    Team.all
  end

  def assign_all_quests
    quests = Quest.published
    quests.each do |quest|
      seed = Teamquest.generate_seed
      status = Teamquest.quest_statuses[:available]
      teamquest = Teamquest.create(team_id: id, quest_id: quest.id, quest_status: status, answer_seed: seed)
      teamquest.save
    end
  end

  def total_score
    result = 0

    teamquests.each do |teamquest|
      result += teamquest.score_earned
    end
    result
  end

  def max_score
    result = 0
    quests = Quest.published
    quests.each do |quest|
      result += quest.total_score
    end
    result
  end

  def available_quests
    teamquests.available
  end

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
