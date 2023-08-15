# check Homework week2

module Users
  class Update
    include Interactor

    delegate :user, :params, to: :context

    def call
      if user.update(params)
        Producer.publish(event_type: 'user_changed', payload: user.as_json(only: %i[id name email role]))
      else
        context.fail!(message: user.errors.full_messages.join(', '))
      end
    end
  end
end
