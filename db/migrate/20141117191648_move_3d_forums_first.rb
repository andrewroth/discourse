class Move3dForumsFirst < ActiveRecord::Migration
  def change
    header_3d = Category.find_by(name: "3D Forums", header_only: true)
    header_audio = Category.find_by(name: "Audio Forums", header_only: true)
    
    Category.where("position >= ? AND position < ?", header_3d.position, header_audio.position).update_all("position = position - 100")
    p = 0
    Category.order("position asc").each do |c|
      c.update_attribute(:position, p)
      p += 1
    end
  end
end
