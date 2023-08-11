# check Homework week2

module Tasks
  class Finish
    include Interactor
    delegate :current_user, :task, to: :context

    def call
      context.fail!(errors: 'User can finish only own task') unless current_user_can_finish_task?
      task.update(status: :finished)
      Producer.publish(event_type: 'task_finished', payload: task.as_json)
      context.task = task
    end

    private

    def current_user_can_finish_task?
      task.user_id == current_user.external_id
    end
  end
end
