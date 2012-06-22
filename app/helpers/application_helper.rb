module ApplicationHelper
  
  def sortable(column, title = nil)  
    title ||= column.titleize  
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"  
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}   
  end
  
  def markdown(text, *renderer)      
    redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true, 
    :gh_blockcode => true, 
    :safe_links_only => true, 
    :filter_html => true))
    redcarpet.render(text).html_safe
  end
  
  def can_edit?
    user_signed_in? && current_user.admin_or_super?
  end
  
  def user_signed_in?
    current_user != nil
  end
  

  
#  def grid_is_on?
#    Rails.env == 'development' && (user_signed_in? && current_user.grid?)
#  end
  
  
end
