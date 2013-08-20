class InvoicesController < ApplicationController
  before_filter :require_type, only: :index 

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

    if params[:status]
      @invoices = Invoice.where(invoice_type: typestring, status: params[:status].upcase)
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

end
