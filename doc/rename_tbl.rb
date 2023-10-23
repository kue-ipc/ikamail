#! ruby

# Usage
# ruby rename_tbl.rb < pre_sql > post_sql

if $0 == __FILE__
  ARGF.each_line do |line|
    print line.gsub("template", "mail_template")
  end
end
