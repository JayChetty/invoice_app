class InvoicesController < ApplicationController
  def index
  	statuses = [:draft, :submitted, :authorised, :paid]
  	directory = Rails.root.join("privatekey.pem");
  	@client = Xeroizer::PrivateApplication.new('KG1EP8X6WHVREFHRAL3MVLPPOKO0MS', 'NIWG1XHRHG6O21CV6Z75ESTLLUTRNT', directory)

  	@invoices_all = @client.Invoice.all
  	@rec_invoices = @invoices_all.select {|i| i.type == "ACCREC"}

  	@invoices = @rec_invoices.select {|i| i.status == params[:status].upcase}

  	@sums = {} 

  	#multithreadable
  	statuses.each do |s|
  		@sums[s] = 0.0
	  	@rec_invoices.each do |i| 
	  		@sums[s] += i.total if i.status == s.to_s.upcase
	  	end
  	end

  	@sums[:authorised_due] = 0.0
  	@rec_invoices.each do |i| 
	  	@sums[:authorised_due] += i.total if i.status == "AUTHORISED" && Date.today > i.due_date
	  end


  end

  def show
  end

end
