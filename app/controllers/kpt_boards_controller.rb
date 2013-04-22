class KptBoardsController < ApplicationController
  unloadable
  before_filter :find_project, :authorize # access control
  before_filter :find_kpt_board, :except => :index
  respond_to :html, :js

  def index
    @kpt_boards = @project.kpt_boards.all
  end

  def show
    @kpt_entries = @kpt_board.entries.order(KptEntry.arel_table[:created_at].desc)
  end

  def edit
  end

  def update
    @kpt_board.attributes = params[:kpt_board]
    @kpt_board.save
    respond_with @kpt_board, :location => project_kpt_path(@project, @kpt_board)
  end

  def locked?
    respond_with @kpt_board do |f|
      f.json { render :json => { locked: @kpt_board.locked? } }
    end
  end

  def lock
    @kpt_board.locked = true
    @kpt_board.save
    respond_with @kpt_board do |f|
      f.html { redirect_to project_kpt_path(@project, @kpt_board) }
      f.json { render :json => @kpt_board }
    end
  end

  def unlock
    @kpt_board.locked = false
    @kpt_board.save
    respond_with @kpt_board do |f|
      f.html { redirect_to project_kpt_path(@project, @kpt_board) }
    end
  end

  def create
    @kpt_board = @project.kpt_boards.create(params[:kpt_board])
    respond_with @kpt_board do |f|
      f.html { redirect_to project_kpt_index_path(@project) }
    end
  end

  def destroy
    @kpt_board.destroy
    path = project_kpt_index_path(@project)
    respond_with @kpt_board do |f|
      f.html { redirect_to path }
      f.js   { render :js => "window.location.href = '#{path}';" }
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_kpt_board
    @kpt_board = @project.kpt_boards.find(params[:kpt_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
