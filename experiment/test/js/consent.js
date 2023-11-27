/* Obtain consent from experiment participant. */
var check_consent = function(elem) {
	if ($('#consent_checkbox').is(':checked')) { return true; }
	else {
		alert("If you wish to participate, you must check the box.");
		return false;
	}
	return false;
};

var consent_block = {
    type: 'external-html',
    url: "consent.html",
    cont_btn: "start",
    check_fn: check_consent
  };

function create_consent() {
  console.log("Creating consent block!");
  return consent_block;
};