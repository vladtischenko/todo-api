class Api::V1::ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_api_v1_user!
  around_action :setup_time_zone, if: :current_user

  private

  def setup_time_zone(&block)
    Time.use_zone(current_user.timezone, &block)
  end

  def current_user
    current_api_v1_user
  end

  rescue_from Pundit::NotAuthorizedError do |_exception|
    render json: {}, status: :forbidden
  end

  def extract_attributes
    params['data'].present? && params['data']['attributes'].present? ? params['data']['attributes'] : {}
  end

  def pagination_params
    if params[:page]
      params.require(:page).permit(:number, :size)
    else
      {}
    end
  end

  def total_pages(object)
    {
      total_pages: object.total_pages,
      total_items: object.total_count
    }
  end

  def links(object)
    url = request.url.split('?')[0]
    size = params['page'] && params['page']['size'] ? params['page']['size'] : 1
    url += "?page[size]=#{size}&"
    {
      'self'  => request.url,
      'prev'  => object.first_page? ? nil : "#{url}page[number]=#{object.prev_page}",
      'next'  => object.last_page? ? nil : "#{url}page[number]=#{object.next_page}",
      'first' => "#{url}page[number]=1",
      'last'  => "#{url}page[number]=#{object.total_pages}"
    }
  end
end
