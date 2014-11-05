module ControllerExtensions
  module Organisations::Defaults

    # organisations_path(service: 'without_users')

    def set_params
      defaults = {
        layout: 'two_columns',
        template: 'index',
        scopes: ['order_by_most_recent'],
      }
      defaults.each do |k, v|
        params[k] = v if !admin? || params[k].nil?
      end
      params[:template].prepend(controller_name + '/')
    end

    def set_instance_variables
      @organisations = apply_scopes(Organisation)
      @json = gmap4rails_with_popup_partial(@organisations, 'popup')
      @category_options = Category.html_drop_down_options
    end

    def apply_scopes(klass)
      params[:scopes].each { |s| klass = klass.send(s) }
      klass
    end
  end
end
