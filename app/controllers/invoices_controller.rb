class InvoicesController < ApplicationController
  before_filter :require_type, only: :index 
  helper_method :sort_column, :sort_direction
  def index
    @title = "Invoices | #{params[:type].capitalize}"

    if params[:sync] || !Invoice.any? 
      Invoice.sync_with_xero 
      flash[:success] = "Synced succesfully with Xero: #{Invoice.count} Invoices"
    end
    
    if params[:status] && Invoice::STATUSES.include?(params[:status])
      @invoices = Invoice.where(invoice_type: @typestring, status: params[:status].upcase).order("#{sort_column} #{sort_direction}")
    else
      @invoices = Invoice.where(invoice_type: @typestring).order("#{sort_column} #{sort_direction}")
    end

    @status_totals = Invoice.status_totals(@typestring)
    rescue Xeroizer::OAuth::RateLimitExceeded => e     
      flash.now[:error] = e.message
      @invoices = []
      @status_totals = {}

  end

  private
    def require_type 
      #redirect_to invoices_all_path('receivable') unless %w[receivable payable].include?(params[:type])
      case params[:type]
      when 'receivable' 
        @typestring = 'ACCREC'
      when 'payable'
        @typestring = 'ACCPAY'
      else
        redirect_to invoices_all_path('receivable')   
      end
    end

    def sort_column
      Invoice.column_names.include?(params[:sort]) ? params[:sort] : "due_date"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end


end
