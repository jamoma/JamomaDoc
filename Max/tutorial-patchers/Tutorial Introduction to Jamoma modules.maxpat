{
	"patcher" : 	{
		"fileversion" : 1,
		"rect" : [ 75.0, 91.0, 520.0, 627.0 ],
		"bglocked" : 0,
		"defrect" : [ 75.0, 91.0, 520.0, 627.0 ],
		"openrect" : [ 0.0, 0.0, 0.0, 0.0 ],
		"openinpresentation" : 0,
		"default_fontsize" : 10.0,
		"default_fontface" : 0,
		"default_fontname" : "Verdana",
		"gridonopen" : 0,
		"gridsize" : [ 5.0, 5.0 ],
		"gridsnaponopen" : 0,
		"toolbarvisible" : 1,
		"boxanimatetime" : 200,
		"imprint" : 0,
		"boxes" : [ 			{
				"box" : 				{
					"maxclass" : "bpatcher",
					"numinlets" : 3,
					"presentation_rect" : [ 0.0, 0.0, 300.0, 140.0 ],
					"numoutlets" : 1,
					"args" : [ "/myoutput~" ],
					"patching_rect" : [ 70.0, 225.0, 300.0, 140.0 ],
					"outlettype" : [ "" ],
					"id" : "obj-5",
					"name" : "jmod.output~.maxpat"
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "bpatcher",
					"numinlets" : 1,
					"presentation_rect" : [ 0.0, 0.0, 300.0, 140.0 ],
					"numoutlets" : 3,
					"args" : [ "/myinput~" ],
					"patching_rect" : [ 70.0, 55.0, 300.0, 140.0 ],
					"outlettype" : [ "", "signal", "signal" ],
					"id" : "obj-3",
					"name" : "jmod.input~.maxpat"
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"source" : [ "obj-3", 2 ],
					"destination" : [ "obj-5", 2 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-3", 1 ],
					"destination" : [ "obj-5", 1 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
 ]
	}

}
