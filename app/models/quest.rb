class Quest < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 25}

  scope :published, -> { where(is_published: true) }

  scope :has_prereqs, -> { joins(:prereqs) }
  scope :has_no_prereqs, -> { where("quests.id NOT IN (?)", Quest.has_prereqs.select(:id)) }

  scope :prereq_of, -> (quest_id) { where("quests.id IN (?)", Quest.find(quest_id).prereqs.select(:required_quest_id)) }
  scope :not_prereq_of, ->(quest_id) { where("quests.id NOT IN (?)",
    Quest.prereq_of(quest_id).or(Quest.where(id: quest_id)).select(:id)) }

  has_many :steps, -> { order(step_number: :asc) }, :class_name => 'Step', dependent: :destroy, inverse_of: :quest
  has_many :prereqs, :class_name => 'Prereq', dependent: :destroy, inverse_of: :quest
  has_many :required_by_prereqs, :class_name => "Prereq", dependent: :destroy, inverse_of: :required_quest, :foreign_key => "required_quest_id"


  def total_score
    return 0 if steps.blank?
    steps.sum(:points)
  end

  def steps_up_to(step_number)
    steps.where("steps.step_number <= ?", step_number)
  end

  def last_step_number
    steps.maximum(:step_number)
  end
end
