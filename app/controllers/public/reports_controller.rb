class Public::ReportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @report = Report.new
    render :layout => false
  end

  def create
    content_type = params[:report][:content_type]
    content_id = params[:report][:content_id]
    @content = content_type.constantize.find(content_id)

    if @content
      @report = Report.new(report_params)
      @report.reporter = current_user
      @report.reported = @content.user

      if @report.save
        respond_to do |format|
          format.js { render "create_success" }
        end
      else
        respond_to do |format|
          format.js { render "create_failure" }
        end
      end
    end

  rescue ActiveRecord::NotNullViolation => e
    # NOT NULL 制約違反が発生した場合もエラー処理
    respond_to do |format|
      format.js { render "create_failure", status: :unprocessable_entity }
    end
  end


  private

  def find_content(content_type, content_id)
    content_class = content_type.classify.constantize
    content_class.find_by(id: content_id)
  end

  def report_params
    params.require(:report).permit(:content_type, :content_id, :reason)
  end
end
