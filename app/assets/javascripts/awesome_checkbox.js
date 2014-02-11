(function($) {
    'use strict';
    $.fn.awesome_checkbox = function() {
        var that = this;
        $(this).change(function () {
            var icon = that.siblings("[class*=icon-]");

            var checked = that.is(":checked");

            icon.toggleClass('icon-check', checked)
                .toggleClass('icon-check-empty', !checked)
        });
    }
})(jQuery);

