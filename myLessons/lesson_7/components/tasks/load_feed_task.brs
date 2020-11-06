sub init() as void
  m.top.functionname = "request"
  m.top.response = ""
end sub

function request() as void
  url = m.top.url
  http = createObject("roUrlTransfer")
  http.RetainBodyOnError(true)
  port = createObject("roMessagePort")
  http.setPort(port)
  http.setCertificatesFile("common:/certs/ca-bundle.crt")
  http.InitClientCertificates()
  http.enablehostverification(false)
  http.enablepeerverification(false)
  http.setUrl(url)
  if http.AsyncGetToString() then
    msg = wait(10000, port)
    if (type(msg) = "roUrlEvent")
      'HTTP response code can be <0 for Roku errors
      if (msg.getresponsecode() > 0 and msg.getresponsecode() < 400)
        m.top.response = msg.getstring()
      else
        m.top.error = "Feed failed to load!" + chr(10) + chr(10) + "Reason: " + msg.getfailurereason() + chr(10) + "Code: " + msg.getresponsecode().toStr() + chr(10) + "URL: " + m.top.url
      end if
      http.asynccancel()
    else if (msg = invalid)
      m.top.error = "feed load failed."
      http.asynccancel()
    end if
  end if
end function
