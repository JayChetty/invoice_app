class InvoicesController < ApplicationController
  before_filter :require_type, only: :index 

  def index
    if params[:sync] || !Invoice.any? 
      Invoice.sync_with_xero 
      flash[:success] = "Synced succesfully with Xero: #{Invoice.count} Invoices"
    end

    @title = "Invoices | #{params[:type].capitalize} "

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

  # rescue Xeroizer::OAuth::RateLimitExceeded => e
  #   flash[:error] = e.message

  end

  private
    def require_type 
      redirect_to invoices_all_path('receivable') unless params[:type] 
    end

end
