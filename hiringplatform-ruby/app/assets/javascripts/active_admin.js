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

	$(document).ready(function() {
	  $('.test-account-browse').on('click', function() {
	    var value = $(this).val();
        var userId = $('#current_user_admin_id').val();
	    
	    // Modify the alert message
	    // var confirmation = confirm("It will enable candidate view also. Do you want to continue?");

	    // if (confirmation) {
	    //   // AJAX call
		// 	var csrfToken = $('meta[name="csrf-token"]').attr('content');

	    //   $.ajax({
		// 	url: '/admin/admin_roles/' + value + '/enable_candidate',
	    //     method: 'post',
	    //     data: { id: value, user_id: userId },
        //     headers: { 'X-CSRF-Token': csrfToken },
	    //     success: function(response) {
	    //       // Handle success response if needed
	    //       console.log(response);
	    //     },
	    //     error: function(xhr, status, error) {
	    //       // Handle error response if needed
	    //       console.log(error);
	    //     }
	    //   });
	    // }
	  });
	});
});