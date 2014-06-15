# Eventide [![Build Status](https://travis-ci.org/quarterto/Eventide.svg)](https://travis-ci.org/quarterto/Eventide)

Namespaced events as a mixin

## Installation

```
npm install eventide
```

## Usage

Using your favourite way of mixing in objects, add `eventide` to an object. For example, using `_.extend`:

```javascript
function Person() {}
_.extend(Person.prototype, eventide, {
	eat: function(food) {
		this.emit('eaten:' + food);
	}
});

var matt = new Person;
matt.on('eaten', function(food) {
	console.log('mmm, ' + food);
});
matt.eat('peanut butter'); // => "mmm, peanut butter"
```

Or with Livescript's `implements`:

```livescript
class Person implements eventide
	...
```

## API
#### `.on(event, handler)`
Registers `handler` to handle `event`.

#### `.off([event, [handler]])`
Removes event handlers. If `event` is given, removes all handlers for `event`. If both `event` and `handler` are given, removes that particular event handler.

#### `.once(event, handler)`
Like `on`, but removes the handler when the event has fired.

## What's wrong with EventEmitter (2)?
Node's built-in EventEmitter and [EventEmitter2](https://github.com/asyncly/EventEmitter2) are great and all, but both require subclassing to use with your own objects. Eventide is a plain object, and its functions perform their own setup. Just mix in to whatever.

## Licence
MIT. &copy; 2014 Matt Brennan.
