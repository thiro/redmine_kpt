Redmine::Plugin.register :redmine_kpt do
  name 'Redmine KPT plugin'
  author 'Takuya Hirota'
  description 'Keep/Problem/Try plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/thiro/redmine_kpt'
  author_url 'https://github.com/thiro/redmine_kpt'

  project_module :kpt do
    permission :manage_kpts,
      :kpt_boards => [:index, :show, :locked?, :create, :edit, :update, :destroy, :lock, :unlock],
      :kpt_entries => [:index, :create, :update, :destroy]
    permission :post_kpts,
      :kpt_boards => [:index, :show, :locked?],
      :kpt_entries => [:index, :create]
    permission :view_kpts,
      :kpt_boards => [:index, :show, :locked?],
      :kpt_entries => [:index]
  end
  menu :project_menu, :kpt_boards, {:controller => 'kpt_boards', :action => 'index'},
    :caption => :label_kpt, :after => :wiki, :param => :project_id
end

Rails.configuration.to_prepare do
  require_dependency 'kpt_project_patch'
end
