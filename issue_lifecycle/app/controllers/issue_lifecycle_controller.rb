class IssueLifecycleController < ApplicationController
	def index
		issues_data = []
		tetc = []

		@project = Project.includes(issues: [:journals, :time_entries]).find_by(identifier: params[:project_id])
		@user_spent_time = IssueData.project_details(@project)
		@issues_data = IssueData.issue_properties(@project)
		@tetc = SaveTime.total_elapsed_time_category(@issues_data)

		respond_to do |format|
			format.html { render :index }
		end
	end
end