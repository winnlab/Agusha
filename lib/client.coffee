async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'

exports.adminView = (req, res) ->
	async.waterfall [
		(next) ->
			options =
				sort:
					date: -1
			
			Model 'Client', 'find', next, {}, {}, options
		(docs, next) ->
			Model 'Client', 'populate', next, docs, 'invited_by'
		(docs) ->
			View.render 'admin/board/clients/index', res, {clients: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/clients/index: %s #{err.message or err}"