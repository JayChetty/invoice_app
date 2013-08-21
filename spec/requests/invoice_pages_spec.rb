require 'spec_helper'

describe "InvoicePages" do
	subject { page }

	describe "Visiting Root Path" do
		before { visit root_path }
		specify { current_path.should == invoices_all_path('receivable')}
		it { should have_content("Invoices") }	
	end	

	describe "Visiting a type no status" do
		before {visit invoices_all_path('payable')}
		it {should have_css('li.active', text: 'All')}
		it {should have_css('i.icon-chevron-down')}
		describe "Clicking on sort link" do
			before {click_link('Due Date')}
			it {should have_css('i.icon-chevron-up')}
			it {should_not have_css('i.icon-chevron-down')}
		end
	end	

	describe "Visiting a status" do
		before {visit invoices_path('receivable', 'authorised')}
		it {should have_css('li.active', text: 'Authorised')}
		it {should_not have_css('li.active', text: 'All')}
	end

	describe "Visiting with incorrect type" do
		before {visit invoices_all_path('lalala')}
		it { should have_content("Receivable") }
		specify { current_path.should == invoices_all_path('receivable')}
	end

	#  Could alter behaviour to redirect to the given status
	describe "Visiting with incorrect type correct status" do
		before {visit invoices_path('lalala', 'authorised')}
		it { should have_content("Receivable") }
		specify { current_path.should == invoices_all_path('receivable')}
	end	

	describe "Visiting with correct type incorrect status" do
		before {visit invoices_path('receivable', 'lalala')}
		it { should have_content("Receivable") }
		specify { current_path.should == invoices_all_path('receivable')}
	end	

	describe "Visiting with incorrect type incorrect status" do
		before {visit invoices_path('lalala', 'lalala')}
		it { should have_content("Receivable") }
		specify { current_path.should == invoices_all_path('receivable')}
	end		
end
