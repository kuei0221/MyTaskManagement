module ApplicationHelper
  def show_flash
    if flash.any?
      flash.each do |type, msg|
        if type == "error"
          msg.each {|e| concat content_tag(:p, e, class: "alert alert-danger")}
        else
          alert_style = "info"
          alert_style = "warning" if type == "alert"
          alert_style = "success" if type == "success"
          concat content_tag(:p, msg, class: "alert alert-#{alert_style}")
        end
      end
    end
  end

end
