class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_header_visibility
  
  private

  def set_header_visibility
    @show_header = true # デフォルトはヘッダーを表示する
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:account, :nickname, :email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:account])
  end
  
end
