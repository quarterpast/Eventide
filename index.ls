module.exports =
	emit: (type, ...args)->
		[evt, ...sub] = type.split \:
		handlers = (@get-handlers evt) ++ if evt isnt type then @get-handlers type else []
		for handler in handlers
			handler ...sub, ...args

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

