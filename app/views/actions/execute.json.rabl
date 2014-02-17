node :result do
  node(:action_cache) {
    attribute :name => @action_type.name
  }

  attributes :status => @result[:status], :raw => @result[:raw]
end

