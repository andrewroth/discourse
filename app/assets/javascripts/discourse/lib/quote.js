/**
  Build the BBCode for a Quote

  @class BBCode
  @namespace Discourse
  @module Discourse
**/
Discourse.Quote = {

  REGEXP: /\[quote=([^\]]*)\]((?:[\s\S](?!\[quote=[^\]]*\]))*?)\[\/quote\]/im,

  /**
    Build the BBCode quote around the selected text

    @method buildQuote
    @param {Discourse.Post} post The post we are quoting
    @param {String} contents The text selected
  **/
  build: function(post, contents) {
    var contents_hashed, result, sansQuotes, stripped, stripped_hashed, tmp;
    if (!contents) contents = "";

    sansQuotes = contents.replace(this.REGEXP, '').trim();
    if (sansQuotes.length === 0) return "";

    // Escape the content of the quote
    sansQuotes = sansQuotes.replace(/</g, "&lt;")
                           .replace(/>/g, "&gt;");

    //result = "[quote=\"" + post.get('username') + ", post:" + post.get('post_number') + ", topic:" + post.get('topic_id');
    result = "<div><blockquote class='inline_quote'><span class='someonesaid'>" + post.get('username') + "</span><div>" + contents + "</div></blockquote></div><div></div>";
    /* TODO See if I can make this look prettier at some point... like the <aside> tag below

    [24] pry(main)> PrettyText.markdown(%|[quote="andrewroth, post:1, topic:321, full:true"]\nJust testing some stuff\n[/quote]|)
        User Load (2.6ms)  SELECT  "users".* FROM "users"  WHERE "users"."username_lower" = 'andrewroth' LIMIT 1
        => "<aside class=\"quote\" data-post=\"1\" data-topic=\"321\" data-full=\"true\"><div class=\"title\"><div class=\"quote-controls\"></div><img width='20' height='20' src='/user_avatar/localhost/andrewroth/40/383.png' class='avatar'>andrewroth:</div><blockquote><p>Just testing some stuff</p></blockquote></aside>"
        */

    /* Strip the HTML from cooked */
    tmp = document.createElement('div');
    tmp.innerHTML = post.get('cooked');
    stripped = tmp.textContent || tmp.innerText;

    /*
      Let's remove any non alphanumeric characters as a kind of hash. Yes it's
      not accurate but it should work almost every time we need it to. It would be unlikely
      that the user would quote another post that matches in exactly this way.
    */
    stripped_hashed = stripped.replace(/[^a-zA-Z0-9]/g, '');
    contents_hashed = contents.replace(/[^a-zA-Z0-9]/g, '');

    /* If the quote is the full message, attribute it as such */
    //if (stripped_hashed === contents_hashed) result += ", full:true";
    //result += "\"]\n" + sansQuotes + "\n[/quote]\n\n";

    return result;
  }

};
