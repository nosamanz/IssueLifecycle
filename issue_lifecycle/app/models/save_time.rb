class SaveTime < ActiveRecord::Base
	def self.save_elapsed_time_status(issue_data, status_name, elapsed_time)
		hours = 0;
		if (elapsed_time / 3600) > 0
			hours = (elapsed_time / 3600).to_i
		end
		minutes = ((elapsed_time % 3600) / 60).to_i

		issue_data[:elapsed_time_status] << {
			status_name: status_name,
			elapsed_hours: hours,
			elapsed_minutes: minutes,
		}
	end

	def self.save_status_changes(issue_data, previous_status, current_status, changed_by)
		issue_data[:status_changes] << {
			from_status: previous_status,
			to_status: current_status,
			changed_by: changed_by
		}
	end

	def self.total_elapsed_time_category(issues_data)
		total_elapsed_time_category = []
		total_elapsed_time_category = issues_data.group_by { |issue| issue[:category] }.map do |category, issues|
		{
			category: category,
			issue_ids: issues.map { |issue| issue[:id] },
			total_elapsed_hours: issues.sum { |issue| issue[:total_elapsed_hours] },
			total_elapsed_minutes: issues.sum { |issue| issue[:total_elapsed_minutes] }
		}
		end
	end
end