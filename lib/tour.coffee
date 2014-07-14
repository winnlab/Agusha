async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'

exports.userView = (req, res) ->
	View.renderWithSession req, res, 'user/tour/tour'

exports.adminView = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Tour', 'find', next
		(docs) ->
			View.render 'admin/board/tours/index', res, {tours: docs}
	], (err) ->
		Logger.log 'info', "Error in lib/tour/adminView: %s #{err.message or err}"

exports.adminGet = (req, res) ->
	id = req.params.id
	
	async.waterfall [
		(next) ->
			Model 'Tour', 'findById', next, id
		(doc, next) ->
			if doc
				View.render 'admin/board/tours/edit', res, tour: doc
			else
				next "Произошла неизвестная ошибка!"
	], (err) ->
		Logger.log 'info', "Error in lib/tour/adminGet: %s #{err.message or err}"
		View.message false, err.message or err, res

exports.adminCreate = (req, res) ->
	View.render 'admin/board/tours/edit', res, tour: {}

exports.adminSave = (req, res) ->
	id = req.body.id
	
	data = req.body
	
	async.waterfall [
		(next) ->
			if id
				Model 'Tour', 'findById', next, id
			else
				next null, null
		(doc, next) ->
			if doc
				for attr of data
					doc[attr] = data[attr]
				
				doc.save next
			else
				Model 'Tour', 'create', next, data
		() ->
			View.message true, 'Экскурсия успешно сохранена!', res
	], (err) ->
		Logger.log 'info', "Error in lib/tour/adminSave: %s #{err.message or err}"
		msg = "Произошла ошибка при сохранении: #{err.message or err}"
		View.message false, msg, res

exports.adminDelete = (req, res) ->
	id = req.params.id
	
	async.waterfall [
		(next) ->
			Model 'Tour', 'findById', next, id
		(doc, next) ->
			if doc
				doc.remove() #!!!
				View.message true, 'Экскурсия успешно удалена!', res
			else
				next "Произошла неизвестная ошибка."
	], (err) ->
		Logger.log 'info', "Error in lib/tour/adminDelete: %s #{err.message or err}"
		msg = "Произошла ошибка при удалении: #{err.message or err}"
		View.message false, msg, res