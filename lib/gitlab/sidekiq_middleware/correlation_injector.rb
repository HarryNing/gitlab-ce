module Gitlab
  module SidekiqMiddleware
    class CorrelationInjector
      def call(worker_class, job, queue, redis_pool)
        job['correlation_id'] = Gitlab::CorrelationId.last_id

        yield
      end
    end
  end
end
