module Storytime::Enum
  extend ActiveSupport::Concern

  def self.extended(base) # :nodoc:
    base.class_attribute(:defined_enums)
    base.defined_enums = {}
  end

  def inherited(base) # :nodoc:
    base.defined_enums = defined_enums.deep_dup
    super
  end

  def enum(definitions)
    klass = self
    definitions.each do |name, values|
      # statuses = { }
      enum_values = ActiveSupport::HashWithIndifferentAccess.new
      name        = name.to_sym

      # def self.statuses statuses end
      klass.singleton_class.send(:define_method, name.to_s.pluralize) { enum_values }

      _enum_methods_module.module_eval do
        # def status=(value) self[:status] = statuses[value] end
        define_method("#{name}=") { |value|
          if enum_values.has_key?(value) || value.blank?
            self[name] = enum_values[value]
          elsif enum_values.has_value?(value)
            # Assigning a value directly is not a end-user feature, hence it's not documented.
            # This is used internally to make building objects from the generated scopes work
            # as expected, i.e. +Conversation.archived.build.archived?+ should be true.
            self[name] = value
          else
            raise ArgumentError, "'#{value}' is not a valid #{name}"
          end
        }

        # def status() statuses.key self[:status] end
        define_method(name) { enum_values.key self[name] }

        # def status_before_type_cast() statuses.key self[:status] end
        define_method("#{name}_before_type_cast") { enum_values.key self[name] }

        pairs = values.respond_to?(:each_pair) ? values.each_pair : values.each_with_index
        pairs.each do |value, i|
          enum_values[value] = i

          # def active?() status == 0 end
          define_method("#{value}?") { self[name] == i }

          # def active!() update! status: :active end
          define_method("#{value}!") { update! name => value }

          # scope :active, -> { where status: 0 }
          klass.scope value, -> { klass.where name => i }
        end
      end
      defined_enums[name.to_s] = enum_values
    end
  end

  private
    def _enum_methods_module
      @_enum_methods_module ||= begin
        mod = Module.new do
          private
            def save_changed_attribute(attr_name, value)
              if (mapping = self.class.defined_enums[attr_name.to_s])
                if attribute_changed?(attr_name)
                  old = changed_attributes[attr_name]

                  if mapping[old] == value
                    changed_attributes.delete(attr_name)
                  end
                else
                  old = clone_attribute_value(:read_attribute, attr_name)

                  if old != value
                    changed_attributes[attr_name] = mapping.key old
                  end
                end
              else
                super
              end
            end
        end
        include mod
        mod
      end
    end
end
