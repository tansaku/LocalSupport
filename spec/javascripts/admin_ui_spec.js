describe('Generate User operation', function () {
    var generate_users;
    beforeEach(function () {
        setFixtures('<button id="generate_users"></button>');
        appendSetFixtures('<tr id="1"><td class="response"><input type="checkbox" value="1" checked /></td></tr>');
        appendSetFixtures('<tr id="2"><td class="response"><input type="checkbox" value="2" /></td></tr>');
        appendSetFixtures('<tr id="3"><td class="response"><input type="checkbox" value="3" checked /></td></tr>');
        appendSetFixtures('<tr id="4"><td class="response"><input type="checkbox" value="4" /></td></tr>');
        generate_users = $('#generate_users');
        generate_users.generate_users();
    });
    it('makes an ajax request when clicked', function () {
        spyOn($, "ajax");
        generate_users.click();
        var args = $.ajax.mostRecentCall.args[0];
        expect(args.data).toEqual({ organizations: ['1', '3'] });
        expect(args.dataType).toEqual('json');
        expect(args.type).toEqual('POST');
        expect(args.url).toEqual('/orphans')
    });
    it('overwrites checkbox with server response', function () {
        spyOn($, "ajax").andCallFake(function (params) { 
          params.success({
              1: 'I have returned.',
              3: 'Galahoslos?'
          });
        });
        generate_users.click();
        expect($('#1 .response')).toHaveHtml('I have returned.');
        expect($('#2 .response')).toHaveHtml('<input type="checkbox" value="2" />');
        expect($('#3 .response')).toHaveHtml('Galahoslos?');
        expect($('#4 .response')).toHaveHtml('<input type="checkbox" value="4" />');
    });
    it('color codes the server responses', function () {
        spyOn($, "ajax").andCallFake(function (params) { 
          params.success({
              1: 'Error: Email is invaid.',
              3: 'Error: Email is already in use.'
          });
        });
        generate_users.click();
        expect($('#1')).toHaveClass('alert');
        expect($('#2')).not.toHaveClass('alert');
        expect($('#3')).toHaveClass('alert');
        expect($('#4')).not.toHaveClass('alert');
    });
//    it('inserts failure message if unsuccessful', function() {
//        spyOn( $, "ajax" ).andCallFake(function (params) { 
//          params.error("error");
//        });
//        generate_user.click();
//        expect($('#362 span')).toHaveText('error')
//    });
});