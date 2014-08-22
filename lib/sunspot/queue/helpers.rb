require "sunspot/queue/session_proxy"

module Sunspot::Queue
  module Helpers
    def without_proxy
      proxy = nil

      # Pop off the queueing proxy for the block if it's in place so we don't
      # requeue the same job multiple times.
      if Sunspot.session.instance_of?(SessionProxy)
        proxy = Sunspot.session
        Sunspot.session = proxy.session
      end

      yield
    ensure
      Sunspot.session = proxy if proxy
    end

    def constantize(klass)
      names = klass.to_s.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end

    def retrying(klass, id, trying)
      backend = Sunspot::Queue::Backburner::Backend.new
      job = Sunspot::Queue.configuration.index_job || ::Sunspot::Queue::Backburner::IndexJob

      if (retrying_count = constantize(klass).try(:retrying_count).to_i) > trying
        backend.enqueue(job, klass, id, trying + 1)
      end
    end
  end
end
