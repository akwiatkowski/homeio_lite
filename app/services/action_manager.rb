class ActionManager
  def initialize
    @action_cache_storages = Hash.new
    @action_types = Hash.new
    ACTION_TYPES.each do |definition|
      name = definition[:name]
      @action_cache_storages[name] = ActionCacheStorage.new(name, definition)
      # time is not stored in list
      @action_cache_storages[name].clear_buffer

      c = ActionType.where(name: name).first
      c = ActionType.new(name: name) if c.nil?
      c.save
      @action_types[name] = c
    end
  end
end