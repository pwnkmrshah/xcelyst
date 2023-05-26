//= require arctic_admin/base
//= require activeadmin_addons/all
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input

$(document).ready(function() {
	$('.collection_selection_ids').on('click', function() {
		console.log('clicked')
		if($('#user_ids').val() == "") {
			$('#user_ids').val($(this).val())
		} else {
			$('#user_ids').val(`$('#user_ids').val(), $(this).val()`)
		}
	});

	var title = $('#page_title').html()
	if (title == 'Super Admin') {
		$('#titlebar_right').remove()
	}
    $('.permissions input[type="checkbox"]').on('click', function() {
    	var divId = $(this).closest('div').attr('id');
		viewClassName = '.'+divId+'-view'
		browseClassName = '.'+divId+'-browse'

        // Get the "View" checkbox and its corresponding checkboxes
	    var viewCheckbox = $(viewClassName);
	    var browseCheckbox = $(browseClassName);
	    var viewCheckbox = viewCheckbox = viewCheckbox.length ? viewCheckbox : browseCheckbox;

	    var checkboxes = $('.permissions.'+divId+' input[type="checkbox"]').not(viewCheckbox);

	    // Attach event listener to checkboxes
	    checkboxes.on('change', function() {
	      // If any checkbox is clicked, auto-select "View" if not already selected
	      if (!viewCheckbox.is(':checked')) {
	        viewCheckbox.prop('checked', true);
	      }
	    });

	    // Attach event listener to "View" checkbox
	    viewCheckbox.on('change', function() {
	      // If "View" is deselected, deselect all other checkboxes
	      if (!viewCheckbox.is(':checked')) {
	        checkboxes.prop('checked', false);
	      }
	    });
    });

// $('.permissions input[type="checkbox"]').on('click', function() {
//   var divId = $(this).closest('div').attr('id');
//   var viewClassName = '.' + divId + '-view';
//   var browseClassName = '.' + divId + '-browse';
//   var uploadClassName = '.' + divId + '-upload json file';

//   var viewCheckbox = $(viewClassName);
//   var browseCheckbox = $(browseClassName);
//   var uploadCheckbox = $(uploadClassName);
//   var selectedCheckbox = viewCheckbox.length ? viewCheckbox : uploadCheckbox;

//   var checkboxes = $('.permissions.' + divId + ' input[type="checkbox"]').not(selectedCheckbox);

//   checkboxes.on('change', function() {
//     if (!selectedCheckbox.is(':checked')) {
//       selectedCheckbox.prop('checked', true);
//     }
//   });

//   selectedCheckbox.on('change', function() {
//     if (!selectedCheckbox.is(':checked')) {
//       checkboxes.prop('checked', false);
//     }
//   });
// });
    
});