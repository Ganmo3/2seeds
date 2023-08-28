class Public::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :hide_header, only: [:new]
  
  def new
    @report = Report.new
    render :layout => false
  end

  def create
    if current_user.guest_user?
      respond_to do |format|
        format.js { render "create_failure" } # ゲストユーザーの場合は通報失敗時のレスポンスファイルを指定
     end
    else
      content_type = params[:report][:content_type]
      content_id = params[:report][:content_id]
      @content = content_type.constantize.find(content_id)
  
      if @content
        @report = Report.new(report_params)
        @report.reporter = current_user
        @report.reported = @content.user
        if @report.save
          respond_to do |format|
            format.js { render "create_success" } # 通報成功時のレスポンスファイルを指定
          end
        else
          respond_to do |format|
            format.js { render "create_failure" } # 通報失敗時のレスポンスファイルを指定
          end
        end
      else
        respond_to :js
      end
    end
  end

  private

  def hide_header
    @show_header = false
  end

  def find_content(content_type, content_id)
    content_class = content_type.classify.constantize
    content_class.find_by(id: content_id)
  end

  def report_params
    params.require(:report).permit(:content_type, :content_id, :reason)
  end
end
