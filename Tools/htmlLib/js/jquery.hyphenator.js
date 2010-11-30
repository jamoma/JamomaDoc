/*
 * Copyright (c) 2009, webvariants GbR, http://www.webvariants.de
 *
 * This file is published under the MIT license. The license text is contained
 * in the attached LICENSE file and online available at:
 *
 * http://www.opensource.org/licenses/mit-license.php
 */

/**
 * jQuery Hyphenator Plugin
 *
 * This plugin integrates the Hyphenator, written for client-side hyphenation of
 * texts on websites. The project itself is located at Google Code and published
 * under the LGPL.
 * The required patterns are loaded dynamically from Google Code. To increase 
 * performance, it is possible to do some optimizations and serve the Patterns by 
 * yourselve. See http://code.google.com/p/hyphenator/wiki/en_Optimizations for
 * details and the full source code.
 *
 * Installation:
 * Load the files hyphenator.min.js and jquery.hyphenator.min.js in the HTML-head.
 * 
 * Usage:
 *
 *   $('p, ol, ul').hyphenate();
 *
 * It's possible to add your own options (see
 * http://code.google.com/p/hyphenator/wiki/en_PublicAPI for a list of all
 * allowed options):
 *
 *   $('p').hyphenate({hyphenchar: '|'});
 *
 * It's recommended that you add the minimized version of this plugin to your
 * website, to reduce loading time. So use the jquery.hyphenator.min.js file.
 *
 * @author    Christoph Mewes, Dave Gööck
 * @license   MIT (http://www.opensource.org/licenses/mit-license.php)
 * @copyright webvariants GbR (http://www.webvariants.de)
 * @version   1.1.0
 */
(function($) {
	$.fn.hyphenate = function(options) {
		var myself = this;
		settings = {
			selectorfunction: function() { return myself; },
			intermediatestate: 'visible'
		};
		
		if (options) {
			$.extend(settings, options);
		}
		
		Hyphenator.config(settings);
		Hyphenator.run();
		
		return this;
	}
})(jQuery);
