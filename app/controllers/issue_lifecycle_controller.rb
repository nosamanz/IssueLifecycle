# class IssueLifecycleController < ApplicationController
# 	before_action :find_project, only: [:index]

# 	def find_project
# 		puts "Find Project"
# 		@project = Project.find(params[:project_id])
# 	end

# 	def index
# 		issues = Issue.where(project_id: @project.id)
# 		for issue in issues
# 			puts "--------------------------------------------------------"
# 			puts "Issue: #{issue.id}"
# 			calculate_task_trackings(issue)
# 		end


# 		# @project = Project.find(params[:project_id])
# 		# puts "Project Name: #{@project.name}"
# 		# issues = @project.issues.includes(:journals)
# 		# puts "ISSUES: "
# 		# puts issues
# 		# @task_trackings = calculate_task_trackings(issues);


# 		# for task_trackings in @task_trackings
# 		# 	puts "Is ID: #{task_trackings[:issue_id]}"
# 		# 	puts "Is Durumu: #{task_trackings[:current_status].name}"
# 		# 	puts "Is icin harcanan zaman: #{task_trackings[:total_duration]} saat"
# 		# 	puts "-----------------------"
# 		# end




# 		# issue_id = 4  # İşin kimliği
# 		# issue = Issue.find(issue_id)
# 		# start_status_id = issue.status_id
# 		# start_status_name = IssueStatus.find(start_status_id).name

# 		# puts "Başlangıç Durumu: #{start_status_name}"

# 		# statuses = {}
# 		# current_status = start_status_name
# 		# total_duration = 0
# 		# previous_timestamp = issue.created_on

# 		# issue.journals.each do |journal|
# 		#   details = journal.details.select { |detail| detail.prop_key == 'status_id' }

# 		#   details.each do |detail|
# 		# 	elapsed_time = detail.created_on - previous_timestamp
# 		# 	elapsed_hours = (elapsed_time / 3600).to_i
# 		# 	elapsed_minutes = ((elapsed_time % 3600) / 60).to_i

# 		# 	formatted_duration = ''
# 		# 	formatted_duration += "#{elapsed_hours} saat " if elapsed_hours > 0
# 		# 	formatted_duration += "#{elapsed_minutes} dakika"

# 		# 	puts "#{current_status}: #{formatted_duration}"

# 		# 	total_duration += elapsed_hours + elapsed_minutes.to_f / 60

# 		# 	current_status = IssueStatus.find(detail.value).name
# 		# 	previous_timestamp = detail.created_on
# 		#   end
# 		# end

# 		# # İşin şu anki durumunu kontrol et
# 		# elapsed_time = Time.now - previous_timestamp
# 		# elapsed_hours = (elapsed_time / 3600).to_i
# 		# elapsed_minutes = ((elapsed_time % 3600) / 60).to_i

# 		# formatted_duration = ''
# 		# formatted_duration += "#{elapsed_hours} saat " if elapsed_hours > 0
# 		# formatted_duration += "#{elapsed_minutes} dakika"

# 		# puts "#{current_status} (Şu anki durum): #{formatted_duration}"

# 		# total_duration += elapsed_hours + elapsed_minutes.to_f / 60

# 		# puts "\nToplam Durum Süreleri:"
# 		# puts "#{current_status}: #{total_duration} saat"






# 		# puts issues
# 		# for issue in issues
# 		# 	puts "Is ID: #{issue.id}"
# 		# 	puts "Is Durumu: #{issue.status.name}"
# 		# 	puts "Is icin harcanan zaman: #{issue.total_spent_hours} saat"

# 		# 	category_name = issue.category.try(:name)
# 		# 	puts "Is kategorisi: #{category_name || 'Belirtilmemiş'}"

# 		# 	last_journal = issue.journals.last
# 		# 	last_updated_by = last_journal ? last_journal.user.name : 'Belirtilmemiş'
# 		# 	puts "Isin son guncelleyeni: #{last_updated_by}"

# 		# 	# Durum değişikliklerini kontrol et
# 		# 	# status_changes = issue.journals.where("notes LIKE '%changed the status%'").order(:created_on)
# 		# 	# puts "Isin durum degisiklikleri: #{status_changes.count}"
# 		# 	status_changes = issue.journals.where(notes: "status_id").order(created_on: :desc)
# 		# 	puts "Isin durum degisiklikleri: #{status_changes.count}"
# 		# 	puts status_changes

# 		# 	if status_changes.any?
# 		# 	  elapsed_time = status_changes.last.created_on - status_changes.first.created_on
# 		# 	  puts "Geçen süre: #{elapsed_time / 3600} saat" # Saat cinsinden
# 		# 	else
# 		# 	  puts "Geçen süre bilgisi bulunamadı."
# 		# 	end

# 		# 	puts "-----------------------"
# 		#   end


# 		# project_id = 1  # Projenin kimliği
# 		# issues = Issue.where(project_id: project_id)


# 		# if issues.any?
# 		# 	last_issue = issues.last
# 		# 	last_journal = last_issue.journals.last if last_issue.journals.any?
# 		# 	last_updated_by = last_journal.user.name if last_journal && last_journal.user
# 		# end



# 		# issue_statuses = issues.map { |issue| issue.status.name }
# 		# puts "Issue Statuses:"
# 		# puts issue_statuses
# 		# total_time_spent = issues.sum(&:total_spent_hours)
# 		# puts "Total Time Spent:"
# 		# puts total_time_spent
# 		# categories = issues.map { |issue| issue.category.try(:name) }
# 		# puts "Categories:"
# 		# puts categories
# 		# last_updated_by = issues.last.journals.last.user.name
# 		# puts "Last Updated By:"
# 		# puts last_updated_by
# 		# puts "PART 3"

# 		# all_users = issues.flat_map { |issue| issue.journals.map { |journal| journal.user.name } }.uniq

# 		# puts "All Users:"
# 		# puts all_users

# 		# puts "PART 4"

# 		# render json: {
# 		# 	issue_statuses: issue_statuses,
# 		# 	total_time_spent: total_time_spent,
# 		# 	categories: categories,

# 		# 	last_updated_by: last_updated_by,
# 		# 	# all_users: all_users

# 		# 	# Diğer bilgileri ekleyebilirsiniz
# 		#   }
# 		# puts "RENDER: "
# 		# respond_to do |format|
# 		# 	format.html { render :index }
# 		# 	format.json { render json: { issues: issues } }
# 		# end



# 	rescue ActiveRecord::RecordNotFound
# 	  flash[:error] = "Proje bulunamadı."
# 	end


# 	def calculate_task_trackings(issue)
# 		start_status_id = issue.status_id
# 		start_status_name = IssueStatus.find(start_status_id).name

# 		puts "Başlangıç Durumu: #{start_status_name}"

# 		statuses = {}
# 		current_status = start_status_name
# 		total_duration = 0
# 		previous_timestamp = issue.created_on

# 		issue.journals.each do |journal|
# 		details = journal.details.select { |detail| detail.prop_key == 'status_id' }

# 		details.each do |detail|
# 			elapsed_time = detail.created_on - previous_timestamp
# 			elapsed_hours = (elapsed_time / 3600).to_i
# 			elapsed_minutes = ((elapsed_time % 3600) / 60).to_i

# 			formatted_duration = ''
# 			formatted_duration += "#{elapsed_hours} saat " if elapsed_hours > 0
# 			formatted_duration += "#{elapsed_minutes} dakika"

# 			puts "#{current_status}: #{formatted_duration}"

# 			total_duration += elapsed_hours + elapsed_minutes.to_f / 60

# 			current_status = IssueStatus.find(detail.value).name
# 			previous_timestamp = detail.created_on
# 		end
# 		end

# 		# İşin şu anki durumunu kontrol et
# 		elapsed_time = Time.now - previous_timestamp
# 		elapsed_hours = (elapsed_time / 3600).to_i
# 		elapsed_minutes = ((elapsed_time % 3600) / 60).to_i

# 		formatted_duration = ''
# 		formatted_duration += "#{elapsed_hours} saat " if elapsed_hours > 0
# 		formatted_duration += "#{elapsed_minutes} dakika"

# 		puts "#{current_status} (Şu anki durum): #{formatted_duration}"

# 		total_duration += elapsed_hours + elapsed_minutes.to_f / 60

# 		puts "\nToplam Durum Süreleri:"
# 		puts "#{current_status}: #{total_duration} saat"
# 	end
# end

############################################################################################################

# class IssueLifecycleController < ApplicationController
# 	before_action :find_project, only: [:index]

# 	def find_project
# 	  puts "Find Project"
# 	  @project = Project.find(params[:project_id])
# 	end

# 	def index
# 	  issues = Issue.where(project_id: @project.id)
# 	  @task_trackings = []

# 	  issues.each do |issue|
# 		puts "--------------------------------------------------------"
# 		puts "Issue: #{issue.id}"
# 		task_tracking = calculate_task_trackings(issue)
# 		@task_trackings << task_tracking
# 	  end

# 	rescue ActiveRecord::RecordNotFound
# 		flash[:error] = "Proje bulunamadı."
# 	end

# 	def calculate_task_trackings(issue)

# 		# Issue'nun tüm günlüklerini al
# 		@journals = @issue.journals
# 		creation_note = @journals.first
# 		puts "creation_note:"
# 		puts creation_note
#     # İlk günlük hariç diğer tüm günlükleri al (ilk günlük genellikle yaratılış notudur)


# 		@past_notes = @journals[1..-1]
# 		 puts "past_notes"
# 		 puts @past_notes
# 		# issue.journals.order(:created_on).each do |journal|
# 		# 	# Journal içinde durum değişikliği var mı kontrol et
# 		# 	if journal.details.any? { |detail| detail.prop_key == 'status_id' }
# 		# 		status_id = journal.details.find { |detail| detail.prop_key == 'status_id' }.value
# 		# 		status = IssueStatus.find(status_id).name
# 		# 		puts "issue journal status_name: #{status}"
# 		# 		# Başlangıç zamanını güncelle
# 		# 		start_time = journal.created_on
# 		# 		puts "start time"
# 		# 		puts "start_time: #{start_time}"

# 		# 	end
# 		# end


# 		current_status_id = issue.status_id
# 		current_status_name = IssueStatus.find(current_status_id).name

# 		# puts "Başlangıç Durumu: #{current_status_name}"

# 		statuses = []
# 		total_duration = 0
# 		previous_timestamp = issue.created_on
# 		status_durations = []

# 		issue.journals.each do |journal|
# 		  details = journal.details.select { |detail| detail.prop_key == 'status_id' }

# 		  details.each do |detail|
# 			elapsed_time = journal.created_on - previous_timestamp
# 			elapsed_hours = (elapsed_time / 3600).to_i
# 			elapsed_minutes = ((elapsed_time % 3600) / 60).to_i

# 			formatted_duration = format_duration(elapsed_hours, elapsed_minutes)
# 			puts "#{current_status_name}: #{formatted_duration}"

# 			total_duration += elapsed_hours + elapsed_minutes.to_f / 60

# 			previous_status_name = current_status_name
# 			current_status_id = detail.value
# 			current_status_name = IssueStatus.find(current_status_id).name
# 			previous_timestamp = journal.created_on

# 			status_durations << {
# 			  from_status: previous_status_name,
# 			  to_status: current_status_name,
# 			  duration: elapsed_hours + elapsed_minutes.to_f / 60
# 			}
# 		  end
# 		end

# 		# İşin şu anki durumunu kontrol et
# 		elapsed_time = Time.now - previous_timestamp
# 		elapsed_hours = (elapsed_time / 3600).to_i
# 		elapsed_minutes = ((elapsed_time % 3600) / 60).to_i

# 		formatted_duration = format_duration(elapsed_hours, elapsed_minutes)
# 		puts "#{current_status_name} (Şu anki durum): #{formatted_duration}"

# 		total_duration += elapsed_hours + elapsed_minutes.to_f / 60

# 		status_durations << {
# 		  from_status: current_status_name,
# 		  to_status: current_status_name,
# 		  duration: elapsed_hours + elapsed_minutes.to_f / 60
# 		}

# 		puts "\nToplam Durum Süresi:"
# 		formatted_total_duration = format_duration(total_duration.to_i, ((total_duration - total_duration.to_i) * 60).to_i)
# 		puts "#{formatted_total_duration} saat (#{total_duration.to_i * 60 + (total_duration - total_duration.to_i) * 60} dakika)"

# 		{
# 		  issue_id: issue.id,
# 		  current_status: current_status_name,
# 		  total_duration: formatted_total_duration,
# 		  status_durations: status_durations
# 		}
# 	  end


# 	private

# 	def format_duration(hours, minutes)
# 	  formatted_duration = ''
# 	  formatted_duration += "#{hours} saat " if hours > 0
# 	  formatted_duration += "#{minutes} dakika"
# 	  formatted_duration
# 	end
#   end


############################################################################################################
# # app/controllers/issue_lifecycle_controller.rb
# class IssueLifecycleController < ApplicationController
# 	def index
# 	  project_id = params[:project_id]
# 	  @project = Project.find(project_id)

# 	  issues = @project.issues.includes(:journals)
# 	  @issue_lifecycles = issues.map { |issue| load_issue_lifecycle(issue.id) }

# 	  render json: @issue_lifecycles.map(&:to_h)
# 	end

# 	private

# 	def load_issue_lifecycle(issue_id)
# 	  issue_lifecycle = IssueLifecycle.new(issue_id)

# 	  # Issue'nin geçmiş durumlarını al
# 	  issue = Issue.find(issue_id)

# 	  # Başlangıç zamanını belirle
# 	  start_time = issue.created_on

# 	  # Süreyi saniye cinsinden elde edin.
# 	  duration_in_seconds = Time.now - start_time

# 	  # Süreyi saat ve dakikaya dönüştürün.
# 	  hours = duration_in_seconds / (60 * 60)
# 	  minutes = (duration_in_seconds / 60) % 60

# 	  # Süreyi yazdırın.
# 	  puts "Yeni durumu icin gecirilen sure: #{hours} saat #{minutes} dakika"

# 	  # Issue'nin journal kayıtlarını en eski kayıttan en yeni kayıta doğru işle
# 	  issue.journals.order(:created_on).each do |journal|
# 		# Journal içinde durum değişikliği var mı kontrol et
# 		if journal.details.any? { |detail| detail.prop_key == 'status_id' }
# 		  status_id = journal.details.find { |detail| detail.prop_key == 'status_id' }.value
# 		  status = IssueStatus.find(status_id).name

# 		  # Durumu güncelle ve geçen süreyi hesapla
# 		  issue_lifecycle.resolve_status(issue_lifecycle.current_status)
# 		  issue_lifecycle.update_status(status, start_time)

# 		  # Başlangıç zamanını güncelle
# 		  start_time = journal.created_on
# 		  puts "start time"
# 			puts "start_time: #{start_time}"
# 		  # Harcanan süreyi ekrana yazdır
# 		  puts "Issue #{issue_id}, Status: #{status}, Duration: #{format_duration(issue_lifecycle.current_status_duration)}"
# 		end
# 	  end

# 	  # Eğer issue çözülmediyse, son durumu güncelle
# 	  issue_lifecycle.resolve_status(issue_lifecycle.current_status) unless issue.closed?

# 	  # Eğer durum değişikliği yapılmamışsa ve issue varsa, başlangıç durumu ve süreyi ekrana yazdır
# 	  if issue.journals.empty? && issue.status.present?
# 		puts "Issue #{issue_id}, Status: #{issue.status.name}, Duration: #{format_duration(issue_lifecycle.current_status_duration)}"
# 	  end

# 	  issue_lifecycle
# 	end

# 	def format_duration(seconds)
# 	  hours, remainder = seconds.divmod(3600)
# 	  minutes, _ = remainder.divmod(60)
# 	  "#{format('%02d', hours)}:#{format('%02d', minutes)}:#{format('%02d', remainder % 60)}"
# 	end
#   end


############################################################################################################

	# journal.details.each do |detail|
	# 	if detail.property == 'attr' && detail.prop_key == 'status_id'
	# 	  previous_status = IssueStatus.find(detail.old_value).name if detail.old_value
	# 	  puts "Önceki Durum: #{previous_status}"
	# 	  previous_timestamp = journal.created_on
	# 	end

############################################################################################################

	#   print_status_duration('Başlangıç Durumu', previous_status, elapsed_time_since_creation)

	#   issue_data[:status_changes] << {
	# 	from_status:  IssueStatus.find(journal.details.first.old_value).name,
	# 	to_status: ,
	# 	duration: elapsed_time_since_creation
	#   }

############################################################################################################

	# Eğer bir önceki durum ve zaman damgası varsa, son durum değişikliğini işleyin
	#   if previous_status && previous_timestamp
	# 	elapsed_time = Time.now - previous_timestamp

	# 	print_status_duration(previous_status, 'Son Durum', elapsed_time)

	# 	issue_data[:status_changes] << {
	# 	  from_status: previous_status,
	# 	  to_status: 'Son Durum',
	# 	}
	#   end


############################################################################################################

class IssueLifecycleController < ApplicationController
	# before_action :find_project, only: [:index]
	before_action :find_project, only: [:data]

	def data
		issues_data = []
		total_elapsed_time_category = []
		issues = @project.issues.includes(:journals)
		user_spent_time = []

		issues.each do |issue|
		  issue_id = issue.id
		  status = issue.status.name
		  issue_category = issue.category.try(:name)
		  issue_creation_time = issue.created_on
		  user_ids = issue.journals.map { |journal| journal.user_id }.uniq
		  puts "user_ids: #{user_ids}, issue_id: #{issue_id}"

		  user_ids.each do |user_id|
			  hours = get_time_spent(user_id, issue.id)
			  user = User.find(user_id).name

			  puts "user_id: #{user_id}, user: #{user}, hours: #{hours}"
			  existing_user_entry = user_spent_time.find { |entry| entry[:user] == user }

			  if existing_user_entry
				existing_user_entry[:total_hours] += hours
			  else
				user_spent_time << {
				  user: user,
				  total_hours: hours
				}
			  end
		  end

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

		#   issue_data[:total_elapsed_time] = issue_data[:elapsed_time_status].sum { |status| status[:elapsed_time] }
		  issue_data[:total_elapsed_hours] = issue_data[:elapsed_time_status].sum { |status| status[:elapsed_hours] }
		  issue_data[:total_elapsed_minutes] = issue_data[:elapsed_time_status].sum { |status| status[:elapsed_minutes] }
		  issues_data << issue_data
		end

		total_elapsed_time_category = issues_data.group_by { |issue| issue[:category] }.map do |category, issues|
		  {
			category: category,
			# total_elapsed_time: issues.sum { |issue| issue[:total_elapsed_time] }
			issue_ids: issues.map { |issue| issue[:id] },
			total_elapsed_hours: issues.sum { |issue| issue[:total_elapsed_hours] },
			total_elapsed_minutes: issues.sum { |issue| issue[:total_elapsed_minutes] }
		  }
		end
		  respond_to do |format|
			  format.json { render json: { issues_data: issues_data, total_elapsed_time_category: total_elapsed_time_category, user_spent_time: user_spent_time } }
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

end
