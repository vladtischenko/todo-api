class Api::V1::ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_api_v1_user!
  around_action :set_time_zone, if: :current_user

  private

  def set_time_zone(&block)
    Time.use_zone(current_user.timezone, &block)
  end

  def current_user
    current_api_v1_user
  end

  rescue_from Pundit::NotAuthorizedError do |exception|
    render json: {}, status: :forbidden
  end

  def extract_attributes
    params['data'].present? && params['data']['attributes'].present? ? params['data']['attributes'] : {}
  end
end
