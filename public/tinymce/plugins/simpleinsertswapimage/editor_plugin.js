/**
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */


(function() {
  
  tinymce.create('tinymce.plugins.simpleinsertswapimagePlugin', {
    /**
     * Initializes the plugin, this will be executed after the plugin has been created.
     * This call is done before the editor instance has finished it's initialization so use the onInit event
     * of the editor instance to intercept that event.
     *
     * @param {tinymce.Editor} ed Editor instance that the plugin is initialized in.
     * @param {string} url Absolute URL to where the plugin is located.
     */
    init : function(ed, url) {
      // Register the command so that it can be invoked by using tinyMCE.activeEditor.execCommand('mcesimpleinsertswapimage');
      ed.addCommand('mcesimpleinsertswapimage', function() {
        ed.windowManager.open({
          file : ed.getParam('simpleinsertswapimage_dialog_path'),
          width : 600,
          height : 620,
          inline : 1,
          title : "Insert Swap Image"
        }, {
          plugin_url : url, // Plugin absolute URL
          some_custom_arg : 'custom arg' // Custom argument
        });
      });

      // Register simpleinsertswapimage button
      ed.addButton('simpleinsertswapimage', {
        title : 'Insert Before/After Image Switching Effect',
        cmd : 'mcesimpleinsertswapimage',
        image : url + '/img/swapimage.png'
      });

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
        longname : 'simpleinsertswapimage plugin',
        author : 'SheldonD',
        authorurl : '',
        infourl : '',
        version : "1.0"
      };
    },

    insertImage : function(before_original_url, after_original_url, before_image_uid, after_image_uid, before_image_id, after_image_id, max_dimension) {
      tinyMCE.execCommand("mceInsertContent", false,
        '<a href="'+before_original_url+'" class="lb_richtext lightbox item_image" target="_blank" data-before_image_id="'+before_image_id+'" data-after_image_id="'+after_image_id+'">' +
          '<img src="'+this.insertImageThumbPath(before_image_uid, max_dimension)+'" class="item_image swapImage {src: \''+this.insertImageThumbPath(after_image_uid, max_dimension)+'\'}" data-before_image_id="'+before_image_id+'" data-after_image_id="'+after_image_id+'">'+
        '</a>'+
        '<a href="'+after_original_url+'" class="lb_richtext lightbox item_image" style="display:none;" target="_blank" data-before_image_id="'+before_image_id+'" data-after_image_id="'+after_image_id+'">&nbsp;</a>'
      );
    },

    insertImageThumbPath : function(image_uid, max_dimension) {
      return "/thumbs/"+max_dimension+"x"+max_dimension+"%3E?uid="+image_uid;
    }
  });

  // Register plugin
  tinymce.PluginManager.add('simpleinsertswapimage', tinymce.plugins.simpleinsertswapimagePlugin);
})();