class InvoicesController < ApplicationController
  before_filter :require_correct_type, only: :index # Require a type to be given otherwise default to receivable
  before_filter :require_status_correct, only: :index # Status must be valid otherwise show all
  helper_method :sort_column, :sort_direction
  def index
    @title = "Invoices | #{params[:type].capitalize}"

    if params[:sync] 
      Invoice.sync_with_xero 
      flash[:success] = "Synced succesfully with Xero: #{Invoice.count} Invoices"
    end
    
    if params[:status]
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
    def require_correct_type 
      case params[:type]
      when 'receivable' 
        @typestring = 'ACCREC'
      when 'payable'
        @typestring = 'ACCPAY'
      else
        redirect_to invoices_all_path('receivable')   
      end
    end

    def require_status_correct
      redirect_to invoices_all_path(params[:type]) if params[:status] && !Invoice::STATUSES.include?(params[:status])  
    end

    def sort_column
      Invoice.column_names.include?(params[:sort]) ? params[:sort] : "due_date"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end


end
