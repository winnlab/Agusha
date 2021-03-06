async = require 'async'
_ = require 'underscore'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
Product = require '../../lib/product'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'products'
	
	asyncFunctions = Product.addAsyncFunctionsByFilter data, req.params.category, req.params.age
	
	asyncFunctions = asyncFunctions.concat [
		(next) ->
			Product.getAgesAndCategories next
		(results) ->
			data.ages = results.ages
			data.categories = results.categories

			_.each data.products, (item, key, list)->
				volume = item.getFormattedVolume()
				list[key] = item.toObject()
				list[key].volume = volume
			
			View.render 'user/products/products', res, data, req.path
	]
	
	async.waterfall asyncFunctions, (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/products/index: #{error}"

exports.findAll = (req, res) ->
	data = {}
	
	asyncFunctions = Product.addAsyncFunctionsByFilter data, req.body.category, req.body.age
	
	asyncFunctions.push (next) ->
		_.each data.products, (item, key, list)->
			volume = item.getFormattedVolume()
			list[key] = item.toObject()
			list[key].volume = volume

		View.ajaxResponse res, null, data
	
	async.waterfall asyncFunctions, (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/products/findAll: #{error}"
		View.ajaxResponse res, err