# check Homework week2

module Tasks
  class Create
    include Interactor

    delegate :params, to: :context

    def call
      Rails.logger.info "Creating task with params #{task_params}"
      if task = Task.create(task_params)
        context.task = task
        Rails.logger.info "Task #{task.id} created"
        Producer.publish(event_type: 'task_assigned', payload: task.to_json)
      else
        Rails.logger.info "Task not created due to errors #{task.errors.full_messages}"
        context.fail!(errors: task.errors.full_messages.join(', '))
      end
    end

    private

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
  end
end
