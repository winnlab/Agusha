async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
Product = require '../../lib/product'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'products'
	
	async.waterfall [
		(next) ->
			product = Model 'Product', 'findById', null, req.params.id
			
			product.populate('age certificate').exec next
		(doc) ->
			volume = doc.getFormattedVolume()
			
			doc = doc.toObject()
			
			doc.volume = volume
			
			data.product = doc
			
			data.breadcrumbs.push
				parent_id: 'product'
				title: data.product.title
			
			View.render 'user/product/product', res, data, req.path
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/product/index: #{error}"