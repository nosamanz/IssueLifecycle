Redmine::Plugin.register :issue_lifecycle do
	name 'Issue Lifecycle plugin'
	author 'Osman Özcan'
	description 'A redmine plugin that shows the Issue status lifecycle in Redmine.'
	version '2.0'
	url 'https://github.com/nosamanz/IssueLifecycle'
	author_url 'https://github.com/nosamanz'

	project_module :issue_lifecycle do
		permission :view_issue_lifecycle, :issue_lifecycle => :index
	end

	menu :project_menu, :issue_lifecycle, { :controller => 'issue_lifecycle', :action => 'index' }, :caption => 'Issue Lifecycle', :after => :issues, :param => :project_id
end