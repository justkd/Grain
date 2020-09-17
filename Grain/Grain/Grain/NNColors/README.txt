NNColors
by Danny Holmes
danny.notnatural.co

Copyright (c) 2015 Danny Holmes, notnatural.co.
Licensed under the MIT license.

NNColors comprises of:

NNColorThemePicker
NNColorThemes
UIColor+NNColors

The collections provides instant access to a multitude of pre-defined modern color themes to be used in iOS projects.

UIColor+NNColors combines and extends UIColor+MLPFlatColors.h and UIColor+HBVHarmonies.h to provide easy access to modern flat colors with high customization.

NNColorThemes incorporates modern color themes from various sources wrapped into an accessible cocoa touch class. Create an instance of NNColorThemes, choose a theme, and conveniently access the colors via an array.

NNColorThemePicker provides a front-end UI for picking and customizing themes from NNColorThemes. NNColorThemePicker uses KGModal.

TODO: 
-	Add more themes.
-	Add more flat colors.
-	Fix interactions in NNColorThemePicker
	-	show/save hex values for customized themes
	-	save customized themes (?)


Instructions

See Demo Project for detailed examples, but:

- Most basic use of NNColorThemes

	Import NNColorThemes.h
	Pick a theme (look at the methods available and included guide pdfs)
	Create a theme in your project e.g.:

	NSArray *theme = [NNColorThemes	nnLamplight];

	Access the five colors:

	UIColor *c1 = theme[0];
	UIColor *c2 = theme[1];
	etc.
