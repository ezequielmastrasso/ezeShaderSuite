volume ezeBakeRef(
                    #pragma annotation "grouping" "ezeBake/ptcFile;"
                    #pragma annotation "grouping" "ezeBake/bakeSpace;"
                    #pragma annotation "grouping" "ezeBake/radiusscale;"
                    string ptcFile= "<project>/3delight/<scene>/<scene>_sceneGeom.#.ptc";
                    string bakeSpace= "world";
                    float radiusscale=1.77;)

{
    if(ptcFile != "") {
        bake3d(ptcFile, "", P, N, "_radiosity", Ci, "interpolate", 1, "radiusscale", radiusscale,"coordsystem", bakeSpace);
    }
}
