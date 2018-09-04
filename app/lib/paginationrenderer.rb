class Paginationrenderer < WillPaginate::ActionView::LinkRenderer
  protected

  def page_number(page)
    if page == current_page
      tag(:em, page, :class => 'current')
    else
      link(page, page, :rel => rel_value(page), :title => 'Page ' + page.to_s)
    end
  end

  def previous_page
    num = @collection.current_page > 1 && @collection.current_page - 1
    previous_or_next_page(num, @options[:previous_label], 'previous_page', 'Previous Page')
  end

  def next_page
    num = @collection.current_page < total_pages && @collection.current_page + 1
    previous_or_next_page(num, @options[:next_label], 'next_page', 'Next Page')
  end

  def previous_or_next_page(page, text, classname, tooltip)
    if page
      link(text, page, :class => classname, :title => tooltip)
    else
      tag(:span, text, :class => classname + ' disabled')
    end
  end
end
