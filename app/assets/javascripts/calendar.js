//= require 'fullcalendar'

$(function() {
	$.ajax({
		url: '/calendar/get_events',
		success: function(events){
			$('#loadingMessage').hide()
			var result = []
			for(var i=0; i < events.length; i++)
			{
				var input = events[i], output = {};
				output.title = input.name;
				output.start = new Date(input.starts_on);
				output.end = new Date(input.ends_on);
				output.allDay = true;
				output.url = "/conferences/"+input.id
				result.push(output);
			}
			$('#calendarContainer').fullCalendar({
				events: result
			})
		}
	})

})

