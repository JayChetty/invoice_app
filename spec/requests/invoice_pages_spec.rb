require 'spec_helper'

describe "InvoicePages" do
	subject { page }

	describe "Visiting Invoices Path" do
		before {visit root_path}
		it {should have_content("Invoices")}	
	end					
end
