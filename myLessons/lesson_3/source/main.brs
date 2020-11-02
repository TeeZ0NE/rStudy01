sub main()
  screen = CreateObject("roSGScreen")
  scene = screen.createScene("home_scene")
  screen.show()
  port = CreateObject("roMessagePort")
  screen.setMessagePort(port)
  ' Loop 4 keeps open screen
  while true
    msg = port.GetMessage() ' get a message, if available
    if type(msg) = "roUniversalControlEvent" then
      print "button pressed: ";msg.GetInt()
    end if
  end while
end sub