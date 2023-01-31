if (!localStorage.shortlist_array) {
	localStorage.shortlist_array = '';
}
if (!localStorage.temporary_accounts) {
	localStorage.temporary_accounts = '';
}
if (!localStorage.candidate) {
	localStorage.candidate = '';
}
if (!localStorage.client_id) {
	localStorage.client_id = '';
}
if (!localStorage.jd_id) {
	localStorage.jd_id = '';
}
$(document).ready(function() {

	$('#bx_block_database_download_limit_per_page_limit').on('keypress',  function(e) {
        if ((e.key==='.') || (e.key==='-')) {
            e.preventDefault();
        }
    })

	$('#bx_block_database_download_limit_per_page_limit').on('input',  function(e) {
     	if ($(this).val() > 50) {
            $('#bx_block_database_download_limit_per_page_limit').val(50)
            e.preventDefault();
        } else if ($(this).val() == 0) {
        	$('#bx_block_database_download_limit_per_page_limit').val(1)
            e.preventDefault();
        }

    })

	$('body.admin_temporary_accounts input.collection_selection').on('change', function() {
		if( $(this).prop('checked') == true ) {
			if(localStorage.temporary_accounts == '') {
				localStorage.temporary_accounts = $(this).val();
			} else {
				localStorage.temporary_accounts = `${localStorage.temporary_accounts},${$(this).val()}`;
			}
		} else {
			if(localStorage.temporary_accounts.search(`${$(this).val()}`) > -1) {
				if(localStorage.temporary_accounts.search(`${$(this).val()},`) > -1) {
					localStorage.temporary_accounts = localStorage.temporary_accounts.replace(`${$(this).val()},`,'');
				} else if (localStorage.temporary_accounts.search(`,${$(this).val()}`) > -1) {
					localStorage.temporary_accounts = localStorage.temporary_accounts.replace(`,${$(this).val()}`,'');
				} else {
					localStorage.temporary_accounts = localStorage.temporary_accounts.replace(`${$(this).val()}`,'');
				}
			}
		}
	});

	$('#send_message_aj').on('click', function(e) {
		e.preventDefault();
		if($('#jd_loader').length > 0) {
			$('#jd_loader').addClass('visible');
		} else {
			$('body').append(`<div id="jd_loader" class="visible"></div>`);
		}
		message = $('.text_message_whasapp').val()
		$.ajax({
			url: "/bx_block_shortlisting/bulk_send_messages",
			type: "post",
			data: {temporary_accounts: localStorage.temporary_accounts.split(","), message: message},
			success: function(result) {
				alert(result.message);
				$('#jd_loader').removeClass('visible');
				localStorage.removeItem("temporary_accounts");
				window.location.href = window.location.href;
			},
			error: function(error) {
				alert(error.responseJSON.error);
				$('#jd_loader').removeClass('visible');
			}
		});
	});

	$('body.admin_candidates input.collection_selection').on('change', function() {
		if( $(this).prop('checked') == true ) {
			if(localStorage.candidate == '') {
				localStorage.candidate = $(this).val();
			} else {
				localStorage.candidate = `${localStorage.candidate},${$(this).val()}`;
			}
		} else {
			if(localStorage.candidate.search(`${$(this).val()}`) > -1) {
				if(localStorage.candidate.search(`${$(this).val()},`) > -1) {
					localStorage.candidate = localStorage.candidate.replace(`${$(this).val()},`,'');
				} else if (localStorage.candidate.search(`,${$(this).val()}`) > -1) {
					localStorage.candidate = localStorage.candidate.replace(`,${$(this).val()}`,'');
				} else {
					localStorage.candidate = localStorage.candidate.replace(`${$(this).val()}`,'');
				}
			}
		}
	});

	$('#send_message_acc').on('click', function(e) {
		e.preventDefault();
		if($('#jd_loader').length > 0) {
			$('#jd_loader').addClass('visible');
		} else {
			$('body').append(`<div id="jd_loader" class="visible"></div>`);
		}
		message = $('.text_message_whasapp_acc').val()
		$.ajax({
			url: "/bx_block_shortlisting/bulk_send_messages_to_account",
			type: "post",
			data: {accounts: localStorage.candidate.split(","), message: message},
			success: function(result) {
				alert(result.message);
				$('#jd_loader').removeClass('visible');
				localStorage.removeItem("candidate");
				window.location.href = window.location.href;
			},
			error: function(error) {
				alert(error.responseJSON.error);
				$('#jd_loader').removeClass('visible');
			}
		});
	});



	function getUiMatchingUrl(jd_id) {
		if($('#jd_loader').length > 0) {
			$('#jd_loader').addClass('visible');
		} else {
			$('body').append(`<div id="jd_loader" class="visible"></div>`);
		}
		$.ajax({
			url: "/bx_block_shortlisting/get_roles",
			type: "post",
			data: {id: jd_id},
			success: function(result) {
				$('#ai_matching').attr("href", result.data)
				$('#ai_matching').removeClass('disabled');
				$('#jd_loader').removeClass('visible');
			},
			error: function(error) {
				alert(error.responseJSON.error);
				$('#jd_loader').removeClass('visible');
			}
		});
	}
	
	function get_ai_JdAjax(client) {
		if($('#jd_loader').length > 0) {
			$('#jd_loader').addClass('visible');
		} else {
			$('body').append(`<div id="jd_loader" class="visible"></div>`);
		}
		$.ajax({
			url: "/bx_block_shortlisting/get_jd",
			type: "post",
			data: {id: client},
			success: function(result) {
				var jd_html = ""
				$.each(result.data, function(k,v) {
					if(k == 0) {
						localStorage.jd_id = v.id;
					}
				    jd_html += `<option value="${v.id}">${v.job_title}</option>`;
				});
				$('#ai_jb_dropdown').html(jd_html);
				$('#jd_loader').removeClass('visible');
				if(localStorage.jd_id != '') {
					$('#ai_jb_dropdown').val(localStorage.jd_id).prop("checked", true).trigger("change");
				}
			},
			error: function(error) {
				alert(error.responseJSON.error);
				$('#jd_loader').removeClass('visible');
			}
		});
	}
	function getJdAjax(client) {
		if($('#jd_loader').length > 0) {
			$('#jd_loader').addClass('visible');
		} else {
			$('body').append(`<div id="jd_loader" class="visible"></div>`);
		}
		$.ajax({
			url: "/bx_block_shortlisting/get_jd",
			type: "post",
			data: {id: client},
			success: function(result) {
				var jd_html = ""
				$.each(result.data, function(k,v) {
					if(k == 0) {
						localStorage.jd_id = v.id;
					}
				    jd_html += `<option value="${v.id}">${v.job_title}</option>`;
				});
				$('#jd_dropdown').html(jd_html);
				$('#jd_loader').removeClass('visible');
				if(localStorage.jd_id != '') {
					$('#jd_dropdown').val(localStorage.jd_id).prop("checked", true).trigger("change");
				}
			},
			error: function(error) {
				alert(error.responseJSON.error);
				$('#jd_loader').removeClass('visible');
			}
		});
	}
	function getCadidateAjax(role, dataFor) {
		if($('#jd_loader').length > 0) {
			$('#jd_loader').addClass('visible');
		} else {
			$('body').append(`<div id="jd_loader" class="visible"></div>`);
		}
		$.ajax({
			url: "/bx_block_shortlisting/get_candidate",
			type: "post",
			data: {id: role},
			success: function(result) {
				var candidate_html = ""
				$.each(result.data, function(k,v) {
				    candidate_html += `<option value="${v.id}">${v.name}</option>`;
				});
				if (dataFor == "hiring") {
					$('#bx_block_assessment_hiring_manger_assessment_account_id').html(candidate_html);
				} else if (dataFor == "hr") {
					$('#bx_block_assessment_hr_assessment_account_id').html(candidate_html);
				} else if (dataFor == "video") {
					$('#bx_block_assessment_video_interview_account_id').html(candidate_html);
				}
				$('#jd_loader').removeClass('visible');
			},
			error: function(error) {
				alert(error.responseJSON.error);
				$('#jd_loader').removeClass('visible');
			}
		});
	}
	$.each(localStorage.shortlist_array.split(","), function(k,v) {
		if ($(`body.admin_shortlist_candidates input.collection_selection#batch_action_item_${v}`).prop("checked") == false ) {
			$(`body.admin_shortlist_candidates input.collection_selection#batch_action_item_${v}`).click();
		}
	});
	if(localStorage.client_id != '') {
		$('#client_dropdown').val(localStorage.client_id).prop("checked", true).trigger("change");
		getJdAjax(localStorage.client_id);
	} else {
		localStorage.client_id = $('#client_dropdown').val();
	}
	$('body.admin_shortlist_candidates input.collection_selection').on('click', function() {
		if( $(this).prop('checked') == true ) {
			if(localStorage.shortlist_array == '') {
				localStorage.shortlist_array = $(this).val();
			} else {
				localStorage.shortlist_array = `${localStorage.shortlist_array},${$(this).val()}`;
			}
		} else {
			if(localStorage.shortlist_array.search(`${$(this).val()}`) > -1) {
				if(localStorage.shortlist_array.search(`${$(this).val()},`) > -1) {
					localStorage.shortlist_array = localStorage.shortlist_array.replace(`${$(this).val()},`,'');
				} else if (localStorage.shortlist_array.search(`,${$(this).val()}`) > -1) {
					localStorage.shortlist_array = localStorage.shortlist_array.replace(`,${$(this).val()}`,'');
				} else {
					localStorage.shortlist_array = localStorage.shortlist_array.replace(`${$(this).val()}`,'');
				}
			}
		}
	});
	$('#shortlist_ajax').on('click', function(e) {
		if($('#jd_loader').length > 0) {
			$('#jd_loader').addClass('visible');
		} else {
			$('body').append(`<div id="jd_loader" class="visible"></div>`);
		}
		e.preventDefault();
		$.ajax({
			url: "/bx_block_shortlisting/shortlist_creation",
			type: "post",
			data: {client_id: localStorage.client_id, jd_id: localStorage.jd_id, shortlist_users: localStorage.shortlist_array.split(",")},
			success: function(result) {
				alert(result.message);
				$('#jd_loader').removeClass('visible');
				localStorage.removeItem("shortlist_array");
				localStorage.removeItem("client_id");
				localStorage.removeItem("jd_id");
				window.location.href = window.location.href;
			},
			error: function(error) {
				alert(error.responseJSON.error);
				$('#jd_loader').removeClass('visible');
			}
		});
	});
	function getShortlistedCandidates(client_id, jd_id) {
		$('[id^=account_block_email_account_]').removeClass('already-shortlisted');
		$.ajax({
			url: "/bx_block_shortlisting/get_shortlisted",
			type: "get",
			data: {client_id: client_id, jd_id: jd_id},
			success: function(result) {
				$.each(result.candidate_ids, function(key, value){
					$(`#account_block_email_account_${value}`).addClass('already-shortlisted');
				});
			},
			error: function(error) {
			}
		});
	}
	$('#jd_dropdown').on('change', function() {
		localStorage.jd_id = $(this).val();
		getShortlistedCandidates(localStorage.client_id, localStorage.jd_id);
	});
	$('#client_dropdown').on('change', function() {
		localStorage.client_id = $(this).val();
		getJdAjax($(this).val());
	});
	//for candidate
	$('#bx_block_assessment_hiring_manger_assessment_role_id').on('change', function() {
		getCadidateAjax($(this).val(), "hiring");
	});
	$('#bx_block_assessment_hr_assessment_role_id').on('change', function() {
		getCadidateAjax($(this).val(), "hr");
	});
	$('#bx_block_assessment_video_interview_role_id').on('change', function() {
		getCadidateAjax($(this).val(), "video");
	});
	function getPreview(page_id) {
		$.ajax({
			url: "/bx_block_aboutpage/page_preview",
			type: "post",
			data: { id: page_id },
			success: function(result) {
				debugger;
				preview_popup = `
					<div class="preview_popup">
						<span class="preview_popup_close">&times;</span>
						<div class="preview_popup_flex">
							<div class="preview_popup_content">
								<h4>${result.data.title}</h4>
								<div class="preview_popup_description">${result.data.description}</div>
							</div>
							<div class="preview_popup_image">
								<img src="${result.data.image == null ? '//via.placeholder.com/800?text=image_not_found' : result.data.image}" />
							</div>
						</div>
					</div>
				`
				if ($(`link[rel="preconnect"][href="https://fonts.googleapis.com"]`).length < 1) {
					$("head").append(`<link rel="preconnect" href="https://fonts.googleapis.com">`);
				}
				if ($(`link[rel="preconnect"][href="https://fonts.gstatic.com"][crossorigin=""]`).length < 1) {
					$("head").append(`<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>`);
				}
				if ($(`link[href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"][rel="stylesheet"]`).length < 1) {
					$("head").append(`<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">`);
				}
				$("body").append(preview_popup);
			},
			error: function(error) {
				alert(error.responseJSON.error);
			}
		});
	}
	$('.get_preview').on('click', function() {
		getPreview($(this).data('id'));
	});
	$(document).on('click', '.preview_popup_close', function() {
		$(".preview_popup").remove();
	});

	// for ai metching buttong
	$('#ai_jb_dropdown').on('change', function() {
		localStorage.jd_id = $(this).val();
		getUiMatchingUrl(localStorage.jd_id);
	});
	$('#ai_client_dropdown').on('change', function() {
		localStorage.client_id = $(this).val();
		get_ai_JdAjax($(this).val());
	});

	if(localStorage.client_id != '') {
		$('#ai_client_dropdown').val(localStorage.client_id).prop("checked", true).trigger("change");
		getJdAjax(localStorage.client_id);
	} else {
		localStorage.client_id = $('#ai_client_dropdown').val();
	}


	$('#bx_block_cfzoomintegration3_zoom_meeting_provider').on('change', function(){
		if ($(this).val().toLowerCase() == 'zoom' ){
			$('#bx_block_cfzoomintegration3_zoom_meeting_zoom_id_input').show();
		} else {
			$('#bx_block_cfzoomintegration3_zoom_meeting_zoom_id_input').hide();
		}

	});

	if ($('#bx_block_cfzoomintegration3_zoom_meeting_provider').val().toLowerCase() == 'zoom') {
		$('#bx_block_cfzoomintegration3_zoom_meeting_zoom_id_input').show();
	} else {
		$('#bx_block_cfzoomintegration3_zoom_meeting_zoom_id_input').hide();
	}

	$('#bx_block_cfzoomintegration3_zoom_meeting_client_id').on('change',function(){
		var client_id = $(this).val();
		var candidate_id = $('#bx_block_cfzoomintegration3_zoom_meeting_candidate_id').val();
		if ( client_id != '' && candidate_id != '' ){
			getInterviewRecords(client_id, candidate_id)
		}
	});

	$('#bx_block_cfzoomintegration3_zoom_meeting_candidate_id').on('change',function(){
		var candidate_id = $(this).val();
		var client_id = $('#bx_block_cfzoomintegration3_zoom_meeting_client_id').val();
		if ( client_id != '' && candidate_id != '' ){
			getInterviewRecords(client_id, candidate_id)
		}
	});

	function getInterviewRecords(client_id, candidate_id) {
		$.ajax({
			url: "/bx_block_cfzoomintegration3/interview",
			type: "post",
			data: { client_id: client_id, candidate_id: candidate_id },
			success: function(result) {
				var interview_html = ""
				$.each(result.data, function(k,v) {
				    interview_html += `<option value="${v.id}" data-slot="${v.preferred_slot}">${v.name}</option>`;
				});
				$('#bx_block_cfzoomintegration3_zoom_meeting_schedule_interview_id').html(interview_html);

				$('#bx_block_cfzoomintegration3_zoom_meeting_schedule_interview_id').attr('disabled',false);
				$('#bx_block_cfzoomintegration3_zoom_meeting_provider').attr('disabled',false);
				$('#bx_block_cfzoomintegration3_zoom_meeting_zoom_id_input').attr('disabled',false);
				$('#bx_block_cfzoomintegration3_zoom_meeting_schedule_date').attr('disabled',false);
				$('#bx_block_cfzoomintegration3_zoom_meeting_starting_at').attr('disabled',false);
				$('#bx_block_cfzoomintegration3_zoom_meeting_meeting_urls').attr('disabled',false);
				$('#bx_block_cfzoomintegration3_zoom_meeting_submit_action input').attr('disabled',false);
			},
			error: function(error) {
				alert(error.responseJSON.message);
				$('#bx_block_cfzoomintegration3_zoom_meeting_schedule_interview_id').attr('disabled',true);
				$('#bx_block_cfzoomintegration3_zoom_meeting_provider').attr('disabled',true);
				$('#bx_block_cfzoomintegration3_zoom_meeting_zoom_id_input').attr('disabled',true);
				$('#bx_block_cfzoomintegration3_zoom_meeting_schedule_date').attr('disabled',true);
				$('#bx_block_cfzoomintegration3_zoom_meeting_starting_at').attr('disabled',true);
				$('#bx_block_cfzoomintegration3_zoom_meeting_meeting_urls').attr('disabled',true);
				$('#bx_block_cfzoomintegration3_zoom_meeting_submit_action input').attr('disabled',true);
			}
		});
	}

	$('#bx_block_cfzoomintegration3_zoom_meeting_schedule_interview_id').on('change',function(){
		var slot = $(this).find('option:selected').data('slot');
		setTimeAndDateForScheduleInterview(slot);
	});

	$('#bx_block_cfzoomintegration3_zoom_meeting_schedule_interview_id').on('DOMSubtreeModified',function(){
		var slot = $(this).find('option:selected').data('slot');
		setTimeAndDateForScheduleInterview(slot);
	});

	function setTimeAndDateForScheduleInterview(slot){
		if ( slot != 'undefined' || slot != ''){
			var date = slot.split('T')[0];
			var time = `${slot.split('T')[1].split(':')[0]}:${slot.split('T')[1].split(':')[1]}`
			$('#bx_block_cfzoomintegration3_zoom_meeting_schedule_date').val(date);
			$('#bx_block_cfzoomintegration3_zoom_meeting_starting_at').val(time);

			$('#bx_block_cfzoomintegration3_zoom_meeting_schedule_date').attr('readonly',true);
			$('body').addClass('hide-datepicker');
			$('#bx_block_cfzoomintegration3_zoom_meeting_starting_at').attr('readonly',true);

		}
	}

});