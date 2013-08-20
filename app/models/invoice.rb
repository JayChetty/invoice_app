class Invoice < ActiveRecord::Base
  attr_accessible :contact_name, :due, :due_date, :paid, :status, :total, :invoice_type, :xero_id
  STATUSES = ['draft', 'submitted', 'authorised', 'paid']

  # scope :recieved, where(type: 'ACCREC')
  # scope :payable, where(type: 'ACCPAY')

  # STATUSES.each do |s|
  # 	scope s, where(status: s)
  # end
  # scope :draft, where(status: 'draft')
  # scope :submitted, where(status: 'submitted')

 	def self.sync_with_xero

 		directory = Rails.root.join("privatekey.pem");
    client = Xeroizer::PrivateApplication.new('KG1EP8X6WHVREFHRAL3MVLPPOKO0MS', 'NIWG1XHRHG6O21CV6Z75ESTLLUTRNT', directory), rate_limit_sleep: 2)
    invoices = client.Invoice.all()	

    Invoice.destroy_all

    invoices.each do |i|
    	Invoice.create(
    		contact_name: i.contact.name,
    		due: i.amount_due,
    		due_date: i.due_date,
    		paid: i.amount_paid,
    		status: i.status,
    		total: i.total,
    		invoice_type: i.type,
    		xero_id: i.invoice_id
    	)
    end
 	end 

 	def self.status_totals(type)
  	sums = {} 
  	STATUSES.each do |s|
  		sums[s] = 0.0
	  	Invoice.where(invoice_type: type).each do |i| 
	  		sums[s] += i.total if i.status == s.upcase
	  	end
  	end 

  	#refactor do in one loop and not find paid
  	sums['Authorised Overdue'] = 0.0
  	Invoice.where(invoice_type: type).each  do |i| 
	  	sums['Authorised Overdue'] += i.due if i.status == 'AUTHORISED' && Date.today > i.due_date
	  end

  	sums.except!('paid')		
 	end
end

