class FeaturesController < ApplicationController
  before_filter :require_user
  before_filter :get_project
  
  # GET /features
  # GET /features.xml
  def index
    @features     = @project.features
        
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @features }
    end
  end

  # GET /features/1
  # GET /features/1.xml
  def show
    @feature = @project.features.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feature }
    end
  end

  # GET /features/new
  # GET /features/new.xml
  def new
    @feature = Feature.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feature }
    end
  end

  # GET /features/1/edit
  def edit
    @feature = @project.features.find(params[:id])
  end

  # POST /features
  # POST /features.xml
  def create
    @feature = Feature.new(params[:feature])
    @feature.created_by = current_user

    respond_to do |format|
      if @project.features << @feature
        Notifications.deliver_new_feature(current_user,@feature)
        format.html { redirect_to(project_features_path(@project), :notice => 'Feature was successfully created.') }
        format.xml  { render :xml => @feature, :status => :created, :location => @feature }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.xml
  def update
    @feature = @project.features.find(params[:id])

    respond_to do |format|
      if @feature.update_attributes(params[:feature])
        format.html { redirect_to(project_features_path(@project), :notice => 'Feature was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.xml
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to(project_features_path(@project)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_project
    begin
      if params[:project_id]
        @project = current_user.projects.find(params[:project_id])
      else
        feature = Feature.find(params[:id])
        @project = current_user.projects.find(feature.project.id) unless feature.nil?
      end
      time_for_project(@project)
    rescue
      redirect_to(projects_path, :notice => "The project you were looking for could not be found.") if @project.nil?
    end
  end
  
end
