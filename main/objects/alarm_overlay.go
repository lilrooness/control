components {
  id: "alarm_overlay"
  component: "/main/scripts/alarm_overlay.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "tile_set: \"/main/main.atlas\"\n"
  "default_animation: \"blank_128\"\n"
  "material: \"/assets/materials/alarm_overlay_mat/alarm_overlay.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: -64.0
    y: -64.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "sound"
  type: "sound"
  data: "sound: \"/assets/sfx/high_2_tone.wav\"\n"
  "looping: 1\n"
  "group: \"master\"\n"
  "gain: 0.15\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
