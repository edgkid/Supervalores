$(document).ready ->

	$('#test_id').on "change", ->
		variable = $(this).val()
		if variable is"1"
			$('.day').removeClass("hide")

			$('.from_to').addClass("hide")
			$('#from').val(null)
			$('#to').val(null)

			$('.month').addClass("hide")
			$('#month').val(null)

			$('.year').addClass("hide")
			$('#year').val(null)
		else if variable is "2"
			$('.day').addClass("hide")
			$('#day').val(null)

			$('.from_to').removeClass("hide")

			$('.month').addClass("hide")
			$('#month').val(null)

			$('.year').addClass("hide")
			$('#year').val(null)

		else if variable is "3"
			$('.day').addClass("hide")
			$('#day').val(null)

			$('.from_to').addClass("hide")
			$('#from').val(null)
			$('#to').val(null)

			$('.month').removeClass("hide")

			$('.year').addClass("hide")
			$('#year').val(null)

		else if variable is "4"
			$('.day').addClass("hide")
			$('#day').val(null)

			$('.from_to').addClass("hide")
			$('#from').val(null)
			$('#to').val(null)

			$('.month').addClass("hide")
			$('#month').val(null)

			$('.year').removeClass("hide")

		else
			$('.day').addClass("hide")
			$('#day').val(null)

			$('.from_to').addClass("hide")
			$('#from').val(null)
			$('#to').val(null)

			$('.month').addClass("hide")
			$('#month').val(null)

			$('.year').addClass("hide")
			$('#year').val(null)

	$('.datepicker').datepicker
	  autoclose: true
	  format: 'dd/mm/yyyy'
	  clearBtn: true
	$('.month-datepicker').datepicker
	  autoclose: true
	  format: 'mm/yyyy'
	  viewMode: 'months'
	  minViewMode: 'months'
	  clearBtn: true
	$('.year-datepicker').datepicker
	  autoclose: true
	  format: 'yyyy'
	  viewMode: 'years'
	  minViewMode: 'years'
	  clearBtn: true


	