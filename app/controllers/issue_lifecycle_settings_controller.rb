class IssueLifecycleSettingsController  < ApplicationController
	def save

		puts "Save eylemi çalıştı!"
		Rails.logger.info "Save eylemi çalıştı!"
		puts "------------------SAVE-----------------"
		api_key = params[:api_key]
		redmine_url = params[:redmine_url]

		puts "-----api_key: #{api_key}"
		puts "---redmine_url: #{redmine_url}"

		# API anahtarını ve Redmine URL'sini kaydet
		Setting.plugin_issue_lifecycle['api_key'] = api_key
		Setting.plugin_issue_lifecycle['redmine_url'] = redmine_url
		Setting.plugin_issue_lifecycle.save

		# Gerekli işlemleri gerçekleştir (örneğin, kullanıcının girdiği değerleri kullanarak Redmine ile iletişim kurma)
		# ...

		# redirect_to , notice: 'Ayarlar başarıyla kaydedildi. (save)'
	  end
  end
