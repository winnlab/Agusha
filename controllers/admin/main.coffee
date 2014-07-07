async = require 'async'

View = require '../../lib/view'
Admin = require '../../lib/admin'
Auth = require '../../lib/auth'

exports.index = (req, res) ->
	unless req.user
		res.redirect 'admin/login'
	else
		res.redirect 'admin/dashboard'

exports.login = (req, res)->
	req.flash 'info', 'BLABLABLA'
	View.render 'admin/auth/index', res

exports.logout = (req, res)->
	req.logout()
	res.redirect '/admin/login'

exports.do_login = (req, res) ->
	Auth.authenticate('admin') req, res

exports.dashboard = (req, res) ->
	res.send 'Hello!'