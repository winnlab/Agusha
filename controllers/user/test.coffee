async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

exports.email = (req, res) ->
	# email = 'hydraorc@gmail.com'
	email = 'hydra0@bigmir.net'
	
	options =
		client:
			login: 'Имя Фамилия'
			email: email
		
		subject: 'Агуша - обновленный сайт'
		template: 'new_password'
	
	Client.sendMail res, options, (err, html) ->
		if err
			return res.send err
		
		res.send html