class KptEntriesController < ApplicationController
  unloadable
  before_filter :find_project, :authorize
  before_filter :find_kpt_board
  respond_to :html, :js

  def index
    @kpt_entries = @kpt_board.entries.offset(params[:from] || 0)
    respond_with @kpt_entries do |f|
      f.html { render :partial => @kpt_entries }
    end
  end

  def create
    @kpt_entry = @kpt_board.entries.build(params[:kpt_entry])
    @kpt_entry.kind = params[:kpt_entry][:kind]
    @kpt_entry.user_id = User.current.id
    @kpt_entry.save
    respond_with @kpt_entry
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_kpt_board
    @kpt_board = @project.kpt_boards.find(params[:kpt_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
