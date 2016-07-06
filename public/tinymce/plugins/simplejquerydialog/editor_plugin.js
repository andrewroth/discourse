/**
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */


(function() {
  
  tinymce.create('tinymce.plugins.simplejquerydialogPlugin', {
    /**
     * Initializes the plugin, this will be executed after the plugin has been created.
     * This call is done before the editor instance has finished it's initialization so use the onInit event
     * of the editor instance to intercept that event.
     *
     * @param {tinymce.Editor} ed Editor instance that the plugin is initialized in.
     * @param {string} url Absolute URL to where the plugin is located.
     */
    init : function(ed, url) {
      // Register the command so that it can be invoked by using tinyMCE.activeEditor.execCommand('mcesimplejquerydialog');
      ed.addCommand('mcesimplejquerydialog', function() {
        $(ed.getParam('simplejquerydialog_dialog_selector')).dialog("open");
        ed.getParam('simplejquerydialog_function')();
      });

      // Register simplejquerydialog button
      ed.addButton('simplejquerydialog', {
        title : ed.getParam('simplejquerydialog_button_title'),
        cmd : 'mcesimplejquerydialog',
        image : url + ed.getParam('simplejquerydialog_button_img')
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
        longname : 'simplejquerydialog plugin',
        author : 'SheldonD',
        authorurl : '',
        infourl : '',
        version : "1.0"
      };
    }

  });

  // Register plugin
  tinymce.PluginManager.add('simplejquerydialog', tinymce.plugins.simplejquerydialogPlugin);
})();