module.exports =
	emit: (type, ...args)->
		handlers = @get-handlers type
		if handlers.length > 0
			for handler in handlers
				handler ...args

	get-handlers: (type)-> @{}_handlers[][type]
	
	on: (type, handler)->
		@get-handlers type .push handler
	
	once: (type, handler)->
		@on type, :wrap (args)~>
			@off type, wrap
			handler ...args

	off: (type, handler)->
		if type
			if handler
				@{}_handlers[type] = [f for f in @get-handlers type when f isnt handler]
			else
				@{}_handlers[type] = []
		else
			@_handlers = {}

