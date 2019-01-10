module Journea
  class Data

    attr_reader :keyvalues

    def initialize(keyvalue_collection)
      @keyvalues = keyvalue_collection
    end

    # TODO: Currently having to eat this rubocop error until such time as we
    # understand what form the respond_to_missing? should take
    # rubocop:disable Style/MethodMissing
    def method_missing(method_sym, *arguments, &block)
      val = keyvalues.find_by(key: method_sym).value
      return val if val.present?
      super
    end
    # rubocop:enable Style/MethodMissing
  end
end
