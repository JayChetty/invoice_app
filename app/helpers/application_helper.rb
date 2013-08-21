module ApplicationHelper

	def sortable(column, title = nil)
	  title ||= column.titleize
	  title <<  (sort_direction == "asc" ? "<i class=\"icon-chevron-up\"></i>" : "<i class=\"icon-chevron-down\"></i>") if column == sort_column
	  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	  link_to title.html_safe, {sort: column, direction: direction}
	end	
end
