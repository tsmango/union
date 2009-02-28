class ActiveRecord::Base
  class << self
    
    # This simple implementation was extracted from
    # ActiveRecord::Base .find, find_every and construct_finder_sql
    def union(parts, options = {})
      if parts.size >= 2
        scope = scope(:find)
        
        sql = '(' + parts.collect{|part| construct_finder_sql(optionate(part))}.join(') UNION (') + ') '
        add_order!(sql, options[:order], scope)
        add_limit!(sql, options, scope)
      
        records = find_by_sql(sql)
        records.each { |record| record.readonly! } if options[:readonly]
        records
      else
        raise ArgumentError, 'There must be at least 2 parts to a union.'
      end
    end
    
    private
    # This was lifted from ActiveRecord::Base.find
    def optionate(*args)
      options = args.extract_options!
      validate_find_options(options)
      set_readonly_option!(options)
      
      options
    end
  end
end
