var WeakMap = require('es6-weak-map');

var handlers = new WeakMap();
var anyHandlers = new WeakMap();

function privateVal(map, val = {}) {
	return function() {
		if(!map.get(this)) map.set(this, val);
		return map.get(this);
	}
}

//TODO store handlers in a tree
module.exports = {
	emit(type, ...args) {
		var [evt, ...sub] = Array.isArray(type) ? type : type.split(':');
		var handlers = this.getHandlers(evt).concat(evt !== type ? this.getHandlers(type) : []);
		handlers.forEach(handler => {
			handler(...sub, ...args);
		});
		this.anyHandlers().forEach(handler => {
			handler(type, ...args);
		});
	},

	handlers: privateVal(handlers),
	anyHandlers: privateVal(anyHandlers, []),

	getHandlers(type) {
		if(!this.handlers()[type]) this.handlers()[type] = [];
		return this.handlers()[type];
	},

	on(type, handler) {
		this.getHandlers(type).push(handler);
	},

	once(type, handler) {
		var wrap = (...args) => {
			this.off(type, wrap);
			handler(...args);
		};
		this.on(type, wrap);
	},

	off(type, handler) {
		if(type) {
			this.handlers()[type] = handler ? this.getHandlers(type).filter(h => h !== handler) : [];
		} else {
			handlers.set(this, {});
		}
	},

	onAny(handler) {
		this.anyHandlers().push(handler);
	},

	offAny(handler) {
		anyHandlers.set(this,
			handler ? this.anyHandlers().filter(h => h !== handler) : []
		);
	}
}
