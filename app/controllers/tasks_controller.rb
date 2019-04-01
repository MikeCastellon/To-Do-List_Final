class TasksController < ApplicationController
  before_action :set_tasks, only: [:index]
  before_action :set_task, only: [:update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    respond_to do |format|
      format.html do
        @task = Task.new
      end
      format.json do
        page        = (params[:page] || 1).to_i
        per_page    = 5
        total_pages = (@tasks.count.to_f / per_page).ceil
        total_pages = 1 if total_pages.zero?
        @tasks      = @tasks.paginate(page: page, per_page: per_page)
        render json: { tasks: @tasks, page: page, totalPages: total_pages }
      end
    end
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user = current_user
    if @task.save
      respond_to do |format|
        format.html do
          redirect_to root_url,
          notice: 'Task was successfully created.'
        end
        format.json do
          render json: @task
        end
      end
    else
      respond_to do |format|
        format.html do
          redirect_to root_url,
          alert: @task.errors.full_messages.to_sentence
        end
        format.json do
          render json: { errors: @task.errors.full_messages }, status: 422
        end
      end
    end
  end

  # PUT/PATCH /tasks/1
  def update
    @task.update(completed: !@task.completed)
    redirect_back fallback_location: root_url,
      notice: 'Task was successfully updated.'
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to root_url, notice: 'Task was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tasks
    @tasks  = current_user.tasks.ordered
    @tasks  = case params[:status]
              when "pending"
                @tasks.pending
              when "completed"
                @tasks.completed
              else
                @tasks
              end
    @tasks  = case params[:due]
              when "past_due"
                @tasks.past_due
              when "due_soon"
                @tasks.due_soon
              when "due_later"
                @tasks.due_later
              when "not_due"
                @tasks.not_due
              else
                @tasks
              end
    @tasks  = @tasks.search(params[:term])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:description, :due_date)
  end
end