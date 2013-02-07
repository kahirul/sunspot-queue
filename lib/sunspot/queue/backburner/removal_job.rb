require "sunspot/queue/helpers"

module Sunspot::Queue::Backburner
  class RemovalJob
    extend ::Sunspot::Queue::Helpers
    include Backburner::Queue

    queue "sunspot"

    def self.perform(klass, id)
      without_proxy do
        ::Sunspot.remove_by_id(klass, id)
      end
    end
  end
end
