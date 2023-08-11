# check Homework w2
module Users
  class Create
    include Interactor

    delegate :params, to: :context

    def call
      if user = User.create(params)
        context.user = user
        Producer.publish(event_type: 'user_registered', payload: user.as_json(only: %i[id name email role]))
      else
        context.fail!(message: user.errors.full_messages.join(', '))
      end
    end
  end
end
