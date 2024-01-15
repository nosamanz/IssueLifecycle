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
		dataContainer.innerHTML = await issueTableHTML(data.issues_data);


		$(document).ready(function () {
			let a = new DataTable('#issuesTable', {
				info: false,
				paging: false,
				scrollCollapse: true,
				scrollY: '95vh',
				search: {
					return: true
				},
				// columns: [
				// 	null,null,null,
				// 	{ orderable: false },null
				// ],
			});
			// a.on('order.dt', function (e, settings, order) {
				// 	if (order && order.length > 0 && order[0].col === 2) {
					// 		console.log("OZEL SIRALAMA")
					// 		// Burada özel sıralama mantığını tanımlayın
					// 		// Örneğin, bir özel veri özelliği veya veri kullanarak sıralama yapabilirsiniz
					// 		// Örneğin, özel bir veri özelliğiniz 'data-custom-sort' ise şu şekilde kullanabilirsiniz:
			// 		// order[0][0] = { attr: 'data-custom-sort', order: 'asc' };
			// 		order[0][0] = { data: 2, type: 'elapsed-time' };
			// 	}
			// });
			// $.fn.dataTable.ext.order['elapsed-time'] = function (settings, col) {
				// 	return this.api().column(col, { order: 'index' }).nodes().map(function (td, i) {
					// 		const elapsedData = $(td).find('.issue-data').data('issue');
					// 		return elapsedData ? elapsedData.reduce((sum, entry) => sum + entry.elapsed_time, 0) : 0;
					// 	});
					// };
				});

				dataContainer = document.getElementById('projectName');
				dataContainer.innerHTML = data.project_name;

				createCategoryChart(data.issues_data);

				dataContainer = document.getElementById('categoryTableContainer');
				dataContainer.innerHTML = await categoryTableHTML(data.total_elapsed_time_category);

				console.log(data.user_spent_time);
				dataContainer = document.getElementById('userTableContainer');
				dataContainer.innerHTML = await userTableHTML(data.user_spent_time);
				createUserChart(data.user_spent_time);

		dataContainer = document.getElementById('totalSpentTime');
		dataContainer.innerHTML = await userTSTHTML(data.user_spent_time.users);

	} catch (error) {
		console.error("Data fetch Error!:", error);
	}

	async function userTSTHTML(data)
	{
		let totalTST = 0;
		data.forEach(element => {
			totalTST += element.total_hours;
		})
		console.log(totalTST);
		let ttHTML = translations.label_total_spent_time + totalTST + translations.label_hour;
		return ttHTML;
	}

	async function createUserChart(user_st)
	{
		let labels = [];
		let total = [];
		user_st.users.forEach(user => {
			labels.push(user.name);
			total.push(user.total_hours);
		});
        const data = {
          labels: labels,
          datasets: [{
            data: total,
            backgroundColor: await randomColors(labels),
          }]
        }
        const options = {
          responsive: true,
          maintainAspectRatio: false,
        }
		createChart('doughnut', data, options, null, 'userChart');
	}

	async function userTableHTML(user_st)
	{
		let userStHTML = '<table class="table table-dark display table-striped" style="width:100%">';
		userStHTML += '<thead class="thead-dark"><tr><th class="thCl" data-sortable="true">' + translations.label_user + '</th>';
		userStHTML += '<th class="thCl">' + translations.label_issue_numbers + '</th>';
		userStHTML += '<th class="thCl" data-sortable="true">' + translations.label_spent_time + '</th></tr></thead>';
		userStHTML += '<tbody>';
		user_st.users.forEach(function (user) {
				userStHTML += '<td>' + (user.name || '-') + '</td>';
				userStHTML += '<td class="isId" data-issue=\'' + JSON.stringify(user.time_entries) + '\'>';
				user.time_entries.forEach(function (i, index) {
					if (index < 3) {
						userStHTML += '<strong>' + translations.label_issue + ' #' + i.issue_id + ' : ' + '</strong>' + i.hours + translations.label_hour + '<br>';
					} else {
						userStHTML += '<span class="additional-status" style="display: none;">' + '#' + i.issue_id + ' : ' + '</strong>' + i.hours + translations.label_hour + '<br></span>';
					}
				});
				if (user.time_entries.length > 3) {
					userStHTML += '<button class="show-more-btn btn" data-toggle="collapse" data-target=".additional-status">...</button>';
				}
				userStHTML += '</td>'
				userStHTML += '<td class="totalHours">'
				userStHTML += user.total_hours + ' saat' ;
				userStHTML += '</td>';
				userStHTML += '</tr>';
			});
			userStHTML += '</tbody>';
			userStHTML += '</table>';
			return userStHTML;
	}

	async function issueTableHTML(issues_data)
	{
		let html = '<table id="issuesTable" class="table-dark display table-striped" style="width:100%">';
		html += '<thead class="thead-dark" style="font-size:large;"><tr>';
		html += '<th>'+ translations.label_issue_number + '</th>';
		html += '<th>' + translations.label_current_status + '</th>';
		html += '<th>' + translations.label_elapsed_time_for_statuses + '</th>';
		html += '<th style="text-align:center;">' + translations.label_status_changes + '</th>';
		html += '<th>' + translations.label_category + '</th></tr></thead>';
		html += '<tbody>';
		issues_data.forEach(function (issue) {
			html += '<tr class="table-row" data-issue=\'' + JSON.stringify(issue) + '\' > ';
			html += '<td class="isId2">' + issue.id + '</td>';
			html += '<td class="isId">' + (issue.status_now || '-') + '</td>';
			html += '<td class="issue-data" data-issue=\'' + JSON.stringify(issue.elapsed_time_status) + '\'>';
			issue.elapsed_time_status.sort(function(a, b) {
				return a.elapsed_hours - b.elapsed_hours || a.elapsed_minutes - b.elapsed_minutes;
			});
			issue.elapsed_time_status.forEach(function (elapsed_time, index) {
				var formattedTime = formatTime(elapsed_time.elapsed_hours, elapsed_time.elapsed_minutes);
				if (index < 2) {
					html += '<strong>' + elapsed_time.status_name + ': </strong> ' + formattedTime + '<br>';
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
					html += status_change.from_status + ' <span style="font-size:x-large;">&#8594;</span> ' + status_change.to_status + ' ( ' + translations.label_byen + '<strong>' + status_change.changed_by + '</strong> ' + translations.label_bytr + ') ' + ' <br>';
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
		return html;
	}

	async function categoryTableHTML(total_elapsed_time_category)
	{
		let categoryHtml = '<table class="table table-dark display table-striped" style="width:100%">';
		categoryHtml += '<thead class="thead-dark"><tr><th class="thCl" data-sortable="true">' + translations.label_category + '</th>';
		categoryHtml += '<th class="thCl">' + translations.label_issue_numbers + '</th>';
		categoryHtml += '<th class="thCl" data-sortable="true">' + translations.label_total_elapsed_time + '</th></tr></thead>';
		categoryHtml += '<tbody>';
		total_elapsed_time_category.forEach(function (category) {
				categoryHtml += '<td>' + (category.category || '-') + '</td>';
				categoryHtml += '<td class="isId" data-issue=\'' + JSON.stringify(category.issue_ids) + '\'>';
				category.issue_ids.forEach(function (id, index) {
					if (index < 3) {
						categoryHtml += '<strong>'+ '# ' + id + '</strong>' + '<br>';
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

			return categoryHtml;
	}


	async function createCategoryChart(issues)
	{
		let labels2 = [];

		let issuesData = await Promise.all(issues.map(async issue => {
			if (!labels2.some(label => label === issue.category))
			labels2.push(issue.category);
		return {
				label: translations.label_issue + ' #' + issue.id,
				category: issue.category,
				duration: issue.total_elapsed_hours + Math.floor(issue.total_elapsed_minutes) / 60,
				backgroundColor: await randomColors(null)
			};
		}));

		const data2 = {
			labels: labels2,
			datasets: issuesData.map(issue => ({
			label: issue.label,
			data: labels2.map((label) => (label === issue.category ? issue.duration : 0)),
			backgroundColor: [issue.backgroundColor],
		})),
		};

		const options = {
			plugins: {
				title: {
					display: true,
					// text: 'Chart.js Bar Chart - Stacked',
				},
			},
			responsive: true,
			maintainAspectRatio: false,
			scales: {
				x: {
					stacked: true,
				},
				y: {
					stacked: true,
				},
			},
		}

		createChart('bar', data2, options, null, 'categoryChart');
	}


	function formatTime(hours, minutes) {
		let formattedTime = '';
		if (minutes >= 60)
		{
			tmp = minutes;
			hours += Math.floor(minutes / 60);
			minutes = (tmp % 60);
		}
		if (hours > 0) {
			formattedTime += hours + translations.label_hour;
		}
		formattedTime += minutes + translations.label_minute;
		return formattedTime;
	}

	async function createChart(type, data, options, chartContainer, element)
	{
		let ctx = document.createElement('canvas').getContext('2d');
		if (element === 'categoryChart')
			document.getElementById('categoryChart').appendChild(ctx.canvas);
		else if (element === 'userChart')
			document.getElementById('userChart').appendChild(ctx.canvas);
		else
			chartContainer.appendChild(ctx.canvas);

		new Chart(ctx, {
			type: type,
			data: data,
			options: options
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

			chartContainer = await document.getElementById('issuesTable').insertRow(e.target.closest('tr').rowIndex + 1).insertCell(0);
			chartContainer.colSpan = 4;
			chartContainer.style.width = '100%'
			chartContainer.style.height = '500px'

			data = {
				labels: labels,
				datasets: [{
					data: data,
					backgroundColor: await randomColors(labels)
				}]
			}

			options = {
				responsive: true,
				maintainAspectRatio: false,
				legend: {
					labels: {
						fontSize: 50
					}
				}
			}

			chartContainer = await createChart('pie', data, options, chartContainer);
		}
	});

	$(document).on('click', '.show-more-btn', function () {
		$('.additional-time, .additional-status').toggle();
	});

	async function randomColors(labels)
	{
		let rColor;
		if (labels)
		{
			rColor = labels.map(() =>
			'rgba(' +
			Math.floor(Math.random() * 256) + ',' +
			Math.floor(Math.random() * 256) + ',' +
			Math.floor(Math.random() * 256) + ')');
		}
		else{
			rColor = 'rgba(' +
				Math.floor(Math.random() * 256) + ',' +
				Math.floor(Math.random() * 256) + ',' +
				Math.floor(Math.random() * 256) + ')'
		}
		return rColor;
	}
});