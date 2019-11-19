module SearchHelper
  
  def model_exists?(model)
    klass = ActiveRecord.const_get model.to_s
    return klass.is_a?(Class)
  rescue NameError
    return false 
  end
  
  def column_exists?(model, column)
    if model_exists? model
      model.column_names.include? column
    end
  end

  def is_model_and_column_exists?(model, column)
    model_exists?(model) && column_exists?(model, column)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def search_query(model)
    return nil unless model_exists? model
    model.filterable_column.each_with_object({}) do |column, query|
      query[column] = params.dig(column)
    end
  end

  def sortable(model, column)
    return nil unless is_model_and_column_exists? model, column
    direction = column == params[:sort] && sort_direction == "asc" ? "desc" : "asc"
    controller = params[:controller].include?("admin") ? "admin/search" : "search"
    pass_params = {controller: controller, action: :index, sort: column, direction: direction, model: model.to_s}.merge(search_query model)
    link_to t("#{model.to_s.downcase.pluralize}.table.#{column}"), url_for(pass_params), class: "btn btn-primary text-white" 
  end
end
