express = require 'express'

View = require '../lib/view'
City = require '../lib/city'
ArticleLib = require '../lib/article'

Migrate = require '../init/migrate'

Main = require './user/main'
SignUp = require './user/signup'
Products = require './user/products'
Product = require './user/product'
Tour = require './user/tour'
Food = require './user/food'
News = require './user/news'
Feeding_up = require './user/feeding_up'
Article = require './user/article'
Production = require './user/production'
Contacts = require './user/contacts'
Video = require './user/video'

Router = express.Router()

Router.get '/', Main.index

#

Router.get '/signup', SignUp.index
Router.get '/signup/activate/:salt', SignUp.activate

Router.get '/signup/success', SignUp.success
Router.get '/signup/success/:id', SignUp.success
Router.get '/signup/activate/:salt', SignUp.activate

Router.post '/signup/invite', SignUp.invite
Router.post '/signup/register', SignUp.register
Router.post '/signup/activate', SignUp.activatePost

#

Router.get '/products', Products.index
Router.get '/products/:category', Products.index
Router.get '/products/:category/:age', Products.index

Router.post '/products/findAll', Products.findAll

#

Router.get '/product/:id', Product.index

#

Router.get '/tour', Tour.index
Router.post '/tour/add_record', Tour.add_record

#

Router.get '/food', Food.index

#

Router.get '/news', News.index

#

Router.get '/feeding_up', Feeding_up.index

#

Router.get '/production', Production.index

#

Router.get '/contacts', Contacts.index

#

Router.get '/video', Video.index

#

Router.get '/article/:id', Article.index
Router.get '/specialist/:id', Article.specialist

Router.post '/articles/findAll', ArticleLib.findAll

#

Router.post '/city_autocomplete', City.autocomplete

#

exports.Router = Router