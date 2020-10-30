function init()
  ? "[home_scene] init"
  m.top.backgroundURI = ""
  m.top.backgroundColor = "0xFFFFFF00"
  m.center_square = m.top.findNode("center_square")
  m.center_square.setFocus(true)
  m.label = m.top.findNode("label_hello")
  ' ? m.label.text
  A(10)
  B([1, 2, 3])
  ' ? m.center_square
end function

function A(a as integer) as void
  ? a;type(a)
end function

function B(b as object) as void
  ? b[0];type(b)
end function