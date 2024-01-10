Redmine::Plugin.register :issue_lifecycle do
	name 'Issue Lifecycle plugin'
	author 'Osman Özcan'
	description 'This is a plugin for Redmine'
	version '0.0.1'
	url 'http://example.com/path/to/plugin'
	author_url 'http://example.com/about'

	project_module :issue_lifecycle do
	  permission :view_issue_lifecycle, :issue_lifecycle => :index
	end

	menu :project_menu, :issue_lifecycle, { :controller => 'issue_lifecycle', :action => 'index' }, :caption => 'Issue Lifecycle', :after => :issues, :param => :project_id
  end