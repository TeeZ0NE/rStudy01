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
  ' http.setCertificatesFile("common:/certs/ca-bundle.crt")
  http.InitClientCertificates()
  http.enablehostverification(false)
  http.enablepeerverification(false)
  http.setUrl(url)
  if http.AsyncGetToString() then
    msg = wait(5000, port)
    if (Type(msg) = "roUrlEvent")
      if (msg.GetResponseCode() > 0 and msg.GetResponseCode() < 400)
        m.top.response = msg.GetString()
      else
        m.top.error = msg.GetFailureReason() + Chr(10) + "Code: " + msg.GetResponseCode().toStr()
      end if
      http.AsyncCancel()
    else if (msg = invalid)
      m.top.error = "Fail load movies"
      http.asynccancel()
    end if
  end if
end function