module Tasks
  class Shuffle
    include Interactor
    delegate :current_user, to: :context

    def call
      context.fail!(errors: 'User is not a manager') unless current_user_can_shuffle_tasks?
      Task.opened.find_each do |task|
        task.update(user_id: random_worker_id)
        Producer.publish(event_type: 'task_assigned', payload: task.as_json)
      end
    end

    private

    def current_user_can_shuffle_tasks?
      %w[manager administrator].include?(current_user.role.to_s)
    end

    def random_worker_id
      User.workers.order('RANDOM()').select(:external_id).first.external_id
    end
  end
end
