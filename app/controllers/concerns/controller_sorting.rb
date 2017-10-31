module Concerns::ControllerSorting
  extend ActiveSupport::Concern

  included do
    def sort_collection(collection, **_opts)
      return collection if sort_param.blank?
      sort_service = SortService.new(collection, sort_param, sort_list)
      return sort_service.sorted_collection if sort_service.ok?

      render(json: { errors: sort_service.errors }, status: sort_service.status)
    end

    def sort_list
      []
    end

    def sort_param
      params[:sort]
    end
  end
end
