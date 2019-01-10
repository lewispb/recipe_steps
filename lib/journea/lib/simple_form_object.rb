# Originally from: https://github.com/reinteractive-open/simple_form_object
# Copied here (along with specs) so we can add Rails 5 support and tweak as needed
module SimpleFormObject
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ActiveModel::Callbacks

  # TODO: There are a number of self. calls that rubocop claims are redundant
  # in this file that need to be investigated.
  # rubocop:disable Style/RedundantSelf
  module ClassMethods
    def attribute(name, type = :string, options = {})
      self.send(:attr_accessor, name)

      _attributes << Attribute.new(name, options, type)
    end

    def delegate_all(options = {})
      @_delegation_target = options.fetch(:to)
    end

    def _delegation_target
      @_delegation_target
    end

    def _attributes
      @_attributes ||= []
    end

    def attributes
      @_attributes
    end

    def _attribute(attribute_name)
      _attributes.select { |a| a.name == attribute_name }.first
    end

    def model_name
      ActiveModel::Name.new(self, nil, self.to_s.gsub(/Step$/, ""))
    end
  end

  # TODO: Currently having to eat this rubocop error until such time as we
  # understand what form the respond_to_missing? should take
  # rubocop:disable Style/MethodMissing
  def method_missing(method, *args, &block)
    return super unless delegatable?(method)

    # TODO: Figure out why self.class.delegate(method, to: self.class._delegation_target)
    # doesn't work.

    # TODO: At this time don't understand enough about the gem to understand how
    # best to resolve this issue.
    # rubocop:disable Lint/ShadowingOuterLocalVariable
    self.class.send(:define_method, method) do |*args, &block|
      _delegation_target.send(method, *args, &block)
    end
    # rubocop:enable Lint/ShadowingOuterLocalVariable

    send(method, *args, &block)
  end
  # rubocop:enable Style/MethodMissing

  def delegatable?(method)
    if !_delegation_target.nil?
      _delegation_target.respond_to?(method)
    else
      false
    end
  end

  def _delegation_target
    target = self.class._delegation_target

    if target.is_a? Symbol
      self.send(target)
    else
      target
    end
  end

  def column_for_attribute(attribute)
    self.class._attribute(attribute).fake_column
  end

  def attribute?(attribute_name)
    self.class._attribute(attribute_name).present?
  end

  def initialize(attributes = {})
    super
    self.class._attributes.each do |attribute|
      attribute.apply_default_to(self)
    end
  end

  def attributes
    attribs = {}
    self.class._attributes.each do |a|
      attribs[a.name] = self.send(a.name)
    end
    attribs
  end

  class Attribute
    def initialize(name, options, type = nil)
      @name = name
      @type = type || :string
      @options = options

      extract_options
    end

    attr_accessor :name, :type, :options

    def fake_column
      self
    end

    def apply_default_to(form)
      return unless form.send(@name).nil?

      form.send("#{@name}=", default_value(form)) if @apply_default
    end

    private

    def default_value(context)
      if @default.respond_to?(:call)
        context.instance_eval(&@default)
      else
        @default
      end
    end

    def extract_options
      @apply_default = true
      @default = options.fetch(:default) do
        @apply_default = false
        nil
      end
      @skip_validations = options.fetch(:skip_validations, false)
    end
  end
  # rubocop:enable Style/RedundantSelf
end
