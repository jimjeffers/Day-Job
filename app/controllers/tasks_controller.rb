class TasksController < ApplicationController
  before_filter :require_user
  before_filter :get_feature_and_project
  
  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = @feature.tasks.current

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = @feature.tasks.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = @feature.tasks.find(params[:id], :include => :user)
    if @task.completed?
      @user_name = @task.user.login
      @completed_date = @task.completed_on.strftime("%B %d, %Y")
    end
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
    @task.created_by = current_user
    @task.last_updated_by = current_user

    respond_to do |format|
      if @feature.tasks << @task
        
        # If saved successfully, attempt to complete the task if it is possible.
        @task.complete! unless @task.completed?
        
        format.html { redirect_to(feature_tasks_path(@feature), :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = @feature.tasks.find(params[:id])
    @task.last_updated_by = current_user
    
    respond_to do |format|
      if @task.update_attributes(params[:task])
        
        # If saved successfully, attempt to complete the task if it is possible.
        @task.complete! unless @task.completed?
        
        format.html { redirect_to(feature_tasks_path(@feature), :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(feature_tasks_path(@feature)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_feature_and_project
    @feature   = Feature.find(params[:feature_id], :include => :project)
    @project   = @feature.project if current_user.projects.include?(@feature.project)
    time_for_project(@project)
    redirect_to(  projects_path, 
                  :notice => "The project you were looking for could not be found.") if @project.nil?
  end
  
end
