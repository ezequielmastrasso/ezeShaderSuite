##ezeDelight Shader Suite


####Please Read: 



###Want to Contribute?

With images? have a cool character or scene you wanna show? send it on.
I would love to know how you getting with the shaders, and the images done with it!

With code? Awesome! please do get in contact with me or branch out right away!

Having a good or a bad experience? either way i want to hear from you.

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
#### v2.0
##### big Changes!!!
##### ezeHair re writtne as fully traced, working with 3delight studio 11 new raytracer
##### Documentation updated to match the new shaders parameters
##### ezeEnvironment removed ezeBake:<br />

#### v1.8
##### all ezeShaders:<br />
  -ezeEnv removed, update to 3delight Studio 11 just raytrace it!
  -ezeBake removed, again.. raytracing is what the cool kids are doing now-a-days!
  (tip: set the hair geometry to be opaque to all raytrace rays to avoid transparency
  to make your rendertimes explode!!)
  -ezeShave7 is now the current main shader, the <v7 shader was removed.

  -<br />


#### v1.4
##### ezeSurface:<br />
  -energy conserving (diffuse, sss, spec, refl and refr balance)<br />
  -diffuse models simplified, only 1 diffuse model (cook torrance)<br />
  -specular models simplified, only 2 models (cook torrance and ward)<br />
  -more opacity controls<br />


##### ezeIndirect:<br />
  -full raytrace solution if ptc based workflow is unchecked<br />

##### ezeHair:
  -energy conserving<br />

##### ezeCommon:
  -texture code calls improved and merged with ezeHair shader ones to standarize<br />

#### v1.21 


Coming soon
---------------
##### ezeSurface:<br />
  *-fresnel affects diffuse
  *-reflections performance improvements<br />
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

##### ezeHair:
  *-varying variables optimizations<br />
  *-needs better gi solution (works well for short hair but not accurate for long)
