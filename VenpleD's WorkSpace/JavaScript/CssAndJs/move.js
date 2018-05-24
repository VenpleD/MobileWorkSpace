function getStyle (obj, name) {
	if (obj.currentStyle) {
		return obj.currentStyle[name];
	} else {
		return getComputedStyle(obj, false)[name];
	}
}

function startMove(obj, attr, iTarget) {
	clearInterval(obj.timer);
	obj.timer = setInterval(function () {
		var currentValue;
		if (attr == 'opacity') {
			currentValue = Math.round(parseFloat(getStyle(obj, attr)) * 100);
		} else {
			currentValue = parseInt(getStyle(obj, attr));
		}
		var speed = (iTarget - currentValue) / 5;
		speed = speed > 0 ? Math.ceil(speed) : Math.floor(speed);

		if (currentValue == iTarget) {
			clearInterval(obj.timer);
		} else {
			if (attr == 'opacity') {
				obj.style[attr] = (currentValue + speed) / 100;
				obj.style['filter'] = 'alpha(opacity:'+ (currentValue + speed) +')';
			} else {
				obj.style[attr] = currentValue + speed + 'px';
			}
		}

	}, 30);
}