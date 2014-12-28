class ActionType < Sequel::Model
  plugin :timestamps

  one_to_many :action_archives
end
