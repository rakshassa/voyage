class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 25}
  validates :team_captain_id, presence: true

  scope :unfull, -> { joins(:users).group("teams.id").having("COUNT(users.id) < ?", APP_CONFIG['max_teamsize']) }
  scope :full, -> { joins(:users).group("teams.id").having("COUNT(users.id) >= ?", APP_CONFIG['max_teamsize']) }

  has_many :users, :class_name => 'User', dependent: :nullify, inverse_of: :team
  has_many :joinrequests, :class_name => 'Joinrequest', dependent: :destroy, inverse_of: :team
  belongs_to :captain, class_name: 'User', foreign_key: :team_captain_id
  has_many :teamquests, :class_name => 'Teamquest', dependent: :destroy, inverse_of: :team

  def self.meets_prereqs(quest)
    prereqs = quest.prereqs
    return Team.all unless prereqs.present?

    ready_teams = []

    Team.all.each { |team|
      ready = true
      prereqs.each { |prereq|
        required_teamquest = Teamquest.where(team_id: team.id, quest_id: prereq.required_quest_id)
        ready = false unless required_teamquest.present?
        ready = false unless required_teamquest.first.is_all_steps_completed
      }
      ready_teams << team.id if ready
    }

    Team.where("teams.id in (?)", ready_teams)
  end

  def assign_all_quests
    quests = Quest.published.has_no_prereqs
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
