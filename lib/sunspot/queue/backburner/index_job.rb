require "sunspot/queue/helpers"
require "backburner/queue"

module Sunspot::Queue::Backburner
  class IndexJob
    extend ::Sunspot::Queue::Helpers
    include ::Backburner::Queue

    queue "sunspot"

    def self.perform(klass, id, trying)
      without_proxy do
        constantize(klass).find(id).solr_index
        retrying(klass, id, trying)
      end
    end
  end
end
