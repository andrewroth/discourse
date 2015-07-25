$.fn.spin = function(opts) {
  this.each(function() {
    if (!$(this).is(":visible")) { return; }

    data = $(this).data();

    if (data.spinner === undefined || data.spinner === null) {
      data.spinner = $('<img width="24" height="24" alt="Spinner" class="spinner" src="/assets/spinner.gif" style="display:none">');
      data.spinner.appendTo($("body"));
    }

    data.spinner.css("z-index", "1000");
    data.spinner.css("position", "absolute");
    data.spinner.position({ my: "center", at: "center", of: $(this)});
    data.spinner.delay(1500).fadeTo('slow', '1');

    $(this).fadeTo(250, '0.08');
    $(this).attr("spinning", "true");
  });
  return this;
};

$.fn.stopSpin = function(opts) {
  this.each(function(el) {
    $(this).removeAttr("spinning");
    data = $(this).data();

    if (data.spinner) {
      data.spinner.detach();
      data.spinner = null;
    }

    if (!(typeof(opts) == "object" && opts.stayFaded == true)) {
      $(this).stop().animate({opacity: 1}, 500);
    }

    $(this).find("[spinning]").stopSpin();
  });
  return this;
};

$.fn.stopSpinAndFadeOut = function(opts) {
  this.each(function(el) {
    $(this).stopSpin(false);
    $(this).fadeOut();
  });
  return this;
};
