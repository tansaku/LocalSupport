// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .
/*
 * bootstrap-select.js
 */

(function($) {

    'use strict'; // jshint ;_;

    $.fn.dropSelect = function(option) {
        return this.each(function() {

            var $this = $(this);
            var display = $this.find('.dropdown-display');        // display span
            var field = $this.find('input.dropdown-field');       // hidden input
            var options = $this.find('ul.dropdown-menu > li > a');// select options

            // when the hidden field is updated, update dropdown-toggle
            var onFieldChange = function(event) {
                var val = $(this).val();
                var displayText = options.filter("[data-value='" + val + "']").html();
                display.html(displayText);
            };

            // when an option is clicked, update the hidden field
            var onOptionClick = function(event) {
                // stop click from causing page refresh
                event.preventDefault();
                debugger
                field.val($(this).attr('data-value'));
                field.change();
            };

            field.change(onFieldChange);
            options.click(onOptionClick);

        });
    };
})(jQuery);

// invoke on every div element with 'data-select=true'
$(function() {
    $('div[data-select=true]').dropSelect();
});

