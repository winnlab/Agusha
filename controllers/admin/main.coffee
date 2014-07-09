async = require 'async'

View = require '../../lib/view'
Auth = require '../../lib/auth'

exports.index = (req, res) ->
	unless req.user
		res.redirect 'admin/login'
	else
		res.redirect 'admin/dashboard'

exports.login = (req, res)->
	View.render 'admin/auth/index', res

exports.logout = (req, res)->
	req.logout()
	res.redirect '/admin/login'

exports.do_login = (req, res) ->
	Auth.authenticate('admin') req, res

exports.dashboard = (req, res) ->
	View.render 'admin/board/index', res