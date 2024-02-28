document.addEventListener('DOMContentLoaded', async () => {
	let users = JSON.parse(document.querySelector('.usersChart').getAttribute('data-users'));

	let labels = [];
	let total = [];

	users.forEach(user => {
		labels.push(user.name);
		total.push(user.total_hours);
	});
	const data = {
		labels: labels,
		datasets: [{
		data: total,
		backgroundColor: await randomColors(labels),}]
	}
	const options = {
		responsive: true,
		maintainAspectRatio: false,
	}

	createChart(null, 'users-chart','doughnut', data, options);
});