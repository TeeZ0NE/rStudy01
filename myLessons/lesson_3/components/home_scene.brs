function init()
  ? "[home_scene] init"
  m.center_square = m.top.findNode("category_screen")
  ' m.obj = CreateObject("roSGNode", "category_screen")
  ' m.top.appendChild(m.obj)

  ' ? m.center_square
  m.center_square.setFocus(true)
end function

function onKeyEvent(key as string, press as boolean) as boolean
  ? "[home_scene] onKeyEvent", key, press
  return false
end function

function A(a as integer) as void
  ? a;type(a)
end function

function B(b as object) as void
  ? b[0];type(b)
end function