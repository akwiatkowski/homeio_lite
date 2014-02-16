class ActionType < Sequel::Model
  one_to_many :action_archives
end
