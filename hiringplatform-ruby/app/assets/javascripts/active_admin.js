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
});