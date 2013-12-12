describe('Jasmine sanity check', function() {
    it('works', function() {  expect(true).toBe(true); });
});

describe('dropSelect', function() {
//    beforeEach(function() {
//        loadFixtures('search_form.html');
//        var display = $('.dropdown-display');        // display span
//        var field = $('input.dropdown-field');       // hidden input
//        var options = $('ul.dropdown-menu > li > a');// select options
//    });

    it('display span text is updated when select option is chosen', function() {
        loadFixtures('search_form.html');
        var accommodation = $('ul.dropdown-menu > li > a[data-value="7"]');
//        expect(accommodation).toHaveText('Accommodation');
//        var spyEvent = spyOnEvent(accommodation, 'click');
        accommodation.click();
//        expect('click').toHaveBeenTriggeredOn(accommodation);
        expect($('.dropdown-display')).toHaveText('Accommodation')
    });
});