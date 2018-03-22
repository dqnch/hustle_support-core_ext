require 'set'

module HustleSupport
  module CoreExt
    # See: http://web-salad.hateblo.jp/entry/2014/11/06/122946
    module AttrAccessor
      def to_h
        Hash[self.class.__send__(:attributes).sort.map { |name| [name, public_send(name)] }]
      end

      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        private

        def attributes
          @attributes ||= superclass.respond_to?(:attributes, true) ? superclass.__send__(:attributes) : Set.new
        end

        def attr_reader(*names)
          super
          attributes.merge(names.map(&:to_sym))
        end

        def attr_accessor(*names)
          super
          attributes.merge(names.map(&:to_sym))
        end
      end
    end
  end
end
