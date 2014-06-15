module.exports =
	emit: (type, ...args)->
		if @{}_handlers[type]?
			for let handler in that
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

