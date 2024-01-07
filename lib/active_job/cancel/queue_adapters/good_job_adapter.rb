module ActiveJob
  module Cancel
    module QueueAdapters
      class GoodJobAdapter
        def cancel(job_id, queue_name)
          queue_name = queue_name.call if queue_name.is_a?(Proc)
          job = find_job(job_id, queue_name)
          if job
            job.destroy
            return true
          end
          false
        end

        def cancel_by(opts, _queue_name)
          raise ArgumentError, 'Please specify ":provider_job_id"' unless opts[:provider_job_id]
          job_id = opts[:provider_job_id]

          job = GoodJob::Job.find_by(id: job_id)
          if job
            job.destroy
            return true
          end
          false
        end

        private
          def find_job(job_id, queue_name)
            GoodJob::Job.find_by(active_job_id: job_id, queue_name:)
          end
      end
    end
  end
end
