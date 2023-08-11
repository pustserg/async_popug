class TasksController < ApplicationController
  def index
    tasks = Task.all
    render json: tasks
  end

  def create
    task = Tasks::Create.call(params: task_params)
    render json: task
  end

  def shuffle
    result = Tasks::Shuffle.call(current_user: current_user)
    if result.success?
      render json: result
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  def finish
    task = Task.find(params[:id])
    Tasks::Finish.call(current_user: current_user, task: task)
    render json: task
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
