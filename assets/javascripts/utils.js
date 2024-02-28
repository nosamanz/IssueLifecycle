async function createChart(container, elementID, type, data, options)
{
	let canvas = document.getElementById(elementID);
	if (container)
	{
		container.appendChild(canvas);
	}
	canvas.style.display = 'block';
	let ctx = canvas.getContext('2d');
	new Chart(ctx, {
		type: type,
		data: data,
		options: options,
	});
}

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

document.querySelectorAll('.showMoreBtn').forEach(function(button) {
	button.addEventListener('click', function() {

		let display = 'inline-block';
		let additional = this.parentNode.querySelectorAll('.additional');

		if (this.id == 'it')
			display = 'block';

		additional.forEach(function(add) {
			add.style.display = (add.style.display === 'none') ? display : 'none';
		});
		this.textContent = '...'
	});
});