module StatusesHelper
  
  # To delete!!
  def accrodion_chosen_content_options(is_admin)
    @html_options = { :class => 'chosen-select-rtl', :multiple => true, :disabled => true }
    @html_options[:disabled] = false if is_admin
    @html_options
  end
end
