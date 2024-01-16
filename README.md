
# What is the IssueLifecycle plugin and HOW TO INSTALL ?
[English Documentation](#english-documentation) → [How to Install](#how-to-install)

[Türkçe Dokümantasyon](#türkçe-dökümantasyon) → [Nasıl Yüklenir](#nasıl-yüklenir)

### This plugin supports two languages 
- English <img width="16" height="16" alt="flag" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/5751fe11-a768-4977-8b27-d36cb356295d"> & Turkish <img width="16" height="16" alt="Turkish flag" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/74aaf55f-081a-44fc-b6ba-519007c1988e">

<img width="500" alt="image" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/cb81c0fb-575e-41cf-871a-b40b5bb2a5ef">
<img width="500" alt="image" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/d783ff76-a5a4-47eb-919a-1df9ee0fd3a1">
<img width="500" height="260" alt="image" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/aa88e197-dcf7-4e0d-b055-eb93cb5b8d2b">
<img width="500" alt="image" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/47dd7fb9-dc90-49d3-b98a-03443764cb94">

# English Documentation

IssueLifecycle is a plugin for Redmine, a issue tracking system. For each project in Redmine, it adds a new link to the top menu (the menu with links to Overview, Issues, Wiki, etc.). When this link is clicked, it lists in a table the life cycle of the status changes of the issue records in that project, such as how long it has been in which issue status, the category of the issue, and which user made the status change. In addition to this table, when a issue is clicked on in the table, it contains a graph showing the time elapsed in the status of that issue. Apart from this table, there is also a table and a graph showing the sum of the time elapsed in the states of the issues divided by categories. Finally, at the bottom there is a table and graph showing the time spent by users on issues and their time totals.

## How to Install
!!! First of all, you must have a ready and installed Redmine (version 5.1.1 or higher)

Download the plugin with git clone or as a zip file.

<div>
  <button class="copy-button" onclick="copyToClipboard('git clone "clone_url"')"></button>
  <pre><code id="copyable-code">git clone "clone_url"</code></pre>

</div>

### Install with Bash Script

I. Copy the downloaded file into the directory where Redmine is installed and then;

<div>
  <button class="copy-button" onclick="copyToClipboard('bash install-uninstall.sh install')"></button>
  <pre><code id="copyable-code">bash install-uninstall.sh install</code></pre>
</div>

II. To Remove the Plugin;

<div>
  <button class="copy-button" onclick="copyToClipboard('bash install-uninstall.sh uninstall')"></button>
  <pre><code id="copyable-code">bash install-uninstall.sh uninstall</code></pre>
</div>

III. If the plugin has been successfully installed, you can now delete the downloaded file (installation file).

### Manual Installation 

1. Copy the folder named "issue_lifecycle" inside the downloaded plugin folder (if it's zip, you should extract it to a folder) into the folder named "/plugins" in the directory where Redmine is installed. (redmine_path/plugins/issue_lifecycle)

<div>
  <button class="copy-button" onclick="copyToClipboard('cp issue_lifecycle redmine_path/plugins')"></button>
  <pre><code id="copyable-code">cp issue_lifecycle redmine_path/plugins</code></pre>
  <pre>redmine_path/plugins/
  └── issue_lifecycle</code></pre>
</div>

2. Create a folder named "issue_lifecycle" in "public/plugin_assets" in the directory where Redmine is installed. Then copy the files in "assets" in the file you downloaded and paste them into "issue_lifecycle".

<div>
  <button class="copy-button" onclick="copyToClipboard('mkdir redmine_path/public/plugin_assets/issue_lifecycle')"></button>
  <button class="copy-button" onclick="copyToClipboard('cp assets/* redmine_path/public/plugin_assets/issue_lifecycle')"></button>
  <pre><code id="copyable-code">mkdir redmine_path/public/plugin_assets/issue_lifecycle</code></pre>
  <pre><code id="copyable-code">cp assets/* redmine_path/public/plugin_assets/issue_lifecycle</code></pre>

  <pre><code>redmine_path/public/plugin_assets/issue_lifecycle/
  ├── javascripts
  └── stylesheets</code></pre>
</div>



-> After all these steps, the plugin should appear when you click on "Plugins" in the "Administration" tab at the top of the Redmine page (you must be logged in as admin).

<img width="498" alt="image" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/d9836826-b504-479b-aef5-512c86dd2361">

-> Now you can activate the plugin for the project. (If you are creating a new project, you can activate it at the bottom when creating. If you already have a project, don't forget to activate it in the settings section of the project).

<img width="320" height="320" alt="image" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/f9efd634-da7d-4d3e-b666-8bcd4ff7b8cb">
<img width="425" alt="Ekran görüntüsü 2024-01-16 194819" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/6b0d7614-fad5-4e0c-ad88-fc5ad5f4a029">

-> You can access the plugin from the Project page...

<img width="250" alt="Ekran görüntüsü 2024-01-16 195229" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/3d211a8a-31ce-4dd8-a99a-17d481992a67">

# Türkçe Dökümantasyon

IssueLifecycle bir iş takip sistemi olan Redmine'a eklenti olarak geliştirilmiştir. Redmine da bulunan her proje için üst menüye (Overview, Issues, Wiki vs. linklerinin olduğu menü) yeni bir bağlantı ekler. Bu bağlantıya tıklandığında o projedeki iş kayıtlarının durum değişikliklerinin hayat döngüsünü, hangi is durumunda ne kadar zaman durdugu, isin kategorisi, durum degisikligini hangi kullanicinin yaptigi gibi bilgileri bir tabloda listeler. Bu tabloya ek olarak, tabloda bir ise tiklandiginda o işteki durumlarda gecen sureleri gosteren bir grafik barindirir. Bu tablodan ayri olarak bir de kategorilere gore ayrilmis sekilde bulunan işlerin , durumlarinda gecen sure toplamlarini gosteren bir tablo ve bu tablonun grafigi bulunmakta. Son olarak da en alt kisimda  kullanicilarin islerde harcadiklari zaman ve zaman toplamlarini gosteren tablo ve grafik gosterilmektedir.

## Nasıl Yüklenir
!!! Öncelikle hazir ve kurulu bir Redmine a sahip olmalisiniz. (5.1.1 veya daha üst bir sürüm)

Git clone ile ya da zip dosyasi olarak eklentiyi indiriyoruz.

<div>
  <button class="copy-button" onclick="copyToClipboard('git clone "clone_url"')"></button>
  <pre><code id="copyable-code">git clone "clone_url"</code></pre>
</div>

### Bash Script İle Kurma

I. İndirdiğimiz dosyayı Redmine'ın kurulu olduğu dizinin içine atiyoruz ve ardından;

<div>
  <button class="copy-button" onclick="copyToClipboard('bash install-uninstall.sh install')"></button>
  <pre><code id="copyable-code">bash install-uninstall.sh install</code></pre>
</div>

II. Eklentiyi Kaldirmak için;

<div>
  <button class="copy-button" onclick="copyToClipboard('bash install-uninstall.sh uninstall')"></button>
  <pre><code id="copyable-code">bash install-uninstall.sh uninstall</code></pre>
</div>

III. Eklenti başarılı bir şekilde kurulduysa indirdiğimiz (yükleme dosyası) dosyayı artık silebilirsiniz.


### Manuel Kurulum

1. İndirdiğimiz eklenti klasörümüzün (zip ise bir klasore cikariyoruz) içindeki "issue_lifecycle" adlı klasörümüzü Redmine'in kurulu olduğu dizinin içindeki "/plugins" adlı klasörün içine atıyoruz/kopyalıyoruz. (redmine_path/plugins/issue_lifecycle)

<div>
  <button class="copy-button" onclick="copyToClipboard('cp issue_lifecycle redmine_path/plugins')"></button>
  <pre><code id="copyable-code">cp issue_lifecycle redmine_path/plugins</code></pre>
  <pre>redmine_path/plugins/
  └── issue_lifecycle</code></pre>
</div>

2. Redmine'ın kurulu olduğu dizinin içinde bulunan "public/plugin_assets" 'in içine "issue_lifecycle" adında bir klasör oluşturuyoruz. Ardından indirdiğimiz dosyada "assets"in içindeki dosyaları ("javascripts" ve "stylesheets") kopyaliyoruz ve "issue_lifecycle" in yapıştırıyoruz.

<div>
  <button class="copy-button" onclick="copyToClipboard('mkdir redmine_path/public/plugin_assets/issue_lifecycle')"></button>
  <button class="copy-button" onclick="copyToClipboard('cp assets/* redmine_path/public/plugin_assets/issue_lifecycle')"></button>
  <pre><code id="copyable-code">mkdir redmine_path/public/plugin_assets/issue_lifecycle</code></pre>
  <pre><code id="copyable-code">cp assets/* redmine_path/public/plugin_assets/issue_lifecycle</code></pre>
  <pre><code>redmine_path/public/plugin_assets/issue_lifecycle/
  ├── javascripts
  └── stylesheets</code></pre>
</div>



-> Tum bu işlemlerden sonra Redmine sayfasının üst kısmında bulunan "Yönetim" sekmesindeki (admin olarak giriş yapmış olmalısınız) "Eklentiler" kısmına tıkladığımızda eklentimiz görünüyor olmalı.

<img width="526" alt="image" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/7489786f-4629-412c-8641-4e9068b919c7">

-> Artık eklentimizi proje için aktif edebiliriz. (Eğer yeni bir proje oluşturuyorsanız oluştururken alt kısımdan aktif edebilirsiniz. Zaten olan bir projeniz varsa projenin ayarlar kısmından aktif etmeyi unutmayın.)

<img width="300" alt="newproject" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/a440881e-b34e-4390-89a7-7b5b8c3a6568">
<img width="425" alt="newprojectt" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/ca5e2399-0b2c-4b08-9b64-57bd4160be55">

-> Eklentiye Projenin sayfasindan ulaşabilirsiniz...

<img width="250" alt="Ekran görüntüsü 2024-01-16 182120" src="https://github.com/nosamanz/IssueLifecycle/assets/62108864/029c1172-5e95-46e7-85eb-3b48b2a40018">
