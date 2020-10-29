sub init()
    m.PARTICLE_DELAY = 0.1
    m.PARTICLES_COUNT = 150
    m.timer = m.top.findNode("timer")
    m.timer.observeField("fire", "update")
    m.particles = []
    m.particleDelay = rnd(0) * m.PARTICLE_DELAY
    m.time = 0
    deviceInfo = CreateObject("roDeviceInfo")
    m.screenWidth = deviceInfo.GetDisplaySize().w
    m.screenHeight = deviceInfo.GetDisplaySize().h
    m.area = {x: 0, y: 0, width: m.screenWidth, height: 0}
    m.timespan = CreateObject("roTimespan")
end sub

sub start()
    m.timer.control = "start"
    m.timespan.mark()
end sub

sub stopSystem()
    m.timer.control = "stop"
end sub

sub update()
    print m.timespan.totalMilliseconds()
    m.time += m.timer.duration
    if m.time > m.particleDelay and m.particles.count() < m.PARTICLES_COUNT then
        particle = createObject("roSGNode", "Particle")
        particle.callFunc("setParams", {screenWidth: m.screenWidth, screenHeight: m.screenHeight, area: m.area})
        m.top.appendChild(particle)
        m.particles.push(particle)
        m.particleDelay = rnd(0) * m.PARTICLE_DELAY
        m.time = 0
    end if
    for i = m.particles.count() - 1 to 0 step -1
        particle = m.particles[i]
        particle.callFunc("update", m.timer.duration)
        if particle.callFunc("isDead") then
            particle.callFunc("reset")
        end if
    end for
    m.timespan.mark()
end sub