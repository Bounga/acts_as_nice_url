module Bounga
  module Acts
    module NiceUrl
      def self.included(base)
        base.extend ClassMethods
      end
      
      # This acts_as extension provides the capabilities for creating a nice url based on an attribute of the current object.
      # You can set / unset the object id in front of the URL and choose the object attribute to use to generate the URL.
      #
      # This extension requires Iconv to be install on your system
      #
      # Author example:
      #
      #   class Author < ActiveRecord::Base
      #     acts_as_nice_url :id => false, :title => :full_name
      #   end
      module ClassMethods
        # Configuration options are:
        #
        # * +id+ - specifies if the object id has to be in front of the URL or not (default: +true+)
        # * +title+ - specifies the object attribute to use to generate the URL. You can use a symbol 
        # or a string (default: +title+)
        def acts_as_nice_url(options = {})
          include Bounga::Acts::NiceUrl::InstanceMethods
          
          configuration = { :id => true, :title => :title }
          configuration.update(options) if options.is_a?(Hash)
          
          class_eval <<-EOV
            def nice_title
              #{configuration[:title]}
            end

            def nice_id
              #{configuration[:id]}
            end
          EOV
        end
      end

      # All the methods available to a record that has had <tt>acts_as_nice_url</tt> specified.
      module InstanceMethods
        def to_param
          s = nice_title.to_s.parameterize
          
          if nice_id
            s = [self.id, s].join('-')
          end
          
          return s
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Bounga::Acts::NiceUrl)


