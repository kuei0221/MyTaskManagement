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

  def sort_column
    Mission.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def search_query
    {name: params[:name], work_state: params[:work_state], priority: params[:priority]}
  end

  def sortable(column)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to t("missions.table.#{column}"), search_path({sort: column, direction: direction}.merge(search_query)), class: "btn btn-primary text-white"
  end
  
end
