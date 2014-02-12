//= require bootstrap-sortable

(function ($) {
    'use strict';
    $.fn.generate_users = function () {
        $(this).click(function () {
            var ids = [],
                checks = $('input:checked');
            checks.each(function () {
                ids.push($(this).attr('value'))
            });
            $.ajax({
                type: 'POST',
                url: '/organization_reports/without_users',
                data: { organizations: ids },
                dataType: 'json',
                success: function (data) {
                    checks.each(function () {
                        var parent = $(this).closest('td'),
                            row = $(this).closest('tr'),
                            id = row.attr('id'),
                            res = data[id];
                        parent.html(res);
                        if (res.match(/Error:/g)) {
                            row.addClass("alert alert-error")
                        } else {
                            row.addClass("alert alert-success")
                        }
                    });
                },
                error: function (data) {
                }
            });
            return false
        });
    };
    $.fn.select_all = function () {
        var that = $(this);
        that.click(function () {
            var active = that.hasClass('active'),
                checks = $('input:checkbox');
            checks.each(function () {
                $(this).prop('checked', !active);
            });
        });
    };
})(jQuery);

$(function () {
    $('#generate_users').generate_users();
    $('#select_all').select_all();
    var toolbar = $('#toolbar');
    if (toolbar.length != 0) {
        toolbar.affix({
            offset: { top: toolbar.offset().top }
        })
    }
});
