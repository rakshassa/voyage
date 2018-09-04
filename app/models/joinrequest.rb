class Joinrequest < ApplicationRecord

  scope :for_team, ->(team_id) { where(:team_id => team_id) }

  belongs_to :user, class_name: 'User', foreign_key: :user_id, optional: false
  belongs_to :team, class_name: 'Team', foreign_key: :team_id, optional: false
end
