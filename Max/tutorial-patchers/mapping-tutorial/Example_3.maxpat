{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 5,
			"minor" : 1,
			"revision" : 9
		}
,
		"rect" : [ 0.0, 44.0, 1440.0, 747.0 ],
		"bglocked" : 0,
		"defrect" : [ 0.0, 44.0, 1440.0, 747.0 ],
		"openrect" : [ 0.0, 0.0, 0.0, 0.0 ],
		"openinpresentation" : 0,
		"default_fontsize" : 10.0,
		"default_fontface" : 0,
		"default_fontname" : "Verdana",
		"gridonopen" : 0,
		"gridsize" : [ 15.0, 15.0 ],
		"gridsnaponopen" : 0,
		"toolbarvisible" : 1,
		"boxanimatetime" : 200,
		"imprint" : 0,
		"enablehscroll" : 1,
		"enablevscroll" : 1,
		"devicewidth" : 0.0,
		"boxes" : [ 			{
				"box" : 				{
					"fontname" : "Verdana",
					"fontsize" : 20.0,
					"frgb" : [ 0.0, 0.0, 0.0, 1.0 ],
					"id" : "obj-9",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 539.0, 363.0, 253.0, 55.0 ],
					"text" : "<- 1.press here to load the mappings:"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Verdana",
					"fontsize" : 20.0,
					"frgb" : [ 0.0, 0.0, 0.0, 1.0 ],
					"id" : "obj-5",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 632.0, 440.0, 319.0, 55.0 ],
					"text" : "<- 2.use the dropdown menu to change mappings"
				}

			}
, 			{
				"box" : 				{
					"args" : [ "/mapper.2" ],
					"id" : "obj-10",
					"maxclass" : "bpatcher",
					"name" : "jmod.mapperContinuous.maxpat",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 169.0, 270.0, 600.0, 70.0 ],
					"presentation_rect" : [ 15.0, 15.0, 600.0, 70.0 ]
				}

			}
, 			{
				"box" : 				{
					"args" : [ "/mapper.1" ],
					"id" : "obj-8",
					"maxclass" : "bpatcher",
					"name" : "jmod.mapperContinuous.maxpat",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 169.0, 188.0, 600.0, 70.0 ],
					"presentation_rect" : [ 15.0, 15.0, 600.0, 70.0 ]
				}

			}
, 			{
				"box" : 				{
					"args" : [ "input.3" ],
					"bgmode" : 1,
					"id" : "obj-4",
					"maxclass" : "bpatcher",
					"name" : "jmod.input~.maxpat",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "signal", "signal" ],
					"patching_rect" : [ 621.0, 22.0, 300.0, 140.0 ],
					"presentation_rect" : [ 669.0, 111.0, 300.0, 140.0 ]
				}

			}
, 			{
				"box" : 				{
					"args" : [ "input.2" ],
					"bgmode" : 1,
					"id" : "obj-3",
					"maxclass" : "bpatcher",
					"name" : "jmod.input~.maxpat",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "signal", "signal" ],
					"patching_rect" : [ 319.0, 22.0, 300.0, 140.0 ],
					"presentation_rect" : [ 399.0, 111.0, 300.0, 140.0 ]
				}

			}
, 			{
				"box" : 				{
					"args" : [ "input.1" ],
					"bgmode" : 1,
					"id" : "obj-2",
					"maxclass" : "bpatcher",
					"name" : "jmod.input~.maxpat",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "signal", "signal" ],
					"patching_rect" : [ 17.0, 22.0, 300.0, 140.0 ],
					"presentation_rect" : [ 129.0, 111.0, 300.0, 140.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Verdana",
					"fontsize" : 10.0,
					"id" : "obj-12",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 326.0, 369.0, 190.0, 17.0 ],
					"text" : "/load Example_3_cuelist.txt, /cue 1"
				}

			}
, 			{
				"box" : 				{
					"args" : [  ],
					"bgmode" : 1,
					"id" : "obj-1",
					"maxclass" : "bpatcher",
					"name" : "jmod.cueManager.maxpat",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 326.0, 425.0, 300.0, 70.0 ],
					"presentation_rect" : [ 825.0, 322.0, 300.0, 70.0 ]
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 0 ],
					"hidden" : 0,
					"midpoints" : [  ],
					"source" : [ "obj-12", 0 ]
				}

			}
 ]
	}

}
