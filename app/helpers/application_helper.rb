module ApplicationHelper
  def full_title(page_title)
  	base_title = "Trinity Mar Thoma Church Youth Fellowship"
  	if page_title.empty?
  		base_title
  	else
  		"#{page_title} | #{base_title}"
  	end
  end
  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end
end