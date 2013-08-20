class InvoicesController < ApplicationController
  before_filter :require_type, only: :index 
  helper_method :sort_column, :sort_direction
  def index
    @title = "Invoices | #{params[:type].capitalize}"

    if params[:sync] || !Invoice.any? 
      Invoice.sync_with_xero 
      flash[:success] = "Synced succesfully with Xero: #{Invoice.count} Invoices"
    end
    
    case params[:type]
    when 'receivable' 
      typestring = 'ACCREC'
    when 'payable'
      typestring = 'ACCPAY'
    end

    #order = params[:sort] || :due_date

    if params[:status]
      @invoices = Invoice.where(invoice_type: typestring, status: params[:status].upcase).order("#{sort_column} #{sort_direction}")
    else
      @invoices = Invoice.where(invoice_type: typestring)
    end

    @status_totals = Invoice.status_totals(typestring)
    rescue Xeroizer::OAuth::RateLimitExceeded => e     
      flash.now[:error] = e.message
      @invoices = []
      @status_totals = {}

  end

  private
    def require_type 
      redirect_to invoices_all_path('receivable') unless params[:type] 
    end

    def sort_column
      Invoice.column_names.include?(params[:sort]) ? params[:sort] : "due_date"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end


end
