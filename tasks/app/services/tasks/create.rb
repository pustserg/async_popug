# check Homework week2

module Tasks
  class Create
    include Interactor

    TASK_SERIALIZATION_FIELDS = %w[public_id title description status assign_price finished_price jira_id].freeze

    delegate :params, :validation_errors, to: :context

    def call
      Rails.logger.info "Creating task with params #{task_params}"
      validate_params

      if validation_errors.present?
        Rails.logger.info "Task not created due to invalid params"
        context.fail!(errors: validation_errors.join(', '))
      end

      if task = Task.create(task_params)
        context.task = task
        Rails.logger.info "Task #{task.id} created"
        Producer.publish(event_type: 'task_assigned', payload: payload(task))
      else
        Rails.logger.info "Task not created due to errors #{task.errors.full_messages}"
        context.fail!(errors: task.errors.full_messages.join(', '))
      end
    end

    private

    def validate_params
      # simple validation if title contains '['
      return if params['title'].presence['['].nil?

      context.validation_errors = ['There are square brackets in title, please use special jira_id field for it']
    end

    def task_params
      params.merge(user_id: random_worker_id, assign_price: assign_price, finish_price: finish_price)
    end

    def random_worker_id
      User.workers.order('RANDOM()').select(:external_id).first.external_id
    end

    def assign_price
      rand(-20..-10)
    end

    def finish_price
      rand(20..40)
    end

    def payload(task)
      task.as_json(only: TASK_SERIALIZATION_FIELDS).merge(user_id: task.user.external_id)
    end
  end
end
