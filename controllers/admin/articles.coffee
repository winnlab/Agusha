async = require 'async'
fs = require 'fs'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
			where = 
				"$or": [
					type: 2
					type: 3
				]
			Model 'Article', 'find', next, where
		(docs) ->
			View.render 'admin/board/articles/index', res, articles: docs
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/articles/index: %s #{err.message or err}"

exports.get = (req, res) ->
	id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Article', 'findOne', next, _id: id
		(doc, next) ->
			if doc
				View.render 'admin/board/articles/edit', res, article: doc
			else
				next "Произошла неизвестная ошибка!"
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/articles/get: %s #{err.message or err}"
		View.message false, err.message or err, res

exports.create = (req, res) ->
	View.render 'admin/board/articles/edit', res,
		articles: {}

exports.save = (req, res) ->
	_id = req.body.id

	data = req.body
	data.image = []
	if req.files?.image
		for img in req.files.image
			data.image.push = img.name

	async.waterfall [
		(next) ->
			if _id
				async.waterfall [
					(next2) ->
						Model 'Article', 'findOne', next2, {_id}
					(doc) ->
						for own prop, val of data
							unless prop is 'id' or val is undefined
								doc[prop] = val

						doc.save next
				], (err) ->
					next err
			else
				Model 'Article', 'create', next, data
		(doc, next) ->
			if not doc
				return next "Произошла неизвестная ошибка."

			View.message true, 'Новость успешно сохранена!', res
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/articles/save: %s #{err.message or err}"
		msg = "Произошла ошибка при сохранении: #{err.message or err}"
		View.message false, msg, res

exports.delete = (req, res) ->
	_id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Article', 'findOneAndRemove', next, {_id}
		() ->
			View.message true, 'Статья успешно удалена!', res
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/articles/remove: %s #{err.message or err}"
		msg = "Произошла ошибка при удалении: #{err.message or err}"
		View.message false, msg, res

exports.deleteImage = (req, res) ->
	_id = req.params.id
	img = req.params.img
	async.waterfall [
		(next) ->
			Model 'Article', 'findOne', next, {_id}
		(doc, next) ->
			images = doc.images
			idx = images.indexOf img
			doc.images = images.splice idx, 1

			doc.save next
		(next) ->
			fs.unlink "#{_dirname}/public/img/#{img}", next
		() ->
			View.message true, 'Изображение удалено!', res
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/articles/remove: %s #{err.message or err}"
		msg = "Произошла ошибка при удалении: #{err.message or err}"
		View.message false, msg, res