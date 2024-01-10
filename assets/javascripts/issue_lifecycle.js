document.addEventListener('DOMContentLoaded', async function () {
	let urlParams = new URLSearchParams(window.location.search);
	let projectId = urlParams.get('project_id');
	let chartContainer;
	let previousIssueId = null;
	let currentIssueId = null;

	if (!projectId) {console.error("Error! Project Id not found."); return;}
	try {
		const response = await fetch("/issue_lifecycle/data?project_id=" + projectId);
		const data = await response.json();

		let dataContainer = document.getElementById('dataContainer');
		dataContainer.innerHTML = formatDataAsHTML(data);

		$(document).ready(function () {
			new DataTable('#issuesTable', {
				info: false,
				paging: false,
				scrollCollapse: true,
				scrollY: '95vh',
				search: {
					return: true
				}
			});
		});
	} catch (error) {
		console.error("Data fetch Error!:", error);
	}

	function formatDataAsHTML(data) {
		let html = '<table id="issuesTable" class="table-striped cell-border" style="width:100%">';
		html += '<thead class="thead-dark" style="font-size:large;"><tr><th data-sortable="true">İş Numarası</th><th>Suanki Durum</th><th>Durumlar İçin Geçen Süre</th><th style="text-align:center;">Durum Değişiklikleri</th><th>Kategori</th></tr></thead>';
		html += '<tbody>';
		data.issues_data.forEach(function (issue) {
			html += '<tr class="table-row" data-issue=\'' + JSON.stringify(issue) + '\' > ';
			html += '<td class="isId2">' + issue.id + '</td>';
			html += '<td class="isId">' + (issue.status_now || '-') + '</td>';
			html += '<td class="issue-data" data-issue=\'' + JSON.stringify(issue.elapsed_time_status) + '\'>';
			issue.elapsed_time_status.forEach(function (elapsed_time, index) {
				var formattedTime = formatTime(elapsed_time.elapsed_hours, elapsed_time.elapsed_minutes);
				if (index < 2) {
					html += '<strong>' + elapsed_time.status_name + ':</strong> ' + formattedTime + '<br>';
				} else {
					html += '<span class="additional-time" style="display: none;"><strong>' + elapsed_time.status_name + ':</strong> ' + formattedTime + '<br></span>';
				}
			});
			if (issue.elapsed_time_status.length > 2) {
				html += '<button class="show-more-btn btn" data-toggle="collapse" data-target=".additional-time">...</button>';
			}
			html += '</td>';
			html += '<td class="issue-status" style="text-align:center;" data-issue=\'' + JSON.stringify(issue.status_changes) + '\'>';
			issue.status_changes.forEach(function (status_change, index) {
				if (index < 3) {
					html += status_change.from_status + ' <span style="font-size:x-large;">&#8594;</span> ' + status_change.to_status + ' ( <strong>' + status_change.changed_by + '</strong> tarafindan ) ' + ' <br>';
				} else {
					html += '<span class="additional-status" style="display: none;">' + status_change.from_status + ' <span style="font-size:x-large;">&#8594;</span> ' + status_change.to_status + ' <strong>(Değiştiren:</strong> ' + status_change.changed_by + ')<br></span>';
				}
			});
			if (issue.status_changes.length > 3) {
				html += '<button class="show-more-btn btn" data-toggle="collapse" data-target=".additional-status">...</button>';
			}
			html += '</td>';
			html += '<td>' + (issue.category || '-') + '</td>';
			html += '</tr>';
		});
		html += '</tbody>';
		html += '</table>';
		//html += '<p class="mt-4">Toplam Geçen Süre (Kategori): ' + data.total_elapsed_time_category + ' saat</p>';
		//html += '<p>User Spent Time: ' + data.user_spent_time + ' saat</p>';

		let categoryHtml = '<table class="table table-dark display table-striped" style="width:100%">';
			categoryHtml += '<thead class="thead-dark"><tr><th class="thCl" data-sortable="true">Kategori</th><th class="thCl">İş ID\'leri</th><th class="thCl" data-sortable="true">Toplam Geçen Süre (Saat)</th></tr></thead>';
			categoryHtml += '<tbody>';
			console.log(data);
			data.total_elapsed_time_category.forEach(function (category) {
				categoryHtml += '<td>' + (category.category || '-') + '</td>';
				categoryHtml += '<td class="isId" data-issue=\'' + JSON.stringify(category.issue_ids) + '\'>';
				category.issue_ids.forEach(function (id, index) {
					if (index < 3) {
						categoryHtml += '<strong>' + id + '</strong>' + '<br>';
					} else {
						categoryHtml += '<span class="additional-status" style="display: none;">' + id + '<br></span>';
					}
				});
				if (category.issue_ids.length > 3) {
					categoryHtml += '<button class="show-more-btn btn" data-toggle="collapse" data-target=".additional-status">...</button>';
				}
				categoryHtml += '</td>'
				categoryHtml += '<td class="totalHours">'
					let formattedTime = formatTime(category.total_elapsed_hours, category.total_elapsed_minutes);
					categoryHtml += formattedTime ;
				categoryHtml += '</td>';
				categoryHtml += '</tr>';
			});
			categoryHtml += '</tbody>';
			categoryHtml += '</table>';

			document.getElementById('categoryTableContainer').innerHTML = categoryHtml;

		return html;
	}

	function formatTime(hours, minutes) {
		let formattedTime = '';
		if (hours > 0) {
			formattedTime += hours + ' saat ';
		}
		formattedTime += minutes + ' dakika';
		return formattedTime;
	}

	async function createChart(labels, data, chartContainer, e)
	{
		let ctx = document.createElement('canvas').getContext('2d');
		ctx.canvas.style.width = '100%';
		ctx.canvas.style.height = '100%';
		ctx.canvas.style.display = 'block';
		ctx.canvas.style.margin = 'auto';

		chartContainer = await document.getElementById('issuesTable').insertRow(e.target.closest('tr').rowIndex + 1).insertCell(0);
		chartContainer.colSpan = 4;
		chartContainer.style.width = '100%'
		chartContainer.style.height = '500px'
		chartContainer.appendChild(ctx.canvas);

		new Chart(ctx, {
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
				}
			}
		});
		return chartContainer;
	}

	document.addEventListener('click', async function (e) {
		let target = e.target;
		if (target.tagName == 'TD')
			target = target.parentElement;
		if (target && target.classList.contains('table-row')) {
			let issueData = target.dataset.issue ? JSON.parse(target.dataset.issue) : null;
			if (!issueData) {console.error("Dataset not found"); return;}
			currentIssueId = issueData.id;
			let labels = [];
			let data = []

			issueData.elapsed_time_status.forEach(element => {
				const statusName = element.status_name;
				const statusTime = element.elapsed_hours + element.elapsed_minutes / 60;
				let index = labels.indexOf(statusName);
				if (index != -1)
					data[index] += statusTime;
				else {
					data.push(statusTime);
					labels.push(statusName);
				}
			})

			if (previousIssueId == currentIssueId) {
				let table = document.getElementById('issuesTable');
				let rowIndex = e.target.closest('tr').rowIndex;
				if (table.rows.length > rowIndex + 1) {
					table.deleteRow(rowIndex + 1);
				}
				previousIssueId = null;
				return;
			}
			if (chartContainer) {
				chartContainer.parentNode.removeChild(chartContainer);
			}
			previousIssueId = currentIssueId;

			chartContainer = await createChart(labels, data, chartContainer, e);
		}
	});

	$(document).on('click', '.show-more-btn', function () {
		$('.additional-time, .additional-status').toggle();
	});
});