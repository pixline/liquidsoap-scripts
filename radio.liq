#!/usr/bin/liquidsoap

#set("server.telnet",true)
#set("server.telnet.port",8001)
#set("server.telnet.bind_addr","192.168.10.0")

#set("buffering.kind","disk_manyfiles")
#set("decoding.buffer_length",50.)

def audio_process(s)
  gain = interactive.float("compress.gain",3.)
  ratio = 3. # interactive.float("compress.ratio",3.)
  threshold = interactive.float("compress.threshold",-15.)

  target = interactive.float("norm.target",-13.)
  k_up = interactive.float("norm.kup",0.005)
  k_down = interactive.float("norm.kdn",0.1)

  s = normalize(target=target,k_up=k_up,k_down=k_down,s)
  s = compress(gain=gain,ratio=ratio,threshold=threshold,s)
  s
end

enable_replaygain_metadata()

randomloop = mksafe( playlist( reload=600, "/home/audio/music", mode="random" ) )
s = skip_blank(length=7.,randomloop)

s = rewrite_metadata([("title","$(title)"),
                      ("comment","")],s)

#promo = playlist.safe("/home/audio/promo", mode="random")
#radio = random( weights = [1,4], [ delay(700.,promo), randomloop ])
#output.alsa(id="audioloop",bufferize=true,device="hw:1", radio)

s = audio_process(s)

output.icecast(%vorbis(quality=0.9, samplerate=44100, channels=2), 
	host="liveserver",
	port=8000,
	mount='radio.ogg',
	genre='Radio',
#	restart="true",
	password="password",
	url="http://localhost",
	description="Radio",
	timeout=1200.,
	s	
)
