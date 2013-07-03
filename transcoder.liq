# transcode incoming audio stream to multiple formats
# GPL2 2009+ pixline

########################
# settings and options #
########################

# debug options

#set("log.file.path","/var/log/liquidsoap/transcoding.log")
#set("decoder.debug",true)
#set("log.level", 6)

# latency-related settings

#set("frame.duration",0.04)
#set("root.max_latency",60.)

# harbor settings
set("harbor.bind_addr","0.0.0.0")
set("harbor.reverse_dns",true)
set("harbor.timeout",30.)
#set("harbor.password","h4rb0r")
#set("harbor.port",8000)

# telnet control server settings
set("server.telnet.bind_addr","127.0.0.1")
set("server.telnet.port",10011)
set("server.telnet.reverse_dns",false)

# experimental: direct ssh socket
#set("server.socket",true) 
#set("server.socket.path","/var/run/liquidsoap/transcoder.socket")

###########################
# target stream server(s) #
###########################

# let's define input
harbor = input.harbor("/uplink.ogg", buffer=9.)
stream =  mksafe(harbor)
clock.assign_new(sync=false,[stream])

# liquidsoap FLOWS!

# native OGG replay
stream = register_flow(
  radio="Radio - ogg stream",
  website="http://localhost/",
  description="Radio Description",
  genre="Radio",
  streams=[("ogg/120k","http://localhost/output.ogg")],
  stream)

# MP3 transcoding

output.icecast(%mp3(bitrate=80, samplerate = 44100, mono, stereo=false), 
    mount="/output.mp3", 
    name="Radio - mp3 stream",
    url="http://localhost",
    description="Radio Description",
    genre="Radio",
    host="127.0.0.1", port=80, password="s0urc3",
    restart=true, restart_delay=10,
    stream )


# include archiver.liq here, if they run on the same server
