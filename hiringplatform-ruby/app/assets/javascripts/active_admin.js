//= require arctic_admin/base
//= require activeadmin_addons/all
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input
//= require froala_editor.min.js
//= require plugins/align.min.js
//= require plugins/char_counter.min.js
//= require plugins/code_beautifier.min.js
//= require plugins/code_view.min.js
//= require plugins/colors.min.js
//= require plugins/emoticons.min.js
//= require plugins/entities.min.js
//= require plugins/file.min.js
//= require plugins/font_family.min.js
//= require plugins/font_size.min.js
//= require plugins/fullscreen.min.js
//= require plugins/image.min.js
//= require plugins/image_manager.min.js
//= require plugins/inline_style.min.js
//= require plugins/line_breaker.min.js
//= require plugins/link.min.js
//= require plugins/lists.min.js
//= require plugins/paragraph_format.min.js
//= require plugins/paragraph_style.min.js
//= require plugins/quick_insert.min.js
//= require plugins/quote.min.js
//= require plugins/save.min.js
//= require plugins/table.min.js
//= require plugins/url.min.js
//= require plugins/video.min.js

$(document).ready(function() {
  $('.collection_selection_ids').on('click', function() {
    console.log('clicked');
    if ($('#user_ids').val() == "") {
      $('#user_ids').val($(this).val());
    } else {
      $('#user_ids').val($('#user_ids').val() + ", " + $(this).val());
    }
  });

  var title = $('#page_title').html();
  if (title == 'Super Admin') {
    $('#titlebar_right').remove();
  }

  $('.permissions input[type="checkbox"]').on('click', function() {
    var divId = $(this).closest('div').attr('id');
    var viewClassName = '.' + divId + '-view';
    var browseClassName = '.' + divId + '-browse';

    // Get the "View" checkbox and its corresponding checkboxes
    var viewCheckbox = $(viewClassName);
    var browseCheckbox = $(browseClassName);
    viewCheckbox = viewCheckbox.length ? viewCheckbox : browseCheckbox;

    var checkboxes = $('.permissions.' + divId + ' input[type="checkbox"]').not(viewCheckbox);

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

$('.test-account-browse').on('click', function() {
  var browseAccountCheckbox = $('#test-account .Browse.test.account input[type="checkbox"]');
  var browseCandidateCheckbox = $('#candidate .Browse.candidate input[type="checkbox"]');

  if (browseAccountCheckbox.prop('checked')) {
    if (!browseCandidateCheckbox.prop('checked')) {
      var confirmation = confirm("It will also enable candidate view. Do you want to continue?");
      if (confirmation) {
        browseAccountCheckbox.prop('checked', true);
        browseCandidateCheckbox.prop('checked', true);
      } else {
        browseAccountCheckbox.prop('checked', false); // Uncheck the checkbox
        browseCandidateCheckbox.prop('checked', false); // Uncheck the checkbox
      }
    }
  }
});

$('#test_account').on('click', function() {
  var browseAccountCheckbox = $('#test-account .Browse.test.account input[type="checkbox"]');
  var browseCandidateCheckbox = $('#candidate .Browse.candidate input[type="checkbox"]');

  if ($(this).prop('checked')) {
    if (!browseCandidateCheckbox.prop('checked')) {
      var confirmation = confirm("It will also enable candidate view. Do you want to continue?");
      if (confirmation) {
        browseAccountCheckbox.prop('checked', true);
        browseCandidateCheckbox.prop('checked', true);
      } else {
        $(this).prop('checked', false); // Uncheck the checkbox
        browseAccountCheckbox.prop('checked', false); // Uncheck the checkbox
        browseCandidateCheckbox.prop('checked', false); // Uncheck the checkbox
      }
    }
  }
});

$('#candidate').on('click', function() {
  var browseAccountCheckbox = $('#test-account .Browse.test.account input[type="checkbox"]');
  var browseCandidateCheckbox = $('#candidate .Browse.candidate input[type="checkbox"]');

  if (!$(this).prop('checked')) {
  	$('#test_account').prop('checked', false)
    browseAccountCheckbox.prop('checked', false); // Uncheck the Test Account checkbox
    browseCandidateCheckbox.prop('checked', false); // Uncheck the Candidate checkbox
  	alert('Test account view has been also disabled.')
  }
});


$('.candidate-browse').on('click', function() {
  var browseCandidateCheckbox = $('#candidate .Browse.candidate input[type="checkbox"]');
  var browseAccountCheckbox = $('#test-account .Browse.test.account input[type="checkbox"]');

  if (!browseCandidateCheckbox.prop('checked')) {
    if (browseAccountCheckbox.prop('checked')) {
      var confirmation = confirm("It will also disable test-account view. Do you want to continue?");
      if (confirmation) {
        browseCandidateCheckbox.prop('checked', false);
        browseAccountCheckbox.prop('checked', false);
        $('#test_account').prop('checked', false)
      } else {
        browseCandidateCheckbox.prop('checked', true); // Keep the checkbox checked
        browseAccountCheckbox.prop('checked', true); // Keep the checkbox checked
      }
    }
  }
});


});
