require! {
	events: './'
	'karma-sinon-expect'.expect
}

export 'Events':
	'emit and on':
		'should emit and handle simple events': ->
			ev = new class implements events
			ev.on \foo handler = expect.sinon.stub!
			ev.emit \foo
			expect handler .to.be.called!

		'should trigger multiple handlers': ->
			ev = new class implements events
			ev.on \foo handler1 = expect.sinon.stub!
			ev.on \foo handler2 = expect.sinon.stub!
			ev.emit \foo
			expect handler1 .to.be.called!
			expect handler2 .to.be.called!

		'should pass arguments to handlers': ->
			ev = new class implements events
			ev.on \foo handler = expect.sinon.stub!
			ev.emit \foo \bar \baz
			expect handler .to.be.called-with \bar \baz

		'shouldn\'t throw when error event is unhandled': ->
			ev = new class implements events
			expect (-> ev.emit \error) .not.to.throw-error!

		'should handle namespaced events':
			'at one level': ->
				ev = new class implements events
				ev.on \foo handler = expect.sinon.stub!
				ev.emit \foo:bar
				expect handler .to.be.called-with \bar

			'at multiple levels': ->
				ev = new class implements events
				ev.on \foo handler = expect.sinon.stub!
				ev.emit \foo:bar:baz
				expect handler .to.be.called-with \bar \baz

			'and entire emitted event': ->
				ev = new class implements events
				ev.on \foo:bar handler = expect.sinon.stub!
				ev.emit \foo:bar
				expect handler .to.be.called!

			'with bare array paths':
				'at one level': ->
					ev = new class implements events
					ev.on <[ foo ]> handler = expect.sinon.stub!
					ev.emit <[ foo bar ]>
					expect handler .to.be.called-with \bar

				'at multiple levels': ->
					ev = new class implements events
					ev.on <[ foo ]> handler = expect.sinon.stub!
					ev.emit <[ foo bar baz ]>
					expect handler .to.be.called-with \bar \baz

				'and entire emitted event': ->
					ev = new class implements events
					ev.on <[ foo bar ]> handler = expect.sinon.stub!
					ev.emit <[ foo bar ]>
					expect handler .to.be.called!

	'off':
		'should remove all handlers of type': ->
			ev = new class implements events
			ev.on \foo handler = expect.sinon.stub!
			ev.off \foo
			ev.emit \foo
			expect handler .to.be.not-called!

		'should remove particular handlers': ->
			ev = new class implements events
			ev.on \foo handler1 = expect.sinon.stub!
			ev.on \foo handler2 = expect.sinon.stub!
			ev.off \foo handler1
			ev.emit \foo
			expect handler1 .to.be.not-called!
			expect handler2 .to.be.called!

		'should remove all events': ->
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

	'onAny':
		'should fire on any event': ->
			ev = new class implements events
			ev.on-any handler = expect.sinon.stub!
			ev.emit \foo \bar
			expect handler .to.be.called-with \foo \bar
			ev.emit \baz:quuz \frob
			expect handler .to.be.called-with \baz:quuz \frob

	'offAny':
		'should remove all handlers': ->
			ev = new class implements events
			ev.on-any handler = expect.sinon.stub!
			ev.off-any!
			ev.emit \foo
			expect handler .to.be.not-called!
		'should remove particular handlers': ->
			ev = new class implements events
			ev.on-any handler1 = expect.sinon.stub!
			ev.on-any handler2 = expect.sinon.stub!
			ev.off-any handler1
			ev.emit \foo
			expect handler1 .to.be.not-called!
			expect handler2 .to.be.called-with \foo


