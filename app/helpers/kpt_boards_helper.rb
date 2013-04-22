module KptBoardsHelper

  def permit_kpt_boards?(action)
    User.current.allowed_to?({ :controller => :kpt_boards, :action => action }, @project)
  end

  def permit_kpt_entries?(action)
    User.current.allowed_to?({ :controller => :kpt_entries, :action => action }, @project)
  end

  def link_to_edit_kpt_board
    if permit_kpt_boards? :update
      return link_to l(:label_kpt_edit),
        edit_project_kpt_path(@project, @kpt_board),
        :class => 'edit icon icon-edit'
    end
  end

  def link_to_lock_kpt_board
    if permit_kpt_boards? :lock
      return link_to l(:label_kpt_lock),
        project_kpt_lock_path(@project, @kpt_board), :method => :post,
        :remote => true, :data => { :confirm => l(:text_are_you_sure) },
        :class => 'lock icon icon-lock'
    end
  end

  def link_to_unlock_kpt_board
    if permit_kpt_boards? :unlock
      link_to l(:label_kpt_unlock),
        project_kpt_lock_path(@project, @kpt_board), :method => :delete,
        :remote => true, :data => { :confirm => l(:text_are_you_sure) },
        :class => 'unlock icon icon-unlock'
    end
  end

  def link_to_enable_live_update_kpt_board
    link_to_function l(:label_kpt_enable_live_update), '$KPT.online(1000)',
      :class => 'online icon icon-reload'
  end

  def link_to_disable_live_update_kpt_board
    link_to_function l(:label_kpt_disable_live_update), '$KPT.offline()',
      :class => 'offline icon icon-sync'
  end

  def link_to_delete_kpt_board
    if permit_kpt_boards? :destroy
      return link_to l(:label_kpt_delete),
        project_kpt_path(@project, @kpt_board), :method => :delete,
        :data => { :confirm => l(:text_are_you_sure) },
        :class => 'delete icon icon-del'
    end
  end

  def kpt_board_status(kpt_board)
    if kpt_board.locked?
      content_tag :div, l(:kpt_board_is_locked), :class => "status status-locked icon icon-lock"
    else
      content_tag :div, l(:kpt_board_is_unlocked), :class => "status status-unlocked"
    end
  end

end
