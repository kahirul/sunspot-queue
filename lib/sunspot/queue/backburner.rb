require "sunspot/queue"

module Sunspot::Queue
  module Backburner
    require "sunspot/queue/backburner/backend"
    require "sunspot/queue/backburner/index_job"
    require "sunspot/queue/backburner/removal_job"
  end
end
