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
