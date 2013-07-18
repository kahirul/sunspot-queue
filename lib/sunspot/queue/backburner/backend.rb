require "backburner"
require "sunspot/queue/backburner/index_job"
require "sunspot/queue/backburner/removal_job"

module Sunspot::Queue::Backburner
  class Backend
    attr_reader :configuration

    def initialize(configuration = Sunspot::Queue.configuration)
      @configuration = configuration
    end

    def enqueue(job, klass, id)
      ::Backburner::Worker.enqueue(job, [klass, id], :delay => configuration.delay || 0)
    end

    def index(klass, id)
      enqueue(index_job, klass, id)
    end

    def remove(klass, id)
      enqueue(removal_job, klass, id)
    end

    private

    def index_job
      configuration.index_job || ::Sunspot::Queue::Backburner::IndexJob
    end

    def removal_job
      configuration.removal_job || ::Sunspot::Queue::Backburner::RemovalJob
    end
  end
end
