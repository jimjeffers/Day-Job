class ProjectsController < ApplicationController
  before_filter :require_user
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = current_user.projects
    @admin_projects = current_user.admin_projects.map { |p| p.id }
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = current_user.projects.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    
    respond_to do |format|
      if @project.save
        @project.set_owner(current_user)
        format.html { redirect_to(projects_path, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = current_user.projects.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(projects_path, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /projects/1/invite
  def invite
    unless (@project = Project.find(params[:id])).nil?
      @invitation = Invitation.new(:project => @project)
    
      respond_to do |format|
        format.html { render :layout => "features"}
        format.xml  { render :xml => @project }
      end
    else
      redirect_to(projects_url, :notice => "No project was found with that ID.")
    end
  end
  
  # POST /projects/1/send_invite
  def send_invite
    unless (@project = Project.find(params[:id])).nil?
      @invitation = Invitation.create_with_email_for_project_from_user(params[:invitation][:email], @project, current_user)

      Notifications.deliver_invitation(@invitation)
      redirect_to(projects_url, :notice => "You're invitation was successfully sent to #{@invitation.email}.")
    else
      redirect_to(projects_url, :notice => "No project was found with that ID.")
    end
  end
end
