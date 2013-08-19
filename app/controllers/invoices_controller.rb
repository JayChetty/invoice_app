class InvoicesController < ApplicationController
  before_filter :require_type, only: :index 

  def index

    @title = "Invoices | #{params[:type].capitalize} "
  	@statuses = ['draft', 'submitted', 'authorised', 'paid']

    case params[:type]
    when 'receivable' 
      typestring = 'ACCREC'
    when 'payable'
      typestring = 'ACCPAY'
    end


  	directory = Rails.root.join("privatekey.pem");

    @client = Xeroizer::PrivateApplication.new('KG1EP8X6WHVREFHRAL3MVLPPOKO0MS', 'NIWG1XHRHG6O21CV6Z75ESTLLUTRNT', directory)
    @invoices_alltype = @client.Invoice.all(where: {type: typestring})

    #Filter by status
    if params[:status]
  	  @invoices = @invoices_alltype.select {|i| i.status == params[:status].upcase}
    else
      @invoices = @invoices_alltype
    end

  	@sums = {} 

  	@statuses.each do |s|
  		@sums[s] = 0.0
	  	@invoices_alltype.each do |i| 
	  		@sums[s] += i.total if i.status == s.upcase
	  	end
  	end

    #Tailor Sums for ouput
  	@sums['Authorised Overdue'] = 0.0
  	@invoices_alltype.each do |i| 
	  	@sums['Authorised Overdue'] += i.amount_due if i.status == 'AUTHORISED' && Date.today > i.due_date
	  end

    @sums.except!('paid')

  rescue => e
    flash.now[:error] =  e.message 
    @invoices = []   
    @sums = {}

  end
    #    flash.now[:error] =  e.message

  def show
  end

  private
    def require_type 
      redirect_to invoices_all_path('receivable') unless params[:type]  
    end

end
