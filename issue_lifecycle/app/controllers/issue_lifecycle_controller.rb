class IssueLifecycleController < ApplicationController
	# before_action :find_project, only: [:index]
	before_action :find_project, only: [:data]

	def data
		issues_data = []
		total_elapsed_time_category = []
		issues = @project.issues.includes(:journals)
		user_spent_time = project_details();
		project_name = @project.name;

		issues.each do |issue|
		  issue_id = issue.id
		  status = issue.status.name
		  issue_category = issue.category.try(:name)
		  issue_creation_time = issue.created_on
		#   user_ids = issue.journals.map { |journal| journal.user_id }.uniq
		#   puts "user_ids: #{user_ids}, issue_id: #{issue_id}"

		#   user_ids.each do |user_id|
		# 	  hours = get_time_spent(user_id, issue.id)
		# 	  user = User.find(user_id).name

		# 	  puts "user_id: #{user_id}, user: #{user}, hours: #{hours}"
		# 	  existing_user_entry = user_spent_time.find { |entry| entry[:user] == user }

		# 	  if existing_user_entry
		# 		existing_user_entry[:total_hours] += hours
		# 	  else
		# 		user_spent_time << {
		# 		  user: user,
		# 		  total_hours: hours
		# 		}
		# 	  end
		#   end

		  issue_data = {
			id: issue_id,
			status_now: status,
			category: issue_category,
			created_on: issue_creation_time,
			status_changes: [],
			elapsed_time_status: [],
			total_elapsed_hours: 0,
			total_elapsed_minutes: 0,
		  }


			process_journals(issue.journals, issue_data)
			if (issue_data[:elapsed_time_status].empty?)
			  elapsed_time_since_creation = Time.now - issue_creation_time
			  save_elapsed_time_status(issue_data, status, elapsed_time_since_creation)
			end

		  issue_data[:total_elapsed_hours] = issue_data[:elapsed_time_status].sum { |status| status[:elapsed_hours] }
		  issue_data[:total_elapsed_minutes] = issue_data[:elapsed_time_status].sum { |status| status[:elapsed_minutes] }
		  issues_data << issue_data
		end

		total_elapsed_time_category = issues_data.group_by { |issue| issue[:category] }.map do |category, issues|
		  {
			category: category,
			issue_ids: issues.map { |issue| issue[:id] },
			total_elapsed_hours: issues.sum { |issue| issue[:total_elapsed_hours] },
			total_elapsed_minutes: issues.sum { |issue| issue[:total_elapsed_minutes] }
		  }
		end
		  respond_to do |format|
			  format.json { render json: { issues_data: issues_data, total_elapsed_time_category: total_elapsed_time_category, user_spent_time: user_spent_time, project_name: project_name } }
		  end
	end

	def find_project
	  @project = Project.find(params[:project_id])
	end

	def index
		respond_to do |format|
			format.html { render :index }
		end
	end

	private

	def process_journals(journals, issue_data)
	  previous_status = nil
	  previous_timestamp = nil
	  current_status = nil

	  journals.each_with_index do |journal, index|

		next if journal.details.empty? || journal.details.first.prop_key != 'status_id'
		elapsed_time = journal.created_on - previous_timestamp if previous_timestamp
		journal.details.each do |detail|
			if detail.property == 'attr' && detail.prop_key == 'status_id'
				if previous_status.nil? && previous_timestamp.nil?
					elapsed_time = journal.created_on - issue_data[:created_on]
					current_status = IssueStatus.find(detail.value).name if detail.prop_key == 'status_id'
				else
					current_status = IssueStatus.find(detail.value).name if detail.prop_key == 'status_id'
				end
			previous_status = IssueStatus.find(detail.old_value).name if detail.old_value
			previous_timestamp = journal.created_on
			changed_by = journal.user.name
			save_elapsed_time_status(issue_data, previous_status, elapsed_time) if previous_status && elapsed_time
			save_status_changes(issue_data, previous_status, current_status, changed_by)
			if index == journals.size - 1
				  elapsed_time = Time.now - journal.created_on
				  current_status = IssueStatus.find(journal.details.last.value).name
				  save_elapsed_time_status(issue_data, current_status, elapsed_time)
			end
			end
		end
	end
end

def save_elapsed_time_status(issue_data, status_name, elapsed_time)
	hours = 0;
	if (elapsed_time / 3600) > 0
		hours = (elapsed_time / 3600).to_i
	end
	minutes = ((elapsed_time % 3600) / 60).to_i

	issue_data[:elapsed_time_status] << {
		status_name: status_name,
		elapsed_hours: hours,
		elapsed_minutes: minutes,
		# elapsed_time: elapsed_time / 3600
	}
end

def save_status_changes(issue_data, previous_status, current_status, changed_by)
	issue_data[:status_changes] << {
		from_status: previous_status,
		to_status: current_status,
		changed_by: changed_by
	}
end

def get_time_spent(user_id, issue_id)
	return  (TimeEntry.where(user_id: user_id, issue_id: issue_id).sum(:hours))
end


def project_details
	project_id = @project.id

	data = {}
	data[:users] = []

	begin
	  @project_users = User.joins(:members).where(members: { project_id: project_id })

	  if @project_users.any?
		@project_users.each do |user|
		  time_entries = TimeEntry.where(user_id: user.id, project_id: project_id)

		  user_data = {
			name: user.name,
			time_entries: [],
			total_hours: 0
		  }

		#   puts "User: #{user.name}"

		#   puts 'TIME ENTRIES'
		  time_entries.each do |time_entry|
			# puts "User ID: #{time_entry.user_id}"
			# puts "Hours: #{time_entry.hours}"

			user_data[:total_hours] += time_entry.hours

			if time_entry.issue_id.present?
			  associated_issue = Issue.find(time_entry.issue_id)
			#   puts "Associated Issue ID: #{associated_issue.id}"
			  # Diğer Issue özelliklerini buraya ekleyebilirsiniz
			else
			#   puts "Bu TimeEntry, bir Issue ile ilişkilendirilmemiştir."
			end

			user_data[:time_entries] << {
			  hours: time_entry.hours,
			  issue_id: time_entry.issue_id
			}
		  end

		  data[:users] << user_data
		end

		# Tüm kullanıcıları ve bilgilerini yazdırma
		# puts 'TÜM KULLANICILAR VE BİLGİLERİ'
	# 	data[:users].each do |user_data|
	# 	  puts "User: #{user_data[:name]}"
	# 	  puts "Toplam Saat: #{user_data[:total_hours]}"

	# 	  user_data[:time_entries].each do |time_entry|
	# 		puts "Hours: #{time_entry[:hours]}"
	# 		puts "Issue ID: #{time_entry[:issue_id]}"
	# 	  end

	# 	  puts '-' * 20 # Kullanıcı bilgilerini ayırmak için bir çizgi ekledik
	# 	end
	  else
		puts 'User not found in this project.'
	  end

	  return data
	rescue => e
	  puts "Error: #{e.message}"
	  # Eğer bir hata oluştuysa, e.message ile hatanın açıklamasını alabilirsiniz
	end
  end


end
