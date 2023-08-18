# check Homework week2

module Tasks
  class Finish
    include Interactor

    TASK_SERIALIZATION_FIELDS = %w[public_id title description status assign_price finished_price jira_id].freeze

    delegate :current_user, :task, to: :context

    def call
      context.fail!(errors: 'User can finish only own task') unless current_user_can_finish_task?
      task.update(status: :finished)
      Producer.publish(event_type: 'task_finished', payload: payload(task))
      context.task = task
    end

    private

    def payload(task)
      task.as_json(only: TASK_SERIALIZATION_FIELDS).merge(user_id: task.user.external_id)
    end

    def current_user_can_finish_task?
      task.user_id == current_user.external_id
    end
  end
end
