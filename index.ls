module.exports =
	emit: (type, ...args)->
		handlers = @{}_handlers[][type]
		if handlers.length > 0
			for handler in handlers
				handler ...args
		else if type is \error
			throw new Error 'Unhandled error event'
	
	on: (type, handler)->
		@{}_handlers[][type].push handler
	
	once: (type, handler)->
		@on type, :wrap (args)~>
			@off type, wrap
			handler ...args

	off: (type, handler)->
		if type
			if handler
				@{}_handlers[type] = [f for f in @{}_handlers[][type] when f isnt handler]
			else
				@{}_handlers[type] = []
		else
			@_handlers = {}

