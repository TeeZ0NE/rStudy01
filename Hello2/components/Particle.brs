sub init()
    m.particle = m.top.findNode("particle")
end sub

sub reset()
    m.translation = [random(m.area.x, m.area.width), random(m.area.y, m.area.height)]
    m.velocity = [random(-3, 3), random(2, 5)]
    m.acceleration = [0, 0]
    m.lifetime = 20
    display()
end sub

sub setParams(params as object)
    m.screenWidth = params.screenWidth
    m.screenHeight = params.screenHeight
    m.area = params.area
    reset()
    display()
end sub

sub update(dt as float)
    m.velocity[0] +=  m.acceleration[0]
    m.velocity[1] +=  m.acceleration[1]
    m.translation[0] +=  m.velocity[0]
    m.translation[1] +=  m.velocity[1]
    m.lifetime -= dt
    display()
end sub

sub display()
    m.particle.translation = m.translation
end sub

function isDead() as boolean
    t = m.particle.translation
    return m.lifetime < 0 or t[0] < 0 - 20 or t[0] > m.screenWidth or t[1] > m.screenHeight + 20
end function

function random(min, max) as float
    return rnd(0) * (max - min) + min
end function