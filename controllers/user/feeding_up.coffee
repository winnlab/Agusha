View = require '../../lib/view'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'
feeding_up = require '../../meta/feeding_up'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'feeding_up'
		feeding_up: feeding_up
	
	View.render 'user/feeding_up/feeding_up', res, data