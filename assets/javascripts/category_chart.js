document.addEventListener('DOMContentLoaded', async () => {
	let issues = JSON.parse(document.querySelector('.categoryChart').getAttribute('data-issue'));

	let labels = [];

	issues = issues.filter(issues => issues.category !== null);

	let issuesData = await Promise.all(issues.map(async issue => {
		if (!labels.some(label => label === issue.category))
		labels.push(issue.category);
	return {
			label: translations.label_issue + ' #' + issue.id,
			category: issue.category,
			duration: issue.total_elapsed_hours + Math.floor(issue.total_elapsed_minutes) / 60,
			backgroundColor: await randomColors(null)
		};
	}));

	const data = {
		labels: labels,
		datasets: issuesData.map(issue => ({
		label: issue.label,
		data: labels.map((label) => (label === issue.category ? issue.duration : 0)),
		backgroundColor: [issue.backgroundColor],
	})),
	};

	const options = {
		plugins: {
			title: {
				display: true,
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

	createChart(null, 'category-chart','bar', data, options);
});