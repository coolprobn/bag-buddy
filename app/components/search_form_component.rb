class SearchFormComponent < ViewComponent::Base
  def initialize(q:, url: nil, fields: [], form_class: nil, &block)
    @q = q
    @url = url
    @fields = fields
    @form_class = form_class || "flex flex-col sm:flex-row gap-4"
    @block = block
  end

  private

  attr_reader :q, :url, :fields, :form_class, :block

  def search_url
    url || helpers.request.path
  end
end
