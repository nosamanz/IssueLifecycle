document.addEventListener('DOMContentLoaded', function () {
	var urlParams = new URLSearchParams(window.location.search);
	var projectId = urlParams.get('project_id');
	var charts = [];
	var chartContainer;
	var chartVisibleIndex = -1;

	if (projectId) {
		fetch("/issue_lifecycle/data?project_id=" + projectId)
			.then(response => response.json())
			.then(data => {
				var dataContainer = document.getElementById('dataContainer');
				dataContainer.innerHTML = formatDataAsHTML(data);

				$(document).ready(function () {
					//$('#issuesTable').DataTable();
					new DataTable('#issuesTable', {
					});
				});
			})
			.catch(error => console.error("Veri çekme hatası:", error));
	} else {
		console.error("Proje ID'si URL'de bulunamadı.");
	}

	function formatDataAsHTML(data) {
		var html = '<table id="issuesTable" class="table table-light table-sm">';
		html += '<thead class="thead-light"><tr><th data-sortable="true">İş Numarası</th><th>Suanki Durum</th><th>Durumlar İçin Geçen Süre</th><th>Durum Değişiklikleri</th><th>Kategori</th></tr></thead>';
		html += '<tbody>';

		data.issues_data.forEach(function (issue) {
			html += '<tr>';
			html += '<td>' + issue.id + '</td>';
			html += '<td>' + (issue.status_now || '-') + '</td>';
			html += '<td class="issue-data" data-issue=\'' + JSON.stringify(issue.elapsed_time_status) + '\'>';
			issue.elapsed_time_status.forEach(function (elapsed_time) {
				var formattedTime = formatTime(elapsed_time.elapsed_hours, elapsed_time.elapsed_minutes);
				html += '<strong>' + elapsed_time.status_name + ':</strong> ' + formattedTime + '<br>';
			});
			html += '</td>';
			html += '<td>';
			issue.status_changes.forEach(function (status_change) {
				html += '<strong>Değişiklik:</strong> ' + status_change.from_status + ' -> ' + status_change.to_status + ' <strong>(Değiştiren:</strong> ' + status_change.changed_by + ')<br>';
			});
			html += '</td>';
			html += '<td>' + (issue.category || '-') + '</td>';
			html += '</tr>';
		});
		html += '<tfoot><tr><th>abc</th><th>abc</th><th>abc</th><th>abc</th><th>abc</th></tr></thfoot>'
		html += '</tbody>';
		html += '</table>';
		html += '<p class="mt-4">Toplam Geçen Süre (Kategori): ' + data.total_elapsed_time_category + ' saat</p>';
		html += '<p>User Spent Time: ' + data.user_spent_time + ' saat</p>';

		return html;
	}

	function formatTime(hours, minutes) {
		var formattedTime = '';
		if (hours > 0) {
			formattedTime += hours + ' saat ';
		}
		formattedTime += minutes + ' dakika';
		return formattedTime;
	}

	document.addEventListener('click', function (e) {

		if (e.target && e.target.classList.contains('issue-data')) {
			var issueData = JSON.parse(e.target.dataset.issue);
			var labels = issueData.map(function (elapsed_time) { return elapsed_time.status_name; });
			var data = issueData.map(function (elapsed_time) { return elapsed_time.elapsed_hours * 60 + elapsed_time.elapsed_minutes; });

			// Mevcut grafiği gizle
			if (chartVisibleIndex !== -1) {
				charts[chartVisibleIndex].canvas.style.display = 'none';

				// Eklenen satırı ve grafiği kaldır
				var table = document.getElementById('issuesTable');
				var rowIndex = e.target.closest('tr').rowIndex;
				if (table.rows.length > rowIndex + 1) {
					table.deleteRow(rowIndex + 1);
				}

				// Eklenen grafik varsa kaldır
				if (chartContainer) {
					chartContainer.parentNode.removeChild(chartContainer);
				}
			}

			// Yeni grafiği oluştur
			var ctx = document.createElement('canvas').getContext('2d');
			chartContainer = document.getElementById('issuesTable').insertRow(e.target.closest('tr').rowIndex + 1).insertCell(0);
			chartContainer.colSpan = 4;
			chartContainer.appendChild(ctx.canvas);

			var newChart = new Chart(ctx, {
				type: 'pie',
				data: {
					 labels: labels,
					 datasets: [{
						 data: data,
						 backgroundColor: ['#ff6384', '#36a2eb', '#cc65fe', '#ffce56', '#9CCC65', '#FFA726']
					 }]
				},
				options: {
					responsive: true,
					maintainAspectRatio: false,
					legend: {
						labels: {
							fontSize: 50
						}
					}}});

			charts.push(newChart);
			chartVisibleIndex = charts.length - 1;
		}
	});
});