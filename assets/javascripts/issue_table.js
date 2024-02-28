document.addEventListener('DOMContentLoaded', function() {
	let previousIssueId = null;
	let currentIssueId = null;
	let chartContainer;

	new DataTable('#issuesTable', {
		info: false,
		paging: false,
		scrollCollapse: true,
		scrollY: '95vh',
	});

	$(document).ready(function() {
		$('.table-row').click(async function(e) {
			var issueData = $(this).data('issue');
			if (!issueData) { console.error("Dataset not found"); return; }
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

			chartContainer.style.width = '100%';
			chartContainer.style.height = '500px';
			chartContainer.colSpan = 5;

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

			createChart(chartContainer, 'chart-canvas','pie', data, options);
		}
		);
	});
});