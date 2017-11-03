module Concerns::ControllerFiltering
  extend ActiveSupport::Concern

  included do
    def filter_collection(collection, query_service)
      return collection unless params[:filter].present? && !params[:filter]&.values&.all?(&:blank?)
      query_service.new(collection, filter_params).call
    end

    def filter_params
      params.require(:filter).permit(filter_list)
    end

    def filter_list
      []
    end
  end
end
