module H3d
  class FileAsset < ActiveRecord::Base
    self.table_name = 'assets'

    establish_connection :h3d

    has_attached_file :photo,
                        :styles => {
                        :big => ['820x>', :jpg],
                        :cover => ['200x200#'],
                        :avatar => ['100x100#'],
                          :thumb => ['55x55#']
                        },
                        :url => "/system/:attachment/:id_partition/:id/user_:style/:filename",
                        :path => ":rails_root/public/system/:attachment/:id_partition/:id/user_:style/:filename"
  end
end
