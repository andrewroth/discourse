roots = H3d::Forum.roots.order("title")
admin = H3d::User.where(login: 'admin').first
position = 0

t0 = Time.now

# delete uncategorized
Category.where(name: "Uncategorized").first.try(:destroy)

roots.each do |r|
  puts "=== ROOT #{r.title} ==="

  unless Category.find_by(name: r.title)
    c = Category.new
    c.name = r.title
    c.description = r.subtitle
    c.user = admin.discourse_user
    c.header_only = true
    c.position = position
    c.save!
  end
  position += 1

  puts "=== Category header only data (before save): #{c.inspect} ==="

  r.children.each do |f|

    puts "=== #{f.title} ==="
    puts "=== Forum data: #{f.inspect}"

    admin = H3d::User.where(login: "admin").first
    c = Category.where(name: f.title).first

    if f.title == 'Highend3d V5 New Design FAQ : Your transition Guide'
      f.title = 'Highend3d V5 New Design FAQ'
      f.subtitle = 'Your transition Guide'
    end

    unless c
      c = Category.new
      c.name = f.title
      c.description = f.subtitle
      c.user = admin.discourse_user
      c.position = position

      puts "=== Create Category #{c.inspect}"
      
      c.save!
    end
    position += 1

    # store a reference in the h3d forum table to which new discourse category
    f.discourse_category_id = c.id
    puts "=== update #{f.title} discourse_category_id"
    f.save!

    # add all the children
    f.children.each do |child|
      puts "=== Child of #{f.title}: #{child.title}"

      c2 = Category.find_by(name: child.title)

      unless c2
        c2 = Category.new
        c2.name = child.title
        c2.description = child.subtitle
        c2.user = admin.discourse_user
        c2.parent_category_id = c.id
        c2.position = position
        c2.save!
      end
      position += 1

      # store a reference in the h3d forum table to which new discourse category
      puts "=== update child #{child.title} discourse_category_id"
      child.discourse_category_id = c2.id
      child.save!
    end
  end
end

# move Lounge to the bottom
c = Category.where(name: "Lounge").first
c.position = 100
c.save!

# move Meta to the bottom
c = Category.where(name: "Meta").first
c.position = 101
c.save!

# move Staff to the bottom
c = Category.where(name: "Staff").first
c.position = 102
c.save!

puts "Took #{Time.now - t0} seconds to run"
