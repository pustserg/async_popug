module Tasks
  class Shuffle
    include Interactor
    TASK_SERIALIZATION_FIELDS = %w[public_id title description status assign_price finished_price jira_id].freeze
    delegate :current_user, to: :context

    def call
      context.fail!(errors: 'User is not a manager') unless current_user_can_shuffle_tasks?
      Task.opened.find_each do |task|
        task.update(user_id: random_worker_id)
        Producer.publish(event_type: 'task_assigned', payload: payload(task))
      end
    end

    private

    def payload(task)
      task.as_json(only: TASK_SERIALIZATION_FIELDS).merge(user_id: task.user.external_id)
    end

    def current_user_can_shuffle_tasks?
      %w[manager administrator].include?(current_user.role.to_s)
    end

    def random_worker_id
      User.workers.order('RANDOM()').select(:external_id).first.external_id
    end
  end
end
