##ezeShaderSuite 3delight


####Please Read: 


#####Check the Develop Branch for the latests tested commits!

###Want to Contribute?

With code? Awesome! please do get in contact with me or branch out right away!

With images? have a cool character or scene you wanna show? send it on.
I would love to know how you getting with the shaders, and the images done with it!


License
---------------
Feel free to copy it for use, or modify it as you like.You may not resell this software,
but you may freely distribute it to others. You may use it for whatever purposes you wish.
There are no warranties of any kind. You may make modifications, however any derivation 
may only be distributed to others under the same freedoms granted to you herein, it must
retain this notice and agreement, and the modifications noted. I also ask that you make
such modifications available to me and to the online community as a whole through a public
forum.

changeLog
---------------
#### v1.XXX
##### ezeSurface:<br />
  -energy conserving (diffuse, sss, spec, refl and refr balance)<br />
  -diffuse models simplified, only 1 diffuse model (cook torrance)<br />
  *-specular models simplified, only 2 models (cook torrance and ward)<br />
  *-fresnel affects diffuse
  *-reflections performance improvements<br />
  *-more opacity controls<br />
  *-refractions<br />
  *-specular ward anisotropy parameter<br />
  *-specular reflections based on BRDF<br />
  *-reflection and refraccion end color<br />
  *-reflection and refraccion end color use environment map<br />
  **-back light<br />
  *-diffuse bump only check box
  **-diffuse/spec/reflection balance mode option<br />
  **-indirect spots to control indirect diffuse effects<br />
  *-sssCutOut (black and white map)<br />
  *-sssThreshold<br />
      ---if (sssMap>sssThreshold && sssCutOut>.5)<br />
  *-indirect specular<br />
  *-internal reflections on off<br />
  *-reflection depth<br />
  *-normal mapping<br />
  *-emision<br />
  *-bounce factor<br />

##### ezeIndirect:<br />
  -full raytrace solution if ptc based workflow is unchecked<br />

##### ezeHair:
  *-energy conserving<br />
  *-varying variables optimizations<br />
  *-needs better gi solution than using from P N_srf! (works for short hair but not for long

##### ezeCommon:
  *-texture code calls improved and merged with ezeHair shader ones to standarize<br />

#### v1.21 
