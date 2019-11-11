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

  def sort_column
    Mission.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def search_query
    {name: params[:name], work_state: params[:work_state]}
  end

  def sortable(column)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to t("missions.table.#{column}"), search_path({sort: column, direction: direction}.merge(search_query))
  end
  
end
