require! {
	events: './index.js'
	'karma-sinon-expect'.expect
}

export 'Events':
	'should emit events':
		'simple events': ->
			ev = new class implements events
			ev.on \foo handler = expect.sinon.stub!
			ev.emit \foo
			expect handler .to.be.called!

		'multiple handlers': ->
			ev = new class implements events
			ev.on \foo handler1 = expect.sinon.stub!
			ev.on \foo handler2 = expect.sinon.stub!
			ev.emit \foo
			expect handler1 .to.be.called!
			expect handler2 .to.be.called!

		'with arguments': ->
			ev = new class implements events
			ev.on \foo handler = expect.sinon.stub!
			ev.emit \foo \bar \baz
			expect handler .to.be.called-with \bar \baz

		'should throw for an unhandled error event': ->
			ev = new class implements events
			expect (-> ev.emit \error) .to.throw-error /Unhandled error event/

		'should throw when an error handler has been removed':
			'that particular handler': ->
				ev = new class implements events
				ev.on \error handler = ->
				ev.off \error handler
				expect (-> ev.emit \error) .to.throw-error /Unhandled error event/

			'all error handlers': ->
				ev = new class implements events
				ev.on \error handler = ->
				ev.off \error
				expect (-> ev.emit \error) .to.throw-error /Unhandled error event/

			'all handlers': ->
				ev = new class implements events
				ev.on \error handler = ->
				ev.off!
				expect (-> ev.emit \error) .to.throw-error /Unhandled error event/

	'should remove events':
		'all of type': ->
			ev = new class implements events
			ev.on \foo handler = expect.sinon.stub!
			ev.off \foo
			ev.emit \foo
			expect handler .to.be.not-called!

		'particular handlers': ->
			ev = new class implements events
			ev.on \foo handler1 = expect.sinon.stub!
			ev.on \foo handler2 = expect.sinon.stub!
			ev.off \foo handler1
			ev.emit \foo
			expect handler1 .to.be.not-called!
			expect handler2 .to.be.called!

		'all events': ->
			ev = new class implements events
			ev.on \foo handler1 = expect.sinon.stub!
			ev.on \bar handler2 = expect.sinon.stub!
			ev.off!

			ev.emit \foo
			expect handler1 .to.be.not-called!

			ev.emit \bar
			expect handler2 .to.be.not-called!

	'once':
		'should remove things after first event': ->
			ev = new class implements events
			ev.once \foo handler = expect.sinon.stub!

			ev.emit \foo
			ev.emit \foo
			expect handler .to.be.called-once!

		'should leave other handlers intact': ->
			ev = new class implements events
			ev.once \foo handler1 = expect.sinon.stub!
			ev.on \foo handler2 = expect.sinon.stub!

			ev.emit \foo
			ev.emit \foo
			expect handler1 .to.be.called-once!
			expect handler2 .to.be.called-twice!

