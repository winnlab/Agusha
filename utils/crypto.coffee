crypto = require 'crypto'

exports.password = (string)->
	return crypto.createHash('md5').update(string).digest 'hex'