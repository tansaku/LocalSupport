(function ($) {
    'use strict';
    $.fn.generate_users = function () {
        $(this).click(function () {
            var ids    = [],
                checks = $('input:checked');
            checks.each(function () {
                ids.push($(this).attr('value'))
            });
            $.ajax({
                type: 'POST',
                url: '/orphans',
                data: { organizations: ids },
                dataType: 'json',
                success: function (data) {
                    checks.each(function() {
                        var parent = $(this).closest('td'),
                            row    = $(this).closest('tr'),
                            id     = row.attr('id'),
                            res    = data[id];
                        parent.html(res);
                        if (res.match(/Error:/g)) {
                            row.addClass("alert alert-error")
                        } else {
                            row.addClass("alert alert-success")
                        }
                    });
                },
                error: function (data) {}
            });
            return false
        });
    };
})(jQuery);