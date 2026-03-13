class ApplicationController < ActionController::API
  before_action :ensure_json_format

  private

  def ensure_json_format
    request.format = :json
  end
end
