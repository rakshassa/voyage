require 'securerandom'

class Teamquest < ApplicationRecord
  validates :team_id, presence: true
  validates :quest_id, presence: true
  validates :quest_status, presence: true
  validates :answer_seed, presence: true, length: {minimum: 5, maximum: 25}

  enum quest_status: {
    unavailable: 1,
    available: 2
  }

  scope :available, -> { where("quest_status != ?", Teamquest.quest_statuses[:unavailable]) }
  scope :with_quest, ->(quest_id) { where(:quest_id => quest_id) }

  belongs_to :quest, class_name: 'Quest', foreign_key: :quest_id
  belongs_to :team, class_name: 'Team', foreign_key: :team_id

  def is_available
    quest_status != Teamquest.quest_statuses[:unavailable]
  end

  def is_step_completed(step_number)
    return false if last_step_completed.blank?
    return false if step_number > last_step_completed
    true
  end

  def is_next_step(step_number)
    step_number == next_step_number
  end

  # returns nil if there are no remaining steps
  def next_step_number
    return nil if quest.steps.blank?
    return quest.steps.first.step_number if last_step_completed.blank?

    quest.steps.each do |step|
      return step.step_number if step.step_number > last_step_completed
    end

    return nil
  end

  def score_earned
    return 0 if last_step_completed.blank?
    completed_steps = quest.steps_up_to(last_step_completed)
    completed_steps.sum(:points)
  end

  def self.generate_seed
    SecureRandom.hex(8)
  end

  def self.publish(quest)
    teams = Team.meets_prereqs(quest)

    teams.each do |team|
      record = Teamquest.where(team_id: team.id, quest_id: quest.id).first_or_initialize
      record.quest_status = Teamquest.quest_statuses[:available]
      record.answer_seed = generate_seed if record.answer_seed.nil?
      record.save
    end
  end

  def self.unpublish(quest, retain_progress)
    existing = Teamquest.with_quest(quest.id)

    if retain_progress
      existing.update_all(quest_status: Teamquest.quest_statuses[:unavailable])
    else
      existing.destroy_all
    end
  end
end
