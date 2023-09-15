class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_header_visibility
  before_action :set_footer_visibility
  
  private

# デフォルトはヘッダーフッターを表示する
  def set_header_visibility
    @show_header = true 
  end
  
  def set_footer_visibility
    @show_footer = true 
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:account, :nickname, :email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:account])
  end
  
end
