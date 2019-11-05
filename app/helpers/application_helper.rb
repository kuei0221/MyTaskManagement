module ApplicationHelper
  def show_flash
    if flash.any?
      flash.each do |type, msg|
        if type == "error"
          msg.each {|e| concat content_tag(:p, e)}
        else
          concat content_tag(:p, msg)
        end
      end
    end
  end
end
