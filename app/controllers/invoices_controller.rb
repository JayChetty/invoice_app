class InvoicesController < ApplicationController
  def index
  	directory = Rails.root.join("privatekey.pem");
  	@client = Xeroizer::PrivateApplication.new('KG1EP8X6WHVREFHRAL3MVLPPOKO0MS', 'NIWG1XHRHG6O21CV6Z75ESTLLUTRNT', directory)
  	@contacts = @client.Contact.all
  	@invoices = @client.Invoice.all
  	@invoice = @invoices.first
  end

  def show
  end
end
