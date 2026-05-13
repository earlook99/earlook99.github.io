#!/usr/bin/env ruby
#
# Sets post date from the first git commit time when frontmatter omits `date:`.
# Frontmatter `date:` always wins if present.

Jekyll::Hooks.register :posts, :post_init do |post|
  content = File.read(post.path)
  frontmatter_match = content.match(/\A---\s*\n(.*?)\n---/m)
  next unless frontmatter_match

  next if frontmatter_match[1].match(/^date\s*:/)

  first_commit_date = `git log --diff-filter=A --follow --format=%aI -- "#{post.path}" | tail -1`.strip
  next if first_commit_date.empty?

  begin
    post.data['date'] = Time.parse(first_commit_date)
  rescue ArgumentError
    # keep filename-derived date as fallback
  end
end
