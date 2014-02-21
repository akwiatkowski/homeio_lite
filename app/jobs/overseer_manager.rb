class OverseerManager
  def initialize
    @overseers = OVERSEERS
  end

  def make_it_so
    loop do
      @overseers.each do |overseer|
        overseer.check
      end
      sleep 1
    end
  end
end