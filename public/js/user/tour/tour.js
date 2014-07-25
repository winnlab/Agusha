var base_url = window.location.protocol + '//' + window.location.host;

var Tour_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.mapLatLng = new google.maps.LatLng(50.4300000, 30.389388);
			this.akademLatLng = new google.maps.LatLng(50.4648609, 30.3553083);
			this.vishnevoeLatLng = new google.maps.LatLng(50.3948087, 30.3699517);
			
			this.tour_key = 0;
			this.tours = tours;
			
			var ViewModel = can.Map.extend({
				define: {
					current_tour: {
						value: this.tours[0] || null
					}
				}
			});
			
			this.data = new ViewModel();
			
			this.init_plugins();
		},
		
		init_plugins: function() {
			this.init_map();
			this.init_calendar();
		},
		
		init_map: function() {
			var	options = {
					center: this.mapLatLng,
					zoom: 12
				};
			
			this.map = new google.maps.Map(document.getElementById('tour_map'), options);
			
			this.draw_markers();
			this.draw_route();
		},
		
		draw_markers: function() {
			new google.maps.Marker({
				position: this.akademLatLng,
				map: this.map,
				icon: base_url + '/img/user/tour/akadem_marker.png'
			});
			
			new google.maps.Marker({
				position: this.vishnevoeLatLng,
				map: this.map,
				icon: base_url + '/img/user/tour/agusha_marker.png'
			});
		},
		
		draw_route: function() {
			var polylineCoords = [
				this.akademLatLng,
				this.vishnevoeLatLng
			];
			
			var polyline = new google.maps.Polyline({
				path: polylineCoords,
				strokeColor: "#64cb81",
				strokeOpacity: 1.0,
				strokeWeight: 6
			});
			
			polyline.setMap(this.map);
		},
		
		init_calendar: function() {
			var	current_date = new Date();
			
			$('#calendar').datepicker({
				defaultDate: current_date,
				hideIfNoPrevNext: true,
				minDate: current_date,
				maxDate: new Date(current_date.valueOf() + 1000 * 3600 * 24 * 364)
			});
		},
		
		'.step_button click': function(el) {
			var element = $(el),
				val = element.data('step'),
				calendar_block_inside = $('#calendar_block_inside');
			
			calendar_block_inside.find('.step').removeClass('active');
			calendar_block_inside.find('.step_button').removeClass('active');
			calendar_block_inside.find('.step_' + val).addClass('active');
		},
		
		'.prev_tour click': function(el) {
			if(this.tour_key == 0) {
				return;
			}
			
			this.tour_key--;
			this.change_tour(this.tour_key);
		},
		
		'.next_tour click': function(el) {
			if(this.tour_key == this.tours.length - 1) {
				return;
			}
			
			this.tour_key++;
			this.change_tour();
		},
		
		change_tour: function() {
			this.data.attr('current_tour', this.tours[this.tour_key]);
			
			var closest_block_inside = $('#closest_block_inside');
			
			closest_block_inside.find('.tour_block').removeClass('active');
			$('#tour_' + this.tour_key).addClass('active');
		},
		
		'#add_child click': function(el) {
			var child_block = $('.child_block'),
				i = child_block.length,
				data = {
					i: i
				};
			
			$('#children_container').append(can.view("#add_child_tmpl", data));
		}
	}
);

new Tour_controller('#tour');