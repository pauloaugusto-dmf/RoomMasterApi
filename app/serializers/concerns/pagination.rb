module Pagination
  def paginated_json(collection, json_options: {})
    {
      pagination: {
        page: collection.current_page,
        per_page: collection.limit_value,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total: collection.total_count,
        total_pages: collection.total_pages
      }, items: collection.as_json(json_options)
    }
  end
end
