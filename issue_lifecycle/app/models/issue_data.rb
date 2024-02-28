class IssueData < ActiveRecord::Base

	def self.project_details(project)
		data = { users: [] }

		begin
			if project.time_entries.any?
				users_data = {}

				project.time_entries.each do |time_entry|
					user_id = time_entry.user_id
					user_data = users_data[user_id] ||= {
						name: time_entry.user.name,
						total_hours: 0,
						time_entries: []
					}

					user_data[:total_hours] += time_entry.hours
					user_data[:time_entries] << { hours: time_entry.hours, issue_id: time_entry.issue_id }
				end

				data[:users] = users_data.values
			else
				puts 'No time entries found for this project.'
			end

			return data
		rescue => e
			puts "Error: #{e.message}"
		end
	end

	def self.issue_properties(project)

		issues_data = []

		project.issues.each do |issue|
			issue_id = issue.id
			status = issue.status.name
			issue_category = issue.category.try(:name)
			issue_creation_time = issue.created_on

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
				SaveTime.save_elapsed_time_status(issue_data, status, elapsed_time_since_creation)
			end

			issue_data[:total_elapsed_hours] = issue_data[:elapsed_time_status].sum { |status| status[:elapsed_hours] }
			issue_data[:total_elapsed_minutes] = issue_data[:elapsed_time_status].sum { |status| status[:elapsed_minutes] }
			issues_data << issue_data
		end

		return issues_data
	end


	def self.process_journals(journals, issue_data)
		begin
			previous_status = nil
			previous_timestamp = nil

			journals.each_with_index do |journal, index|
				next if journal.details.empty? || journal.details.first.prop_key != 'status_id'

				detail = journal.details.find { |d| d.property == 'attr' && d.prop_key == 'status_id' }
				next unless detail

				current_status = IssueStatus.find(detail.value).name
				previous_status = IssueStatus.find(detail.old_value).name if detail.old_value
				elapsed_time = journal.created_on - (previous_timestamp || issue_data[:created_on])

				SaveTime.save_elapsed_time_status(issue_data, previous_status, elapsed_time) if previous_status && elapsed_time
				SaveTime.save_status_changes(issue_data, previous_status, current_status, journal.user.name)

				if index == journals.size - 1
					elapsed_time = Time.now - journal.created_on
					current_status = IssueStatus.find(journal.details.last.value).name
					SaveTime.save_elapsed_time_status(issue_data, current_status, elapsed_time)
				end

				previous_timestamp = journal.created_on
			end
		rescue => e
			puts "Unexpected error occurred - #{e.message}"
		end
	end
end