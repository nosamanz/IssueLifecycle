RedmineApp::Application.routes.draw do
	get 'issue_lifecycle', :to => 'issue_lifecycle#index'
	get 'issue_lifecycle/data', :to => 'issue_lifecycle#data'
end