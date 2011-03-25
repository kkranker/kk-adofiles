CmdUtils.makeSearchCommand({
  name: "econpapers",
  author: { name: "Keith Kranker"},
  homepage: "http://econ-server.umd.edu/~kranker/code/Ubiquity_Econ.php",
  synonyms: ["econpapers-search"],
  url:  "http://econpapers.repec.org/scripts/search.asp?ft={QUERY}&pg=",
  icon: "http://econpapers.repec.org/favicon.ico",
  description: "Searches in <a href=\"http://econpapers.repec.org\">EconPapers</a> for content matching your words.",
  preview: function( pblock, thing ) {
    if (thing.text < 1) {
      pblock.innerHTML = "Search <b>EconPapers</b>"; return;
    }
    jQuery.get(this.url.replace("{QUERY}", thing.text),
    function (doc) {
      var tempElement = CmdUtils.getHiddenWindow().document.createElementNS("http://www.w3.org/1999/xhtml", "table");
      tempElement.innerHTML = doc;
      pblock.innerHTML = "Found at <b>econpapers.repec.org:</b>";
      for( var i=0; i<=9; i++ ) {
        pblock.innerHTML += "<div style='display: block; margin-top: 5px; clear: both; ' >" + (i+1) + ". <a style='font-size: 14px; font-weight: bold' href='http://econpapers.repec.org" + jQuery("p.reflist a", tempElement).eq(i).attr("href") + "'>" + jQuery("p.reflist a",tempElement).eq(i).text() + "</a></br>" + jQuery("p.reflist i",tempElement).eq(i).text() +"</div></br>";
      }
    })
  }
});
    
CmdUtils.makeSearchCommand({
  name: "econpapers-author",
  author: { name: "Keith Kranker"},
  homepage: "http://econ-server.umd.edu/~kranker/code/Ubiquity_Econ.php",
  url:  "http://econpapers.repec.org/scripts/search.asp?aus={QUERY}&pg=",
  icon: "http://econpapers.repec.org/favicon.ico",
  description: "Searches Authors in <a href=\"http://econpapers.repec.org\">EconPapers</a> for content matching your words.",
  preview: function( pblock, thing ) {
    if (thing.text < 1) {
      pblock.innerHTML = "Search <b>Author</b> in <b>EconPapers</b>"; return;
    }
    jQuery.get(this.url.replace("{QUERY}", thing.text),
    function (doc) {
      var tempElement = CmdUtils.getHiddenWindow().document.createElementNS("http://www.w3.org/1999/xhtml", "table");
      tempElement.innerHTML = doc;
      pblock.innerHTML = "Found in <b>Authors</b> at <b>econpapers.repec.org:</b>";
      for( var i=0; i<=9; i++ ) {
        pblock.innerHTML += "<div style='display: block; margin-top: 5px; clear: both; ' >" + (i+1) + ". <a style='font-size: 14px; font-weight: bold' href='http://econpapers.repec.org" + jQuery("p.reflist a", tempElement).eq(i).attr("href") + "'>" + jQuery("p.reflist a",tempElement).eq(i).text() + "</a></br>" + jQuery("p.reflist i",tempElement).eq(i).text() +"</div></br>";
      }
    })
  }
});
    
CmdUtils.makeSearchCommand({
  name: "econpapers-title",
  author: { name: "Keith Kranker"},
  homepage: "http://econ-server.umd.edu/~kranker/code/Ubiquity_Econ.php",
  url:  "http://econpapers.repec.org/scripts/search.asp?kw={QUERY}&pg=",
  icon: "http://econpapers.repec.org/favicon.ico",
  description: "Searches Titles and Keywords in <a href=\"http://econpapers.repec.org\">EconPapers</a> for content matching your words.",
  preview: function( pblock, thing ) {
    if (thing.text < 1) {
      pblock.innerHTML = "Search <b>Titles and Keywords</b> in <b>EconPapers</b>"; return;
    }
    jQuery.get(this.url.replace("{QUERY}", thing.text),
    function (doc) {
      var tempElement = CmdUtils.getHiddenWindow().document.createElementNS("http://www.w3.org/1999/xhtml", "table");
      tempElement.innerHTML = doc;
      pblock.innerHTML = "Found in <b>Titles and Keywords</b> at <b>econpapers.repec.org:</b>";
      for( var i=0; i<=9; i++ ) {
        pblock.innerHTML += "<div style='display: block; margin-top: 5px; clear: both; ' >" + (i+1) + ". <a style='font-size: 14px; font-weight: bold' href='http://econpapers.repec.org" + jQuery("p.reflist a", tempElement).eq(i).attr("href") + "'>" + jQuery("p.reflist a",tempElement).eq(i).text() + "</a></br>" + jQuery("p.reflist i",tempElement).eq(i).text() +"</div></br>";
      }
    })
  }
});
    
CmdUtils.makeSearchCommand({
  name: "stata",
  author: { name: "Keith Kranker"},
  homepage: "http://econ-server.umd.edu/~kranker/code/Ubiquity_EconPapers.php",
  url:  "http://www.stata.com/search/?q={QUERY}&restrict=&btnG=Search&proxycustom=&client=stata&num=30&output=xml_no_dtd&site=stata&ie=&oe=UTF-8&sort=&proxystylesheet=stata",
  icon: "http://www.stata.com/favicon.ico",
  description: "Searches <a href=\"http://www.stata.com\">Stata.com</a> for content matching your words.",
  preview: function( pblock, thing ) {
    if (thing.text < 1) {
      pblock.innerHTML = "Search <a href=\"http://www.stata.com\">Stata.com</a>"; return;
    }
    jQuery.get(this.url.replace("{QUERY}", thing.text),
    function (doc) {
      var tempElement = CmdUtils.getHiddenWindow().document.createElementNS("http://www.w3.org/1999/xhtml", "table");
      tempElement.innerHTML = doc;
      pblock.innerHTML = "Found at <b>Stata.com:</b>";
      for( var i=0; i<=9; i++ ) {
        pblock.innerHTML += "<div style='display: block; margin-top: 5px; clear: both; ' >" + (i+1) + ". <a style='font-size: 14px; font-weight: bold' href='" + jQuery("p a", tempElement).eq(i).attr("href") + "'>" + jQuery("span.l",tempElement).eq(i).text() + "</a></br>" + jQuery("span.s",tempElement).eq(i+2).text() +"</div></br>";
      }
    })
  }
});
    
CmdUtils.makeSearchCommand({
  name: "statalist", 
  author: { name: "Keith Kranker"},
  homepage: "http://econ-server.umd.edu/~kranker/code/Ubiquity_EconPapers.php",
  url:  "http://www.stata.com/search/?q={QUERY}&restrict=Statalist&btnG=Search&proxycustom=&client=stata&num=30&output=xml_no_dtd&site=stata&ie=&oe=UTF-8&sort=&proxystylesheet=stata",
  icon: "http://www.stata.com/favicon.ico",
  description: "Searches <a href=\"http://www.stata.com/statalist/\">Statalist</a> archives at <a href=\"http://www.stata.com\">Stata.com</a> for content matching your words.",
  preview: function( pblock, thing ) {
    if (thing.text < 1) {
      pblock.innerHTML = "Search <b>Statalist</b> at <a href=\"http://www.stata.com\">Stata.com</a>"; return;
    }
    jQuery.get(this.url.replace("{QUERY}", thing.text),
    function (doc) {
      var tempElement = CmdUtils.getHiddenWindow().document.createElementNS("http://www.w3.org/1999/xhtml", "table");
      tempElement.innerHTML = doc;
      pblock.innerHTML = "Found in <b><a href=\"http://www.stata.com/statalist/\">Statalist</a></b> archives at <b>Stata.com:</b>";
      for( var i=0; i<=9; i++ ) {
        pblock.innerHTML += "<div style='display: block; margin-top: 5px; clear: both; ' >" + (i+1) + ". <a style='font-size: 14px; font-weight: bold' href='" + jQuery("p a", tempElement).eq(i).attr("href") + "'>" + jQuery("span.l",tempElement).eq(i).text() + "</a></br>" + jQuery("span.s",tempElement).eq(i+2).text() +"</div></br>";
      }
    })
  }
}); 

CmdUtils.CreateCommand({
  names: ["umdlib"],
  author: { name: "Keith Kranker"},
  homepage: "http://econ-server.umd.edu/~kranker/code/Ubiquity_Econ.php",
  icon: "http://www.umd.edu/favicon.ico",
  arguments: [{role: "object", nountype: noun_arb_text, label: "url to prefix"}],
  preview:  "Adds the prefix [http://proxy-um.researchport.umd.edu/login?url=] to the URL you selected. <br />&ensp;<br />Instructions:<ol><li>Open Ubiqity (with <code>ctrl+space</code>) and type start typing <code><b>umdlib</b></code> to pull up command<br />&ensp;</li><li>Hit <code><b>enter</b></code> to open page with new URL</li></ol><p>If you want to use a different URL, select the text on the webpage (with your mouse) before opening Ubiquity. You can also hit <code><b>ctrl+L</b></code> to select your current URL</p><p>Step one is optional -- just type <code>umdlib</code> and hit <code>Enter</code> to use current page.  <br />See <code>http://www.itd.umd.edu/dbs/LinkingGuide.html#proxy</code> for more information.",
  execute: function( arguments ) {
    
    var url= {url: arguments.object.text};
    var prefix = "http://proxy-um.researchport.umd.edu/login?url=";
    Utils.openUrlInBrowser( prefix + url );
  }
});
 
CmdUtils.CreateCommand({
  names: ["lorem","lorem ipsum"],
  icon: "http://www.mozilla.com/favicon.ico",
  description: "Inserts <a href=\"http://en.wikipedia.org/wiki/Template:Lorem_ipsum\"><i>lorem ipsum</i></a> filler text into a text box.  The number of paragraphs can be specified as an argument.",
  help: "To use this command, type the number of paragraphs you want (1 thru 10) and then just hit enter. The text was taken from <a href=\"http://en.wikipedia.org/wiki/Template:Lorem_ipsum\"><i>wikipedia</i></a> in August 2009.",
  author: {name: "Keith Kranker", email: "kranker@econ.umd.edu"},
  license: "GPL",
  homepage: "http://econ-server.umd.edu/~kranker/code/Ubiquity_Econ.php",
  arguments: [{role: 'object', nountype: noun_type_number }],
  preview: function preview(pblock, args) {
    var lorem  = new Array("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.","Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam. Maecenas fermentum consequat mi. Donec fermentum. Pellentesque malesuada nulla a mi. Duis sapien sem, aliquet nec, commodo eget, consequat quis, neque. Aliquam faucibus, elit ut dictum aliquet, felis nisl adipiscing sapien, sed malesuada diam lacus eget erat. Cras mollis scelerisque nunc. Nullam arcu. Aliquam consequat. Curabitur augue lorem, dapibus quis, laoreet et, pretium ac, nisi. Aenean magna nisl, mollis quis, molestie eu, feugiat in, orci. In hac habitasse platea dictumst.","Fusce convallis, mauris imperdiet gravida bibendum, nisl turpis suscipit mauris, sed placerat ipsum urna sed risus. In convallis tellus a mauris. Curabitur non elit ut libero tristique sodales. Mauris a lacus. Donec mattis semper leo. In hac habitasse platea dictumst. Vivamus facilisis diam at odio. Mauris dictum, nisi eget consequat elementum, lacus ligula molestie metus, non feugiat orci magna ac sem. Donec turpis. Donec vitae metus. Morbi tristique neque eu mauris. Quisque gravida ipsum non sapien. Proin turpis lacus, scelerisque vitae, elementum at, lobortis ac, quam. Aliquam dictum eleifend risus. In hac habitasse platea dictumst. Etiam sit amet diam. Suspendisse odio. Suspendisse nunc. In semper bibendum libero.","Proin nonummy, lacus eget pulvinar lacinia, pede felis dignissim leo, vitae tristique magna lacus sit amet eros. Nullam ornare. Praesent odio ligula, dapibus sed, tincidunt eget, dictum ac, nibh. Nam quis lacus. Nunc eleifend molestie velit. Morbi lobortis quam eu velit. Donec euismod vestibulum massa. Donec non lectus. Aliquam commodo lacus sit amet nulla. Cras dignissim elit et augue. Nullam non diam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In hac habitasse platea dictumst. Aenean vestibulum. Sed lobortis elit quis lectus. Nunc sed lacus at augue bibendum dapibus.","Aliquam vehicula sem ut pede. Cras purus lectus, egestas eu, vehicula at, imperdiet sed, nibh. Morbi consectetuer luctus felis. Donec vitae nisi. Aliquam tincidunt feugiat elit. Duis sed elit ut turpis ullamcorper feugiat. Praesent pretium, mauris sed fermentum hendrerit, nulla lorem iaculis magna, pulvinar scelerisque urna tellus a justo. Suspendisse pulvinar massa in metus. Duis quis quam. Proin justo. Curabitur ac sapien. Nam erat. Praesent ut quam.","Vivamus commodo, augue et laoreet euismod, sem sapien tempor dolor, ac egestas sem ligula quis lacus. Donec vestibulum tortor ac lacus. Sed posuere vestibulum nisl. Curabitur eleifend fermentum justo. Nullam imperdiet. Integer sit amet mauris imperdiet risus sollicitudin rutrum. Ut vitae turpis. Nulla facilisi. Quisque tortor velit, scelerisque et, facilisis vel, tempor sed, urna. Vivamus nulla elit, vestibulum eget, semper et, scelerisque eget, lacus. Pellentesque viverra purus. Quisque elit. Donec ut dolor.","Duis volutpat elit et erat. In at nulla at nisl condimentum aliquet. Quisque elementum pharetra lacus. Nunc gravida arcu eget nunc. Nulla iaculis egestas magna. Aliquam erat volutpat. Sed pellentesque orci. Etiam lacus lorem, iaculis sit amet, pharetra quis, imperdiet sit amet, lectus. Integer quis elit ac mi aliquam pretium. Nullam mauris orci, porttitor eget, sollicitudin non, vulputate id, risus. Donec varius enim nec sem. Nam aliquam lacinia enim. Quisque eget lorem eu purus dignissim ultricies. Fusce porttitor hendrerit ante. Mauris urna diam, cursus id, mattis eget, tempus sit amet, risus. Curabitur eu felis. Sed eu mi. Nullam lectus mauris, luctus a, mattis ac, tempus non, leo. Cras mi nulla, rhoncus id, laoreet ut, ultricies id, odio.","Donec imperdiet. Vestibulum auctor tortor at orci. Integer semper, nisi eget suscipit eleifend, erat nisl hendrerit justo, eget vestibulum lorem justo ac leo. Integer sem velit, pharetra in, fringilla eu, fermentum id, felis. Vestibulum sed felis. In elit. Praesent et pede vel ante dapibus condimentum. Donec magna. Quisque id risus. Mauris vulputate pellentesque leo. Duis vulputate, ligula at venenatis tincidunt, orci nunc interdum leo, ac egestas elit sem ut lacus. Etiam non diam quis arcu egestas commodo. Curabitur nec massa ac massa gravida condimentum. Aenean id libero. Pellentesque vitae tellus. Fusce lectus est, accumsan ac, bibendum sed, porta eget, augue. Etiam faucibus. Quisque tempus purus eu ante.","Vestibulum sapien nisl, ornare auctor, consectetuer quis, posuere tristique, odio. Fusce ultrices ullamcorper odio. Ut augue nulla, interdum at, adipiscing non, tristique eget, neque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Ut pede est, condimentum id, scelerisque ac, malesuada non, quam. Proin eu ligula ac sapien suscipit blandit. Suspendisse euismod. Ut accumsan, neque id gravida luctus, arcu pede sodales felis, vel blandit massa arcu eget ligula. Aenean sed turpis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec sem eros, ornare ut, commodo eu, tempor nec, risus. Donec laoreet dapibus ligula. Praesent orci leo, bibendum nec, ornare et, nonummy in, elit. Donec interdum feugiat leo. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque feugiat ullamcorper ipsum. Donec convallis tincidunt urna.","Suspendisse et orci et arcu porttitor pellentesque. Sed lacus nunc, fermentum vel, vehicula in, imperdiet eget, urna. Nam consectetuer euismod nunc. Nulla dignissim posuere nulla. Integer iaculis lacinia massa. Nullam sapien augue, condimentum vel, venenatis id, rhoncus pellentesque, sapien. Donec sed ipsum ultrices turpis consectetuer imperdiet. Duis et ipsum ac nisl laoreet commodo. Mauris eu est. Suspendisse id turpis quis orci euismod consequat. Donec tellus mi, luctus sit amet, ultrices a, convallis eu, lorem. Proin faucibus convallis elit. Maecenas rhoncus arcu at arcu. Proin libero. Proin adipiscing. In quis lorem vitae elit consectetuer pretium. Nullam ligula urna, adipiscing nec, iaculis ut, elementum non, turpis. Fusce pulvinar.");
    pblock.innerHTML = "<p>Inserts " + args.object.data + " paragraph(s) of <i>lorem ipsum</i> filler text:</p>" ;
    var i=0;
	while (i< args.object.data  && i<10)
		  {
		  pblock.innerHTML += "<blockquote>" + lorem[i] + "</blockquote>" ;
		  i++;
		  }
  },
  execute: function execute(args) {
    var lorem  = new Array("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.","Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam. Maecenas fermentum consequat mi. Donec fermentum. Pellentesque malesuada nulla a mi. Duis sapien sem, aliquet nec, commodo eget, consequat quis, neque. Aliquam faucibus, elit ut dictum aliquet, felis nisl adipiscing sapien, sed malesuada diam lacus eget erat. Cras mollis scelerisque nunc. Nullam arcu. Aliquam consequat. Curabitur augue lorem, dapibus quis, laoreet et, pretium ac, nisi. Aenean magna nisl, mollis quis, molestie eu, feugiat in, orci. In hac habitasse platea dictumst.","Fusce convallis, mauris imperdiet gravida bibendum, nisl turpis suscipit mauris, sed placerat ipsum urna sed risus. In convallis tellus a mauris. Curabitur non elit ut libero tristique sodales. Mauris a lacus. Donec mattis semper leo. In hac habitasse platea dictumst. Vivamus facilisis diam at odio. Mauris dictum, nisi eget consequat elementum, lacus ligula molestie metus, non feugiat orci magna ac sem. Donec turpis. Donec vitae metus. Morbi tristique neque eu mauris. Quisque gravida ipsum non sapien. Proin turpis lacus, scelerisque vitae, elementum at, lobortis ac, quam. Aliquam dictum eleifend risus. In hac habitasse platea dictumst. Etiam sit amet diam. Suspendisse odio. Suspendisse nunc. In semper bibendum libero.","Proin nonummy, lacus eget pulvinar lacinia, pede felis dignissim leo, vitae tristique magna lacus sit amet eros. Nullam ornare. Praesent odio ligula, dapibus sed, tincidunt eget, dictum ac, nibh. Nam quis lacus. Nunc eleifend molestie velit. Morbi lobortis quam eu velit. Donec euismod vestibulum massa. Donec non lectus. Aliquam commodo lacus sit amet nulla. Cras dignissim elit et augue. Nullam non diam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In hac habitasse platea dictumst. Aenean vestibulum. Sed lobortis elit quis lectus. Nunc sed lacus at augue bibendum dapibus.","Aliquam vehicula sem ut pede. Cras purus lectus, egestas eu, vehicula at, imperdiet sed, nibh. Morbi consectetuer luctus felis. Donec vitae nisi. Aliquam tincidunt feugiat elit. Duis sed elit ut turpis ullamcorper feugiat. Praesent pretium, mauris sed fermentum hendrerit, nulla lorem iaculis magna, pulvinar scelerisque urna tellus a justo. Suspendisse pulvinar massa in metus. Duis quis quam. Proin justo. Curabitur ac sapien. Nam erat. Praesent ut quam.","Vivamus commodo, augue et laoreet euismod, sem sapien tempor dolor, ac egestas sem ligula quis lacus. Donec vestibulum tortor ac lacus. Sed posuere vestibulum nisl. Curabitur eleifend fermentum justo. Nullam imperdiet. Integer sit amet mauris imperdiet risus sollicitudin rutrum. Ut vitae turpis. Nulla facilisi. Quisque tortor velit, scelerisque et, facilisis vel, tempor sed, urna. Vivamus nulla elit, vestibulum eget, semper et, scelerisque eget, lacus. Pellentesque viverra purus. Quisque elit. Donec ut dolor.","Duis volutpat elit et erat. In at nulla at nisl condimentum aliquet. Quisque elementum pharetra lacus. Nunc gravida arcu eget nunc. Nulla iaculis egestas magna. Aliquam erat volutpat. Sed pellentesque orci. Etiam lacus lorem, iaculis sit amet, pharetra quis, imperdiet sit amet, lectus. Integer quis elit ac mi aliquam pretium. Nullam mauris orci, porttitor eget, sollicitudin non, vulputate id, risus. Donec varius enim nec sem. Nam aliquam lacinia enim. Quisque eget lorem eu purus dignissim ultricies. Fusce porttitor hendrerit ante. Mauris urna diam, cursus id, mattis eget, tempus sit amet, risus. Curabitur eu felis. Sed eu mi. Nullam lectus mauris, luctus a, mattis ac, tempus non, leo. Cras mi nulla, rhoncus id, laoreet ut, ultricies id, odio.","Donec imperdiet. Vestibulum auctor tortor at orci. Integer semper, nisi eget suscipit eleifend, erat nisl hendrerit justo, eget vestibulum lorem justo ac leo. Integer sem velit, pharetra in, fringilla eu, fermentum id, felis. Vestibulum sed felis. In elit. Praesent et pede vel ante dapibus condimentum. Donec magna. Quisque id risus. Mauris vulputate pellentesque leo. Duis vulputate, ligula at venenatis tincidunt, orci nunc interdum leo, ac egestas elit sem ut lacus. Etiam non diam quis arcu egestas commodo. Curabitur nec massa ac massa gravida condimentum. Aenean id libero. Pellentesque vitae tellus. Fusce lectus est, accumsan ac, bibendum sed, porta eget, augue. Etiam faucibus. Quisque tempus purus eu ante.","Vestibulum sapien nisl, ornare auctor, consectetuer quis, posuere tristique, odio. Fusce ultrices ullamcorper odio. Ut augue nulla, interdum at, adipiscing non, tristique eget, neque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Ut pede est, condimentum id, scelerisque ac, malesuada non, quam. Proin eu ligula ac sapien suscipit blandit. Suspendisse euismod. Ut accumsan, neque id gravida luctus, arcu pede sodales felis, vel blandit massa arcu eget ligula. Aenean sed turpis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec sem eros, ornare ut, commodo eu, tempor nec, risus. Donec laoreet dapibus ligula. Praesent orci leo, bibendum nec, ornare et, nonummy in, elit. Donec interdum feugiat leo. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque feugiat ullamcorper ipsum. Donec convallis tincidunt urna.","Suspendisse et orci et arcu porttitor pellentesque. Sed lacus nunc, fermentum vel, vehicula in, imperdiet eget, urna. Nam consectetuer euismod nunc. Nulla dignissim posuere nulla. Integer iaculis lacinia massa. Nullam sapien augue, condimentum vel, venenatis id, rhoncus pellentesque, sapien. Donec sed ipsum ultrices turpis consectetuer imperdiet. Duis et ipsum ac nisl laoreet commodo. Mauris eu est. Suspendisse id turpis quis orci euismod consequat. Donec tellus mi, luctus sit amet, ultrices a, convallis eu, lorem. Proin faucibus convallis elit. Maecenas rhoncus arcu at arcu. Proin libero. Proin adipiscing. In quis lorem vitae elit consectetuer pretium. Nullam ligula urna, adipiscing nec, iaculis ut, elementum non, turpis. Fusce pulvinar.");
    var insert_text = "";
    var i=0;
	while (i< args.object.data  && i<10 )
		  {
		  insert_text += "<p>" + lorem[i] + "</p>" ;
		  i++;
		  }
    CmdUtils.setSelection(insert_text);
  }
});

CmdUtils.makeSearchCommand({
  name: "scholar",
  author: { name: "Keith Kranker"},
  homepage: "http://econ-server.umd.edu/~kranker/code/Ubiquity_Econ.php",
  url: "http://www.google.com/scholar?q={QUERY}",
  icon: "http://www.google.com/favicon.ico",
  description: "Search Google Scholar.  No preview."
});
