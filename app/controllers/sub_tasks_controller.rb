class SubTasksController < ApplicationController
  before_action :set_task, only: [:create, :index]
  before_action :set_sub_task, only: [:update, :destroy]
 
  def create
    @sub_task = @task.sub_tasks.new(task_params)
    if @sub_task.save
      redirect_to task_sub_tasks_path(@task), notice: 'SubTask was successfully created.'
    else
      redirect_to task_sub_tasks_path(@task), alert: @sub_task.errors.full_messages.join(', ')
    end
  end
 
  def index
    @sub_task = SubTask.new
  end
 
  def update
    @sub_task.update(completed: !@sub_task.completed)
    redirect_to task_sub_tasks_path(@sub_task.task), notice: 'SubTask was successfully updated.'
  end

  def destroy
    @sub_task.destroy
    redirect_to task_sub_tasks_path(@sub_task.task), notice: 'SubTask was successfully destroyed.'
  end

  private
 
  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end
 
  def set_sub_task
    @sub_task = SubTask.find(params[:id])
    return redirect_to root_path unless @sub_task.task.user_id == current_user.id
  end
 
  def task_params
    params.require(:sub_task).permit(:description)
  end
end
