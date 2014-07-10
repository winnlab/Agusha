async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
mongoose = require 'mongoose'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Certificate', 'find', next
		(docs) ->
			View.render 'admin/board/certificate/index', res, {certificates: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/certificate/index: %s #{err.message or err}"

exports.get = (req, res) ->
	id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Certificate', 'findOne', next, _id: id
		(doc, next) ->
			if doc
				View.render 'admin/board/certificate/edit', res, certificate: doc
			else
				next "Произошла неизвестная ошиба!"
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/certificate/get: %s #{err.message or err}"
		View.message false, err.message or err, res

exports.create = (req, res) ->
	View.render 'admin/board/certificate/edit', res,
		certificate: {}

exports.save = (req, res) ->
	_id = req.body.id or mongoose.Types.ObjectId()

	data = req.body
	data.image = req.files?.image?.name

	async.waterfall [
		(next) ->
			Model 'Certificate', 'update', next, _id: _id, data, {upsert: true}
		(doc, next) ->
			if not doc
				return next "Произошла неизвестная ошибка."

			View.message true, 'Сертификат успешно сохранен!', res
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/certificate/save: %s #{err.message or err}"
		msg = "Произошла ошибка при сохранении: #{err.message or err}"
		View.message false, msg, res

exports.delete = (req, res) ->
	_id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Certificate', 'findOne', next, {_id}
		(doc, next) ->
			if doc
				doc.remove() #!!!
				View.message true, 'Сертификат успешно удален!', res
			else
				next "Произошла неизвестная ошибка."
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/certificate/remove: %s #{err.message or err}"
		msg = "Произошла ошибка при удалении: #{err.message or err}"
		View.message false, msg, res