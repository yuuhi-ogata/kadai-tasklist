class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :show,:edit]
  
  def index
      if logged_in?
      @user = current_user
      @task = current_user.tasks.build  # form_for 用
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      end
  end

  def show
      @task = Task.find(params[:id])
  end

  def new
       @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end

  def edit
       @task = Task.find(params[:id])
  end

  def update
      @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
    private
    
    def set_task
    @task = Task.find(params[:id])
    end
    
    def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
    end
    
    def correct_user
     @task = current_user.tasks.find_by(id: params[:id])
     unless @task
      redirect_to root_url
     end
    end

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
end