require.config({
	baseUrl: '/js',
	
	paths: {
		core: 'user/core',
		slider: 'plugins/slider/jssor.slider'
	},
	
	shim: {
		'slider': {
			deps: ['plugins/slider/jssor.core', 'plugins/slider/jssor.utils'],
			exports: '$JssorSlider$'
		}
	},
	
	map: {
		'*': {
			'css': 'plugins/require/require-css.min'
		}
	}
});

require([
		'core/router',
		'core/config'
	],
	function(
		Router,
		config
	) {
		var body = $('body');
		
		// ectRenderer = ECT({ root : '/views', ext : '.ect' });
		
		Controller = can.Control.extend({
			defaults: {
				
			}
		}, {
			init: function () {
				var server = $('#modules').find('.module.server'),
					that = this;
				
				if(server.length) {
					server.children().appendTo(this.element);
					server.remove();
					
					require(['css!../css/user/' + this.options.module.name + '/' + this.options.module.name + '.css'], function () {
						that.after_request();
					});
				} else {
					require(['css!../css/user/' + this.options.module.name + '/index.css'], function () {
						that.request();
					});
				}
			},
			
			request: function() {
				var	str = this.options.module.path.server,
					params = ['name', 'id'],
					that = this,
					reg,
					i;
				
				for(i = params.length; i--;) {
					param = params[i];
					reg = new RegExp(':' + param, 'g');
					str = str.replace(reg, this.options.module[param]);
				}
				
				can.ajax({
					url: '/' + str,
					success: function(data) {
						that.successRequest(data);
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.error(errorThrown);
					}
				});
			},
			
			successRequest: function(data) {
				if(data.err) {
					return console.error(err);
				}
				
				// console.time('jadeTemplate')
				
				var html = jadeTemplate.get('user/' + this.options.module.name + '/content', data.data);
				
				// var html = ectRenderer.render('user/' + this.options.module.name + '/content', data.data);
				
				this.element.html(html);
				
				// console.timeEnd('jadeTemplate')
				
				this.after_request(data.data);
			},
			
			after_request: function(data) {
				this.variables();
				this.sizes();
				this.plugins();
				
				this.after_init(data);
			},
			
			variables: function() {
				
			},
			
			plugins: function() {
				
			},
			
			sizes: function() {
				
			},
			
			'{window} resize': 'sizes'
		});
		
		new Router(body, config.router);
	}
);