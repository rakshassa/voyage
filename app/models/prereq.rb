class Prereq < ApplicationRecord

  scope :requires_quest, ->(blocking_quest_id) { where(required_quest: blocking_quest_id) }

  belongs_to :quest
  belongs_to :required_quest, :class_name => "Quest"

  def self.is_available(team, quest)
    return false unless team.present? && quest.present?

    prereqs = quest.prereqs
    return true unless prereqs.present?

    prereqs.each { |prereq|
      required_teamquest = Teamquest.where(team_id: team.id, quest_id: prereq.required_quest_id)
      return false unless required_teamquest.present?
      return false unless required_teamquest.first.is_all_steps_completed
    }

    true
  end

  def self.complete_quest(teamquest)
    return unless teamquest.present?

    # create teamquests for any published unblocked quest that doesn't have one.
    were_blocked = Prereq.requires_quest(teamquest.quest.id)
    were_blocked.each do |prereq|
      blocked_quest = prereq.quest
      next unless blocked_quest.is_published

      if Prereq.is_available(teamquest.team, blocked_quest)
        Teamquest.make_available(teamquest.team, blocked_quest)
      end
    end
  end
end
