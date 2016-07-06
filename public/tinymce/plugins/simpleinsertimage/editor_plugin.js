/**
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */


(function() {
  
  tinymce.create('tinymce.plugins.simpleinsertimagePlugin', {

    //window: null,

    //getWindow: function() { return window; },

    /**
     * Initializes the plugin, this will be executed after the plugin has been created.
     * This call is done before the editor instance has finished it's initialization so use the onInit event
     * of the editor instance to intercept that event.
     *
     * @param {tinymce.Editor} ed Editor instance that the plugin is initialized in.
     * @param {string} url Absolute URL to where the plugin is located.
     */
    init : function(ed, url) {
      // Register the command so that it can be invoked by using tinyMCE.activeEditor.execCommand('mcesimpleinsertimage');
      ed.addCommand('mcesimpleinsertimage', function() {
        window = ed.windowManager.open({
          file : ed.getParam('simpleinsertimage_dialog_path'),
          width : 900,
          height : 700,
          inline : 1,
          title : "Insert Image"
        }, {
          plugin_url : url, // Plugin absolute URL
          some_custom_arg : 'custom arg' // Custom argument
        });
      });

      // Register simpleinsertimage button
      ed.addButton('simpleinsertimage', {
        title : 'Upload/Insert Images',
        cmd : 'mcesimpleinsertimage',
        image : url + '/img/simpleinsertimage.png'
      });

      // Add a node change handler, selects the button in the UI when a image is selected
      ed.onNodeChange.add(function(ed, cm, n) {
        cm.setActive('simpleinsertimage', n.nodeName == 'IMG');
      });

      // Remove the other image manager context menu items ( http://www.tinymce.com/forum/viewtopic.php?id=22709 )
      if(typeof ed.plugins.contextmenu !== 'undefined') {
        ed.plugins.contextmenu.onContextMenu.add(function (sender, menu) {
          // create a new object
          var otherItems = {};
          for (var itemName in menu.items) {
            var item = menu.items[itemName];
            if (/^mce_/.test(itemName)) {
              if (item.settings) {
                if (item.settings.cmd == "mceImage" || item.settings.cmd == "mceAdvImage") {
                  // skip these items
                  continue;
                }
              }
            }
            // add all other items to this new object, so it is effectively a clone
            // of menu.items but without the offending entries
            otherItems[itemName] = item;
          }
          // replace menu.items with our new object
          menu.items = otherItems;
        });
      }
    },

    /**
     * Creates control instances based in the incomming name. This method is normally not
     * needed since the addButton method of the tinymce.Editor class is a more easy way of adding buttons
     * but you sometimes need to create more complex controls like listboxes, split buttons etc then this
     * method can be used to create those.
     *
     * @param {String} n Name of the control to create.
     * @param {tinymce.ControlManager} cm Control manager to use inorder to create new control.
     * @return {tinymce.ui.Control} New control instance or null if no control was created.
     */
    createControl : function(n, cm) {
      return null;
    },

    /**
     * Returns information about the plugin as a name/value array.
     * The current keys are longname, author, authorurl, infourl and version.
     *
     * @return {Object} Name/value array containing information about the plugin.
     */
    getInfo : function() {
      return {
        longname : 'simpleinsertimage plugin',
        author : 'AndrewR',
        authorurl : '',
        infourl : '',
        version : "1.0"
      };
    },

    insertImage : function(original_url, image_uid, image_id, max_dimension) {

      tinyMCE.execCommand("mceInsertRawHTML", false,
        '<a href="'+original_url+'" class="lb_richtext lightbox item_image" target="_blank" data-image_id="'+image_id+'" data-image_uid="'+image_uid+'">' +
          '<img src="'+this.insertImageThumbPath(image_uid, max_dimension)+'" class="item_image" data-image_id="'+image_id+'" data-image_uid="'+image_uid+'">'+
        '</a><div></div>'
      );
    },

    removeImageFromEditor : function(e, data) {
      image_id = $(data.url.split('/')).last()[0];

      $.each(tinyMCE.editors, function() {
        this.dom.remove(this.dom.select('[data-image_id='+image_id+']')); // remove all elements with attribute data-image_id with value in var image_id
        this.dom.remove(this.dom.select('[data-before_image_id='+image_id+']')); // for before/after images
        this.dom.remove(this.dom.select('[data-after_image_id='+image_id+']')); // for before/after images
      });
    },

    insertImageThumbPath : function(image_uid, max_dimension) {
      return "/thumbs/"+max_dimension+"x"+max_dimension+"%3E?uid="+image_uid;
    }

  });

  // Register plugin
  tinymce.PluginManager.add('simpleinsertimage', tinymce.plugins.simpleinsertimagePlugin);
})();
